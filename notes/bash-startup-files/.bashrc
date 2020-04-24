# tag::aliases[]
# Edit Bash RC
alias eb="vim ~/.bashrc && . ~/.bashrc"

# git aliases
#
alias gb="git checkout"
alias gbm="git checkout master"
alias gbd="git checkout develop"
# --all to update all tracked branches
alias gp="git pull --all"
# git pull with rebase (this better be default using global config)
alias gpr="git pull --all --rebase"
# git pull but without rebase (overriding pull.rebase=true from config)
alias gpm="git pull --all --no-rebase"
# git pull with rebase and autostash when local changes are in the way
alias gpa="git pull --all --rebase --autostash"
alias gf="git fetch --all"
# lg is already git alias: log with one-line format
alias gl="git lg"
# HEAD and upstream, shows also fetched commits not on local branch
# notice the quoting to avoid early backtick evaluation
alias gll='git lg `git rev-parse --abbrev-ref HEAD @{u}`'
# log not-pushed yet (local, but not in upstream)
alias gu="git lu"
alias gs="git st" # st is already git alias: status -sb (short + branch info)
alias gca="git commit -am"
# commits resolved files after merge using default/prepared merge message
alias gcm="git commit -a --no-edit"

# grep aliases
alias gi="grep -i"
alias gr="grep -r"
alias gri="grep -ri"

# gradle-wrapper-wrapper with plain console output (useful for redirecting)
alias gwp="gw --console plain"

echo "Aliases set up:"
alias
# end::aliases[]

# tag::variables[]
# longer bash history
HISTSIZE=2000

# to leave content of the terminal after quitting less
export LESS='-X'
# used as default paging command, e.g. in psql
export PAGER='less -X'
# end::variables[]
