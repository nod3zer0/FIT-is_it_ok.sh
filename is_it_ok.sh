#!/usr/bin/env bash

# This script is heavily inspired by script from Ing. Zbynek Krivka Ph.D., that is used in IPP course.

# pouziti:   is_it_ok.sh xlogin01-XYZ.zip testdir
#
#   - POZOR: obsah adresare zadaneho druhym parametrem bude po dotazu VYMAZAN (nebo s volbou --force)!
#   - rozbali archiv studenta xlogin99.zip do adresare testdir a overi formalni pozadavky pro odevzdani projektu ISA
#   - nasledne vyzkousi sestaveni (make)
#   - detaily prubehu jsou logovany do souboru is_it_ok.log v adresari testdir

# Autor: René <nod3zer0>
# Verze: 1.00
#  2023-11-21  Zverejnena prvni verze

LOG="is_it_ok.log"
COURSE="ISA"

# Konstanty barev
REDCOLOR='\033[1;31m'
GREENCOLOR='\033[1;32m'
BLUECOLOR='\033[1;34m'
NOCOLOR='\033[0m' # No Color

# Funkce: vypis barevny text
function echo_color () { # $1=color $2=text [$3=-n]
    COLOR=$NOCOLOR
    if [[ $1 == "red" ]]; then
        COLOR=$REDCOLOR
        elif [[ $1 == "blue" ]]; then
        COLOR=$BLUECOLOR
        elif [[ $1 == "green" ]]; then
        COLOR=$GREENCOLOR
    fi
    echo -e $3 "$COLOR$2$NOCOLOR"
}

# Funkce: patri polozka do pole? (ze seznamu hodnot $* (parametry) hleda prvni parametr v ostatnich parametrech)
function member ()
{
    local -a arr=($*)
    for i in $(seq 1 $#);
    do
        if [ "${arr[$i]}" = "$1" ];
        then
            return 0
        fi
    done
    return 1
}

#   Pri nedostatku parametru (povinnych) vypis napovedu
if [[ $# -lt 2 ]]; then
    echo_color red "ERROR: Missing arguments or too much arguments!"
    echo "Usage: $0  ARCHIVE  TESTDIR [--force]"
    echo "       This script checks formal requirements for archive with solution of $COURSE project."
    echo "         ARCHIVE - the filename of archive to check"
    echo "         TESTDIR - temporary directory that can be deleted/removed during testing!"
    echo "         --force - do not ask and rewrite existing directory - optional"
    exit 2
fi

declare -i ERRORS=0
declare -a REQUIRED_SCRIPTS=( $PARSESCRIPT $INTERPRETSCRIPT )
declare -a NON_REQUIRED_SCRIPTS=()
declare -i FORCE=0

#   Zpracovani nepovinneho parametru --force
if [[ -n $3 ]]; then
    if [[ $3  = "--force" ]]; then
        FORCE=1
    fi
fi

#   Extrakce archivu
function unpack_archive () {
    local ext=`echo $1 | cut -d . -f 2,3`
    echo -n "Archive extraction: "
    RETCODE=100
    #check file type with FILE
    file $1 | grep -q "POSIX tar archive"
    if [[ $? -eq 0 ]]; then
        if [[ "$ext" = "tar" ]]; then
            tar -xf $1 >> $LOG 2>&1
            RETCODE=$?
        fi
    else
        #unsupported file type
        RETCODE=200
    fi
    if [[ $RETCODE -eq 0 ]]; then
        echo_color green OK
        elif [[ $RETCODE -eq 100 ]]; then
        echo_color red "ERROR (unsupported extension (should be tar))"
        exit 1
        elif [[ $RETCODE -eq 200 ]]; then
        echo_color red "ERROR (unsupported file type (use tar -cf not tar -czf))"
        exit 1
    else
        echo_color red "ERROR (code $RETCODE)"
        exit 1
    fi
}

#   Priprava testdir
if [[ -d $2 ]]; then
    if [[ $FORCE -eq 1 ]]; then
        rm -rf $2 2>/dev/null
    else
        read -p "Do you want to delete $2 directory? (y/n)" RESP
        if [[ $RESP = "y" ]]; then
            rm -rf $2 2>/dev/null
        else
            echo_color red "ERROR:" -n
            echo "User cancelled rewriting of existing directory."
            exit 2
        fi
    fi
fi
mkdir $2 2>/dev/null
cp $1 $2 2>/dev/null


#   Overeni serveru (ala Eva neni Merlin)
echo -n "Testing on Merlin: "
HN=`hostname`
if [[ $HN = "merlin.fit.vutbr.cz" ]]; then
    echo_color green "Yes"
else
    echo_color blue "No"
fi

#   Kontrola jmena archivu
cd $2
touch $LOG
ARCHIVE=`basename $1`
NAME=`echo $ARCHIVE | cut -d . -f 1 | grep -E "^x[a-z]{5}[0-9][0-9a-z]$"`
echo -n "Archive name ($ARCHIVE): "
if [[ -n $NAME ]]; then
    echo_color green "OK"
else
    echo_color red "ERROR (the name $NAME does not correspond to a login)"
    let ERROR=ERROR+1
fi

#   Extrahovat do testdir
unpack_archive ${ARCHIVE}

#   Dokumentace
echo -n "Searching for manual.pdf: "
if [ -f "manual.pdf" ]; then
    echo_color blue "OK (manual.pdf found)"
else
    echo_color red "ERROR (not found; required manual.pdf!)"
    let ERROR=ERROR+1
fi
echo -n "Searching for README: "
if [ -f "README" ]; then
    echo_color blue "OK (README found)"
else
    echo_color red "ERROR (not found; required README!)"
    let ERROR=ERROR+1
fi

#   Sestaveni scriptu
echo "Scripts execution test (--help): "
if [[ -f "Makefile" ]]; then
    echo_color blue "OK (Makefile found)"
    make;
    if [[ $? -eq 0 ]]; then
        echo_color green "OK (make)"
    else
        echo_color red "ERROR (make)"
        let ERROR=ERROR+1
    fi
else
    echo_color red "ERROR (not found; required Makefile!)"
    let ERROR=ERROR+1
fi

#   Kontrola adresare __MACOSX
if [[ -d __MACOSX ]]; then
    echo_color blue "Archive ($ARCHIVE) should not contain (hidden) __MACOSX directory!"
    let ERROR=ERROR+1
fi

echo -n "ALL CHECKS COMPLETED"
if [[ $ERROR -eq 0 ]]; then
    echo_color green " WITHOUT ERRORS!"
    # Vse je OK
    exit 0
    elif [[ $ERROR -eq 1 ]]; then
    echo_color red " WITH $ERROR ERROR!"
    # Vyskytla se chyba!
    exit 1
else
    echo_color red " WITH $ERROR ERRORS!"
    # Vyskytlo se vice chyb!
    exit 1
fi
