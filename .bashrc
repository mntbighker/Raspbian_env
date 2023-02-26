# .bashrc

#Enable programmable completion features.
if [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi

# Set the PS1 prompt (with colors).
# Based on http://www-128.ibm.com/developerworks/linux/library/l-tip-prompt/
# And http://networking.ringofsaturn.com/Unix/Bash-prompts.php .
# PS1="\[\e[36;1m\]\h:\[\e[32;1m\]\w$ \[\e[0m\]"
PS1="[\u@\h \w]# "

# Set the default editor to vim.
export EDITOR=vim

# Avoid succesive duplicates in the bash command history.
export HISTCONTROL=ignoredups

# Append commands to the bash command history file (~/.bash_history)
# instead of overwriting it.
shopt -s histappend

# Append commands to the history every time a prompt is shown,
# instead of after closing the session.
PROMPT_COMMAND='history -a'

# Set up X11 through sudo
[ -n "$DISPLAY" -a -e "$HOME/.Xauthority" ] && export XAUTHORITY="$HOME/.Xauthority"

export LC_ALL=C

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

if ! echo ${PATH} | fgrep -q ":/sbin"; then
   export PATH=/sbin:/usr/sbin:/usr/local/sbin:${PATH}
fi 

# Don't use /usr/bin/lesspipe.sh
unset LESSOPEN

set -o notify

# Set local colors for ls
# LSDEF=${LS_OPTIONS:='-F --show-control-chars --color=auto'}

# [ -f ~/.localcolors ] && eval `dircolors -b ~/.localcolors`

# alias ls="ls $LSDEF -h --time-style=+'%Y-%b-%d %H:%m'"

# Unlimited stack fir Intel Fortran
# ulimit -s unlimited

# Add bash aliases.
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# User specific aliases and functions

alias mdisplay='export DISPLAY=143.232.134.124:0'

function st  { strings "$1" | more; }

function _loc {
   find . -xdev -name "$@" -print
   set +f
}

# Find a file with a pattern in name:
function ff() { find . -type f -iname '*'$*'*' -ls ; }

# Find a file with pattern $1 in name and Execute $2 on it:
function fe()
{ find . -type f -iname '*'${1:-}'*' -exec ${2:-file} {} \;  ; }

# Find a pattern in a set of files and highlight them:
# (needs a recent version of egrep)
function fstr()
{
    OPTIND=1
    local case=""
    local usage="fstr: find string in files.
Usage: fstr [-i] \"pattern\" [\"filename pattern\"] "
    while getopts :it opt
    do
        case "$opt" in
        i) case="-i " ;;
        *) echo "$usage"; return;;
        esac
    done
    shift $(( $OPTIND - 1 ))
    if [ "$#" -lt 1 ]; then
        echo "$usage"
        return;
    fi
    find . -type f -name "${2:-*}" -print0 | \
    xargs -0 egrep --color=always -sn ${case} "$1" 2>&- | more

}

[ -z $INPUTRC ] && export INPUTRC=/etc/inputrc

umask 077

