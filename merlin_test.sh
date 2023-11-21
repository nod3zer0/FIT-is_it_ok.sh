#!/usr/bin/env bash

# WORK IN PROGRESS - use at your own risk
# This script will copy archive to merlin with is_it_ok.sh and run it there.
# It will also create testdir on merlin in user home directory.

# Autor: René <nod3zer0>
# Verze: 1.00
#  2023-11-21  Zverejnena prvni verze

TESTDIR="~/testdir"


# use password authentication
if [[ $# -eq 1 ]]; then

# get login from file name
login=`echo "$1" | cut -d'.' -f1`;

#create testdir on merlin in user home directory
ssh $login@merlin.fit.vutbr.cz "mkdir -p $TESTDIR";
# copy archive and is_it_ok.sh to merlin
scp $1 is_it_ok.sh $login@merlin.fit.vutbr.cz:$TESTDIR;
# run is_it_ok.sh on merlin
ssh $login@merlin.fit.vutbr.cz "cd $TESTDIR; ./is_it_ok.sh $1 testdir --force";

elif [[ $# -eq 2 ]]; then # use public key authentication

#create testdir on merlin in user home directory
ssh $2 "mkdir -p $TESTDIR";
# copy archive and is_it_ok.sh to merlin
scp $1 is_it_ok.sh $2:$TESTDIR;
# run is_it_ok.sh on merlin
ssh $2 "cd $TESTDIR; ./is_it_ok.sh $1 testdir --force";

else # print help
echo "This script will copy archive to merlin with is_it_ok.sh and run it there.";
echo "It will also create testdir on merlin in user home directory.";
echo "Usage: $0 <archive> [<ssh profile for public key auth>]";
echo "Example: $0 xlogin00.tar";
echo "Example: $0 xlogin00.tar merlin";

fi
