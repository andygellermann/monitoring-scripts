#!/bin/bash
#=======================================================================
# Filename      : check_ebury.sh
# Author        : Benedikt Frenzel
# License       : "THE BEER-WARE LICENSE" (Revision 42):
#                 <mail@benedikt-frenzel.name> wrote this file. As long 
#                 as you retain this notice you  can do whatever you 
#                 want with this stuff. If we meet some day, and you 
#                 think this stuff is worth it, you can buy me a beer 
#                 in return.
#                 Benedikt Frenzel
# Input values  : none
# Purpose       : This script will check if your system is may be 
#                 infected by the ebruy rootkit for more information
#                 check: https://www.cert-bund.de/ebury-faq
# Disclaimer    : I can and will NOT  guarantee that this script will 
#                 find the ebruy rootkit. This script will not remove 
#                 the rootkit. 
#=======================================================================

# ----------------------------------------------------------------------
# Independent variables
# ----------------------------------------------------------------------

# ----------------------------------------------------------------------
# Dependent variables
# Nothing to change below this line.
# ----------------------------------------------------------------------

CHECKCOMAND="ipcs -m"
CHECKPERMS="666"
CHECKMEM="3283128"

myPERMSRESULT=$(ipcs -m | grep ${CHECKPERMS} | wc -l)
if [ ${myPERMSRESULT} -gt 0 ]; then
    myMEMRESULT=$(ipcs -m | grep ${CHECKMEM} | wc -l)
    if [ ${myMEMRESULT} -gt 0 ]; then
        exitSTATUS=2
        exitSTRING="check_ebury - This system may be infected"
    else
        exitSTATUS=0
        exitSTRING="check_ebury - This system is clean"
    fi
else
        exitSTATUS=0
        exitSTRING="check_ebury - This system is clean"
fi
echo "${exitSTATUS} ${exitSTRING}"
