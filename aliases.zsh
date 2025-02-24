# env.zsh
alias fsfs="source ~/.zshrc"

# git.zsh
alias gbc='git branch --sort=-committerdate' # sort by last commit on a branch
alias gs="git status"
alias ga="git add ."
alias gc="git commit -m"
alias gps="git push"
alias gpl="git pull"
alias chk="git checkout"
alias mas="git checkout master && git pull origin master"
alias gb="git branch"
alias glog="git log --oneline --graph --all"
alias uc='git reset --soft HEAD~1'
alias com_msg='last_commit_messages'
alias jp='push_to_remote'
alias b_c='create_branch'

# k8s.zsh
alias kl="kubectl logs"
alias kgp="kubectl get pods"
alias kd="kubectl describe pod"

# openInIntelliJ.zsh
alias openInIdea='open_in_idea'

# python.zsh
alias freeze_req='pip freeze > requirements.txt'
alias req_i="pip install -r requirements.txt"

# utils.zsh
alias fr='find_repo'
alias crr='openVScode'
alias open_zsh_files='cd && code .zsh'

# cars24.zsh
alias add_db="add_db_name"
alias up_db='update_db'