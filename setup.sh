############################################################
# TOOLS                                                    #
#                                                          #
# The base directory of the tools directory.               #
############################################################
export TOOLS=$(realpath $(dirname ${BASH_SOURCE[0]}))

############################################################
# PATH                                                     #
#                                                          #
# The default Linux path variable. The two directories     #
# which include executables need to be included. The       #
# current directory is included as well.                   #
#                                                          #
# This directory is part of the delivery and should rarely #
# been required to changed.                                #
############################################################
export PATH=$TOOLS/bin:$PATH

############################################################
# Cleanup                                                  #
#                                                          #
# If this script is executed more than once there may be   #
# duplicated directories in the environment variables set  #
# above. This makes the path long and unreadable and in    #
# case of errors difficult to debug.                       #
#                                                          #
# The small script "clean-path.pl" removes all duplicate   #
# directories. Only the first instance survives. And the   #
# order is kept.                                           #
#                                                          #
# To be sure that nothing is broken the cleanup is only    #
# done when it's ensured that the executable is in the     #
# path.                                                    #
############################################################
command -v clean-path 1>/dev/null 2>&1
if [ "$?" == "0" ]; then
  export PATH=`clean-path $PATH`
fi

############################################################
# save                                                     #
#                                                          #
# This is a shortcut for saving the complete environment   #
# to S3. Archives are created and uploaded.                #
#                                                          #
# This should be used to save a development environment    #
# only. In production the data should come from somewhere  #
# else.                                                    #
############################################################
alias stools='(cd $TOOLS ; create-archive -z s3://nameservice/releases/tools MANIFEST-tools)'
alias ltools='aws s3 ls s3://nameservice/releases/tools/| grep "PRE" | tail -1 | awk "{print \$2}"'
