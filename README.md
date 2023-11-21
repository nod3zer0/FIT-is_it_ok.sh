# is_it_ok.sh (ISA-version)

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


## TODO

- [ ] config file for each assignment
  - [ ] checking correct binary name
  - [ ] assignment specific tests
- [ ] checking if files have correct headers
- [ ] checking contents of README
- [ ] checking contents of manual.pdf
- [ ] auto-testing on merlin
- [ ] other subjects (IPK, IAL, etc...)


