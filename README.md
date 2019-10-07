# set-build

Create a build unit UBuild.pas; update the build number at every compile run.


Usage:

compile.sh
#!/bin/bash

##
## Use the set-build tool to increase the build number.
## Create UBuild.pas
##
~/development/pascal/set-build/set-build serverclass-modifier


##
## Compile the source and move the executable to the bin directory
##
fpc scmod.pas -obin/scmod


##
## Remove the object file.
##
rm bin/scmod.o


In scmod.pas

Uses
    UBuild;


