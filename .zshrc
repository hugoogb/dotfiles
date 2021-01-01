clear

. $HOME/dotfiles/scripts/distro-detect.sh

if [[ "$DISTRO" == "$UBUNTU" ]]
then
  # AutoOpen TMUX
  if which tmux 2>&1 >/dev/null; then
    if [ $TERM != "screen-256color" ] && [  $TERM != "screen" ]; then
      tmux attach -t dev || tmux new -s dev; exit
    fi
  fi
fi

figlet -lt github | lolcat -f

# Start ssh agent
eval "$(ssh-agent -s)"
ssh-add $HOME/.ssh/id_me
ssh-add $HOME/.ssh/id_uni

clear

neofetch

cd $HOME

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# starship config file path
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# ZSH_THEME=""

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git jump colored-man-pages safe-paste zsh-interactive-cd zsh-syntax-highlighting k zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration
export NPM_CONFIG_PREFIX="$HOME/.npm-global/bin"

source "$HOME/.cargo/env"

setopt globdots

# fzf settings
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l -g ""'
# export FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git" "!.npm" '
# export FZF_DEFAULT_COMMAND='find .'
export FZF_DEFAULT_OPTS='--height 40% --reverse'

if [[ "$DISTRO" == "$UBUNTU" ]]
then
  export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    # --color fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f
    # --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54'
fi

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Custom Aliases

# Reload .zshrc with an alias
alias reload="source $HOME/.zshrc"

# Execute dotfiles bootstrap
alias dotscript=". $HOME/dotfiles/bootstrap.sh"

# Generate pacman pkg list and AUR pkg list
alias pkglist=". $HOME/dotfiles/scripts/pkglist-gen.sh"

# System aliases
alias distro="cat /etc/*-release"
alias upgrade="sudo apt upgrade"
alias update="sudo apt update"
alias install="sudo apt install"
alias remove="sudo apt remove --purge"

# alias python="python3"

# Custom aliases
alias show="tree ."
# alias rm="rm -v"
# alias 'rm -rf'="rm -rfv"
# alias mv="mv -v"
# alias cp="cp -v"
# alias mkdir="mkdir -pv"
alias path="echo -e ${PATH//:/\\n}"

# Navigate through dirs history
d='dirs -v | head -10'
1='~1'
2='~2'
3='~3'
4='~4'
5='~5'
6='~6'
7='~7'
8='~8'
9='~9'

# Network aliases
alias myip="curl http://ipecho.net/plain; echo"
alias speedtest="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -"

# Best aliases ever
alias l="ls -la"
alias j="jump"
alias :q="exit"

# git aliases (zsh git plugin)
# alias g="git"
# alias gst="git status"
# alias ga="git add"
# alias gc="git commit -v"
# alias gca="git commit -v -a"
# alias gp="git push"
# alias gl="git pull"
# alias gd="git diff"
# alias glg="git log --stat"
# alias glgg="git log --graph"
# alias glgga="git log --graph --decorate --all"
# alias gba="git branch -a"
# alias ggl="git pull origin $(current_branch)"
# alias ggp="git push origin $(current_branch)"
# alias gcf="git config --list"

# Init starship zsh theme
eval "$(starship init zsh)"
