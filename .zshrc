#! /usr/bin/env zsh
## $Id: .zshrc 259 2008-11-17 15:49:11Z sigoure $

#######
# ENV #
#######

export NAME='Arvind'
export PAGER='less'
export FULLNAME='Arvind Kalan'
export EMAIL='base16@gmail.com'
export REPLYTO='base16@gmail.com'



case $PATH in
  ~/bin) :;;
  *) export PATH=~/bin:"${PATH}"
esac
export EDITOR='emacs'
test -r "/var/mail/$USER" && export MAIL="/var/mail/$USER"
local LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.rar=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
local LS_OPTIONS='-F'

export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

if [ x"$HOST" = x"gate-ssh" ] && (setopt | grep -q 'interactive'); then
  PROMPT="%{[1;31m%}%n%{[1;38m%}@%{[1;31m%}%m%{[m%} %B%40<..<%~%<<%b %(!.#.$) "
  RPROMPT="%(?..%{[1;31m%}%?%{[m%} )%{[1;31m%}%D{%H:%M:%S}%{[m%}"
  echo ">>>> You are on gate-ssh, forwarding you to netbsd"
  ssh netbsd
  echo ">>>> Back on gate-ssh... exiting"
  exit
fi

[ -n "$DISPLAY" ] && [ `uname -s` != Darwin ] && xset b off && xset r rate 250 75

###########
# ALIASES #
###########

lsbin='ls'
case `uname -s` in
  *BSD | Darwin)
    gls --version >/dev/null 2>/dev/null && lsbin='gls' && \
      LS_OPTIONS="$LS_OPTIONS -b -h --color"
    ;;
  Linux | CYGWIN*)
    LS_OPTIONS="$LS_OPTIONS -b -h --color"
    ;;
esac
alias l="LS_COLORS='$LS_COLORS' $lsbin $LS_OPTIONS"
alias ls="LS_COLORS='$LS_COLORS' $lsbin $LS_OPTIONS"
alias ll="LS_COLORS='$LS_COLORS' $lsbin $LS_OPTIONS -l"
alias la="LS_COLORS='$LS_COLORS' $lsbin $LS_OPTIONS -la"

if [ "`uname -s`" != "SunOS" ]; then
  if gmv --version >/dev/null 2>/dev/null; then
    alias mv="gmv -v"
  else
    alias mv="mv -v"
  fi
  if gcp --version >/dev/null 2>/dev/null; then
    alias cp="gcp -v"
  else
    alias cp="cp -v"
  fi
fi;
alias web="firefox &!"
alias su='sudo su'
alias gh="echo 'corrected gh to fg'; fg"
alias les="echo 'corrected les to less'; less"
alias gimp='mkdir -p /tmp/.gimp-sigoure && gimp'
alias port='port -v' # DarwinPorts
alias diff='diff -u'
alias irssi='screen -ls | grep irssi && screen -x irssi || screen -S irssi irssi'
alias m='make'
alias zmv='noglob zmv -v'
alias zcp='noglob zmv -vC'
alias fgrep='fgrep --color'
alias bc='bc -l'
alias pps='ps afux | less -S'
alias less='less -S'

alias volt='cd ~/svn/trunk/voltron/impl/java/com/linkedin/voltron/'
alias gb='git branch'
alias gs='git status'
alias gl='git slog'
alias gco='git checkout'

alias sshkill='killall -9 ssh ; rm .ssh/controlsock/*'
alias dt='ssh -C -A akalyan-ld'

alias tf='rsync -av hgit face-ext:hadoopbuild'

alias l='ls -lrta'

alias e='emacs'

alias atlanta='ssh eat1-app204.stg.linkedin.com'

alias err='tail -f /var/log/stumble/{debug,error}.log|grep arvind'

function strdate()
{
    php -r "date_default_timezone_set('America/Los_Angeles');echo strtotime('$1');" 2> /dev/null;
    echo ""
}

function clone()
{
    git clone gitli.corp.linkedin.com:$1
}

function syncconfs()
{
    for m in io face compute1 compute2 compute3 playground1 playground2 playground3 playground4 playground5
    do
        echo "Syncing to $m"
        rsync -a -h -z --delay-updates -T /tmp --progress -P .bash_profile .zshrc screenrc .screenrc .vim .vimrc $m:/home/arvind/
        echo "Done syncing to $m"
        echo ""
    done
    cd -
}


test -x ~/bin/svn-wrapper.sh && alias svn=~/bin/svn-wrapper.sh

mkcd()
{
  test $# -gt 0 || {
    echo 'Usage: mkcd [args] dir (see man mkdir)' >&2
    return 1
  }
  local i=0
  local dir='' # last argument = target directory
  while [ $i -lt $# ]; do
    dir="$1"
    shift
    set dummy "$@" "$dir"
    shift
    i=$((i+1))
  done
  test -d "$dir" || mkdir "$@"
  test -d "$dir" || {
    echo "mkcd: Cannot create directory $dir"
    return 1
  }
  cd "$dir"
}

xtarcd()
{
  test x"$1" = x && echo 'usage: xtarcd <tarball>' >&2 && return 1
  local failed=0
  local ext=''
  case "$1" in
    *.tar.gz)  tar -xvzf "$1" || failed=$?
               ext='.tar.gz';;
    *.tgz)     tar -xvzf "$1" || failed=$?
               ext='.tgz';;
    *.tar.bz2) tar -xvjf "$1" || failed=$?
               ext='.tar.bz2';;
    *.tar.Z)   uncompress -c "$1" | tar -xf - || failed=$?
               ext='.tar.Z';;
    *.shar.gz) gunzip -c "$1" | unshar || failed=$?
               ext='.shar.gz';;
    *.zip)     unzip "$1" || failed=$?
               ext='.zip';;
    *.rar)     rar x "$1" || failed=$?
               ext='.rar';;
    *)         echo 'Unknown file format' >&2; return 1;;
  esac
  test $failed -ne 0 && echo "extraction failed (returned $failed)" >&2 \
    && return $failed
  test -d `basename ${1%%$ext}` && cd `basename ${1%%$ext}`
}

###############
# ZSH OPTIONS #
###############

setopt correct                  # spelling correction
setopt complete_in_word         # not just at the end
setopt alwaystoend              # when completing within a word, move cursor to the end of the word
setopt auto_cd                  # change to dirs without cd
setopt hist_ignore_all_dups     # If a new command added to the history list duplicates an older one, the older is removed from the list
setopt hist_find_no_dups        # do not display duplicates when searching for history entries
setopt auto_list                # Automatically list choices on an ambiguous completion.
setopt auto_param_keys          # Automatically remove undesirable characters added after auto completions when necessary
setopt auto_param_slash         # Add slashes at the end of auto completed dir names
#setopt no_bg_nice               # ??
setopt complete_aliases
setopt equals                   # If a word begins with an unquoted `=', the remainder of the word is taken as the name of a command.
                                # If a command exists by that name, the word is replaced by the full pathname of the command.
setopt extended_glob            # activates: ^x         Matches anything except the pattern x.
                                #            x~y        Match anything that matches the pattern x but does not match y.
                                #            x#         Matches zero or more occurrences of the pattern x.
                                #            x##        Matches one or more occurrences of the pattern x.
setopt hash_cmds                # Note the location of each command the first time it is executed in order to avoid search during subsequent invocations
setopt hash_dirs                # Whenever a command name is hashed, hash the directory containing it
setopt mail_warning             # Print a warning message if a mail file has been accessed since the shell last checked.
setopt append_history           # append history list to the history file (important for multiple parallel zsh sessions!)
#setopt share_history            # imports new commands from the history file, causes your typed commands to be appended to the history file

#autoload mere zed
#autoload zfinit
autoload -U zmv

HISTFILE=~/.history_zsh
SAVEHIST=500000
HISTSIZE=500000

LOGCHECK=60
WATCHFMT="%n has %a %l from %M"
WATCH=all

fpath=(~/.zsh/functions $fpath)

##########
# COLORS #
##########

std="%{[m%}"
red="%{[0;31m%}"
green="%{[0;32m%}"
yellow="%{[0;33m%}"
blue="%{[0;34m%}"
purple="%{[0;35m%}"
cyan="%{[0;36m%}"
grey="%{[0;37m%}"
white="%{[0;38m%}"
lred="%{[1;31m%}"
lgreen="%{[1;32m%}"
lyellow="%{[1;33m%}"
lblue="%{[1;34m%}"
lpurple="%{[1;35m%}"
lcyan="%{[1;36m%}"
lgrey="%{[1;37m%}"
lwhite="%{[1;38m%}"

###########
# PROMPTS #
###########

PS2='`%_> '       # secondary prompt, printed when the shell needs more information to complete a command.
PS3='?# '         # selection prompt used within a select loop.
PS4='+%N:%i:%_> ' # the execution trace prompt (setopt xtrace). default: '+%N:%i>'
if [ $UID != 0 ]; then
  local prompt_user="${lgreen}%n${std}"
else
  local prompt_user="${lred}%n${std}"
fi
local prompt_host="${lyellow}%m${std}"
local prompt_cwd="%B%40<..<%~%<<%b"
local prompt_time="${lblue}%D{%H:%M:%S}${std}"
local prompt_rv="%(?..${lred}%?${std} )"
PROMPT="${prompt_user}${lwhite}@${std}${prompt_host} ${prompt_cwd} %(!.#.$) "
PROMPT="%w %* @%m %40<..<%~%<< %(!.#.$ "
RPROMPT="${prompt_rv}${prompt_time}"
RPROMPT=""


##############
# TERM STUFF #
##############

#/bin/stty erase "^H" intr "^C" susp "^Z" dsusp "^Y" stop "^S" start "^Q" kill "^U"  >& /dev/null

chpwd() {
    [[ -t 1 ]] || return
    case $TERM in
      sun-cmd) print -Pn "\e]l%n@%m %~\e\\"
        ;;
      *xterm*|rxvt|(k|E|dt)term) print -Pn "\e]0;%n@%m %~\a"
        ;;
    esac
}

chpwd
#setterm -blength 0

################
# KEY BINDINGS #
################

bindkey -e
#bindkey -v
bindkey '\e[1~'	beginning-of-line	# home
bindkey '\e[4~'	end-of-line		# end
bindkey "^[[A"	up-line-or-search	# cursor up
#bindkey -s '^P'	"|less\n"		# ctrl-P pipes to less
#bindkey -s '^B'	" &\n"			# ctrl-B runs it in the background
bindkey "\eOP"	run-help		# run-help when F1 is pressed
bindkey ' '	magic-space		# also do history expansion on space
bindkey '^?' backward-delete-char       # Fix backspace
type run-help | grep -q 'is an alias' && unalias run-help

#######################
# COMPLETION TWEAKING #
#######################

# The following lines were added by compinstall
_compdir=~/usr/share/zsh/functions
[[ -z $fpath[(r)$_compdir] ]] && fpath=($fpath $_compdir)

autoload -U compinit; compinit

# This one is a bit ugly. You may want to use only `*:correct'
# if you also have the `correctword_*' or `approximate_*' keys.
# End of lines added by compinstall

zmodload zsh/complist

zstyle ':completion:*:processes' command 'ps -au$USER'     # on processes completion complete all user processes
zstyle ':completion:*:descriptions' format \
       $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'           # format on completion
zstyle ':completion:*' verbose yes                         # provide verbose completion information
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format \
       $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'
zstyle ':completion:*:matches' group 'yes'                 # separate matches into groups
zstyle ':completion:*:options' description 'yes'           # describe options in full
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:*:zcompile:*' ignored-patterns '(*~|*.zwc)'

# activate color-completion(!)
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

## correction

# Ignore completion functions for commands you don't have:
#  zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

zstyle ':completion:*'             completer _complete _correct _approximate
zstyle ':completion:*:correct:*'   insert-unambiguous true
#  zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
#  zstyle ':completion:*:corrections' format $'%{\e[0;31m%}%d (errors: %e)%}'
zstyle ':completion:*:corrections' format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
zstyle ':completion:*:correct:*'   original true
zstyle ':completion:correct:'      prompt 'correct to:'

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:' max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'
#  zstyle ':completion:*:correct:*'   max-errors 2 numeric

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# ignore duplicate entries
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# filename suffixes to ignore during completion (except after rm command)
#  zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns  '*?.(o|c~|old|pro|zwc)' '*~'

# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# If there are more than N options, allow selecting from a menu with
# arrows (case insensitive completion!).
#  zstyle ':completion:*-case' menu select=5
zstyle ':completion:*' menu select=2

# zstyle ':completion:*:*:kill:*' verbose no
#  zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
#                                /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# caching
[ -d $ZSHDIR/cache ] && zstyle ':completion:*' use-cache yes && \
                        zstyle ':completion::complete:*' cache-path $ZSHDIR/cache/

# use ~/.ssh/known_hosts for completion
#  local _myhosts
#  _myhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
#  zstyle ':completion:*' hosts $_myhosts
known_hosts=''
[ -f "$HOME/.ssh/known_hosts" ] && \
known_hosts="`awk '$1!~/\|/{print $1}' $HOME/.ssh/known_hosts | cut -f1 -d, | xargs`"

zstyle ':completion:*:hosts' hosts ${=known_hosts}

# simple completion for fbset (switch resolution on console)
_fbmodes() { compadd 640x480-60 640x480-72 640x480-75 640x480-90 640x480-100 768x576-75 800x600-48-lace 800x600-56 800x600-60 800x600-70 800x600-72 800x600-75 800x600-90 800x600-100 1024x768-43-lace 1024x768-60 1024x768-70 1024x768-72 1024x768-75 1024x768-90 1024x768-100 1152x864-43-lace 1152x864-47-lace 1152x864-60 1152x864-70 1152x864-75 1152x864-80 1280x960-75-8 1280x960-75 1280x960-75-32 1280x1024-43-lace 1280x1024-47-lace 1280x1024-60 1280x1024-70 1280x1024-74 1280x1024-75 1600x1200-60 1600x1200-66 1600x1200-76 }
compdef _fbmodes fbset

# use generic completion system for programs not yet defined:
compdef _gnu_generic tail head feh cp mv gpg df stow uname ipacsum fetchipac

# Debian specific stuff
# zstyle ':completion:*:*:lintian:*' file-patterns '*.deb'
zstyle ':completion:*:*:linda:*'   file-patterns '*.deb'

# see upgrade function in this file
compdef _hosts upgrade

###############
# MISC. STUFF #
###############

[ -r ~/.zshrc.local ] && source ~/.zshrc.local


#[ -r /nix/etc/profile.d/nix.sh ] && source /nix/etc/profile.d/nix.sh


#export JAVA_HOME="/opt/java"
#export PATH="${JAVA_HOME}/bin:${PATH}"


[ -r /opt/subversion/bin/svn ] && export PATH=/opt/subversion/bin:$PATH
[ -r /export/apps/xtools/bin ] && export PATH=/export/apps/xtools/bin:$PATH

export PATH=/export/apps/xtools/bin:$PATH:$HOME/bin



#[ -r /usr/local/Cellar/ruby/1.9.3-p194/bin/ ] && export PATH=/usr/local/Cellar/ruby/1.9.3-p194/bin/$PATH:

if [ -x /usr/bin/keychain ] ; then
        MYNAME=`/usr/bin/whoami`
        if [ -f ~/.ssh/${MYNAME}_at_linkedin.com_dsa_key ] ; then
              /usr/bin/keychain ~/.ssh/${MYNAME}_at_linkedin.com_dsa_key
              . ~/.keychain/`hostname`-sh
        fi
fi

export LEOHOME=/home/akalyan/svn/trunk/
export NETREPO=svn+ssh://svn.corp.linkedin.com/netrepo/network
export LIREPO=svn+ssh://svn.corp.linkedin.com/lirepo
export VENREPO=svn+ssh://svn.corp.linkedin.com/vendor

export JAVA_HOME=/export/apps/jdk/JDK-1_6_0_27
export JDK_HOME=/export/apps/jdk/JDK-1_6_0_27
export NLS_LANG=American_America.UTF8

[ -r /usr/libexec/java_home ] && export JAVA_HOME=`/usr/libexec/java_home`
[ -r /usr/libexec/java_home ] && export JDK_HOME=`/usr/libexec/java_home`

[ -r ~/bin/scala-2.10.0/bin/ ] && export PATH=$PATH:~/bin/scala-2.10.0/bin/

export M2_HOME=/local/maven
export M2=$M2_HOME/bin

export PATH=$PATH:$JAVA_HOME/bin:/usr/local/bin:/usr/local/mysql/bin:/usr/local/linkedin/bin

export PATH=$HOME/.rbenv/bin:$PATH

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
