#!/usr/bin/env bash
#===============================================================================
#
#          FILE: tmux-menu.sh
# 
#         USAGE: ./tmux-menu.sh <session-name>
# 
#   DESCRIPTION: A hack script I wrote to help me manage pre-defined 
#                tmux-sessions
# 
#       OPTIONS: 
#  REQUIREMENTS: tmux
#         NOTES: the cool down arrows in line 43?  <ctrl-k> -v (see: digraphs)
#        AUTHOR: C Hawley 
#  ORGANIZATION: 
#       CREATED: 2015-09
#      REVISION: Mon 16 Oct 2017 05:28:00 PM EDT
#===============================================================================

# check for command line argument
# Tips from:
# http://stackoverflow.com/questions/7832080/test-if-a-variable-is-set-in-bash-when-using-set-o-nounset
if [ -z "${1:-}" ]; then
	session="undefined"
else
	session=$1
fi

echo ""
echo ""
echo "##################################"
echo "TMUX Hack Session Launcher"
echo "##################################"
echo "Launching Session: $session"

# NO TMUX NESTING ALLOWED
if [ ! -z $TMUX ]; then
	echo "You are in a session already.  NO NESTING ALLOWED"
	echo "-------------------------------------------------"
	exit 1
fi

tcheck=$(tmux list-sessions | grep -c "${session}")  # check if session is active

# if session is active, switch to it.  If not active but part of the list below,
# create it.  Finally, if no session or undefined session is passed, give an
# error message and list the active sessions

# sample session definition
#
# case $session in    
#    analytics)                               # <- session name
#        if [[ $tcheck == 0 ]]; then          # <- check if it's already running
#          tmux new-session -d -s analytics   # <- if not, create it
#          tmux rename-window 'localhost'     # <- rename the first window (local)
#                                             # ↓↓ define additional windows ↓↓
#          tmux new-window -t:1 -n 'lasis01' 'exec ssh lasis01'
#          tmux new-window -t:2 -n 'lasis01dev' 'exec ssh lasis01dev'
#          tmux new-window -t:3 -n 'ldssbox01' 'exec ssh ldssbox01'
#          tmux new-window -t:4 -n 'lpdprod01' 'exec ssh lpdprod01'
#          tmux new-window -t:5 -n 'ldatalake01' 'exec ssh ldatalake01'
#          tmux new-window -t:6 -n 'lsandbox' 'exec ssh lsandbox'
#        fi
#        tmux attach-session -t analytics     # <- if window active, switch to it
#        ;;


case $session in
    mine)
        if [[ $tcheck == 0 ]]; then
            tmux new-session -d -s mine
            tmux rename-window 'local(aristotle)'
            tmux new-window -t 1 -n 'root@vps' 'exec ssh root@vps.example.org'
            tmux new-window -t:2 -n 'chawley@phaedrus' 'exec ssh chawley@phaedrus'
            tmux new-window -t:3 -n 'chawley@homer' 'exec ssh chawley@homer.simpsons.net'
        fi
        tmux attach-session -t mine
        ;;

    # add more sessions here inside a case stanza.  Start with a session name and end with ';;'        
    
    *)
        echo "### ERROR No Such Session ###"
        echo "Usage: tm <session_name>"
        echo "Active Sessions:"
        echo "----------------"
        tmux list-sessions
        ;;
esac
