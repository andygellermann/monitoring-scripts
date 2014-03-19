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

CHECKMEMORY_COMAND="ipcs -m"
CHECKMEMORY_PERMS="666"
CHECKMEMORY_MEM="3283128"

CHECKSSH_COMAND="ssh -G 2>&1"
CHECKSSH_OUTPUTFILTER="-e illegal -e unknown"

MEMORY_STATUS=0
SSH_STATUS=0

func check_memory(){
    myPERMSRESULT=$(ipcs -m | grep ${CHECKMEMORY_PERMS} | wc -l)
    if [ ${myPERMSRESULT} -gt 0 ]; then
        myMEMRESULT=$(ipcs -m | grep ${CHECKMEMORY_MEM} | wc -l)
        if [ ${myMEMRESULT} -gt 0 ]; then
            MEMORY_STATUS=1
        else
            MEMORY_STATUS=0
        fi
    else
            MEMORY_STATUS=0
    fi
}

func check_ssh(){
    mySSHRESULT=$(ssh -G 2>&1 | grep ${CHECKSSH_OUTPUTFILTER} | wc -l)
    if [ ${mySSHRESULT} -eq 1 ]; then
        SSH_STATUS=0
    else
        SSH_STATUS=1
    fi
}
check_memory()
check_ssh()
if [ ${MEMORY_STATUS} -gt 0 -a ${SSH_STATUS} -gt 0 ]; then
    exitSTATUS=2
    exitSTRING="check_ebury - This system IS infected"
elif [ ${MEMORY_STATUS} -gt 0 -o ${SSH_STATUS} -gt 0 ]; then
    exitSTATUS=1
    exitSTRING="check_ebury - This system IS MAYBE infected"
else
    exitSTATUS=0
    exitSTRING="check_ebury - This system IS NOT infected"     
fi

echo "${exitSTATUS} ${exitSTRING}"
