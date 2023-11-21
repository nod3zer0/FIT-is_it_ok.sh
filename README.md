# ISA-is_it_ok.sh

This is edited version of original script from IPP written by Ing. Zbynek Krivka Ph.D.
This script is used for checking if submitted archive has all formal requirements.

## Usage

- Usage: ./is_it_ok.sh  ARCHIVE  TESTDIR \[--force\]
  - ARCHIVE - the filename of archive to check
  - TESTDIR - temporary directory that can be deleted/removed during testing!
  - --force - do not ask and rewrite existing directory - optional

## What is checked

- presence of README
- presence of manual.pdf
- presence of Makefile
- correct file name
- correct file type
- compilation with make


# merlin_test.sh

WORK IN PROGRESS - use at your own risk

This script will copy archive to merlin with is_it_ok.sh and run it there. It will also create testdir if it does not exist in user home directory (that's where the files are copied). This dir can be edited inside the script in varriable `TESTDIR`.

It supports password authentication (it will take login from filename) and ssh key authentication if second argument is provided with ssh profile.

## Usage

- Usage: ./merlin_test.sh  ARCHIVE  \[SSH_PROFILE\]
  - ARCHIVE - the filename of archive to check
  - SSH_PROFILE - ssh profile for merlin - optional


# IPK-is_it_ok.sh

TODO

# IAL-is_it_ok.sh

TODO


# TODO

- [ ] config file for each assignment
  - [ ] checking correct binary name
  - [ ] assignment specific tests
- [ ] checking if files have correct headers
- [ ] checking contents of README
- [ ] checking contents of manual.pdf
- [ ] other subjects (IPK, IAL, etc...)
- [x] automatic testing on merlin

