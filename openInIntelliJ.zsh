source ~/.zsh/colors.zsh  # Load color definitions

alias openInIdea='open_in_idea'

function is_project_open() {
    local repo="$1"
    local idea_pid=$(pgrep -f "IntelliJ IDEA CE.app/Contents/MacOS/idea")

    # Check if the project is in IntelliJ's open file list
    local open_files=$(lsof -p "$idea_pid" 2>/dev/null | grep REG | awk '{print $9}' | sort | uniq | grep -F "$repo")

    if [[ -n "$open_files" ]]; then
        echo " (already open)"
    else
        echo ""
    fi
}

function open_in_idea() {

    repo_list=""

    if [ -z "$1" ]; then
        print -P "${CYAN}Can also be used as ${YELLOW}openInIdea <search-text>${RESET}"
        repo_list=$(find . -maxdepth 1 -type d | sed 's|^\./||' | sed '1d')
    else
        repo_list=$(ls -al | grep $1 | awk '{print $NF}')
    fi

    # Get IntelliJ PID (Ensure only one)
    local idea_pid=$(pgrep -f "IntelliJ IDEA CE.app/Contents/MacOS/idea")

    local menu=""
    
    # Process each repo one at a time
    while IFS= read -r repo; do
        project_status=$(is_project_open "$repo")
        menu+="$repo $project_status\n"
    done <<< "$repo_list"

    menu+="Exit"

    # Use fzf to select a repository
    local selected_repo=$(echo -e "$menu" | fzf --height=10 --reverse --prompt="Select repo: ")

    # Handle exit condition
    if [[ "$selected_repo" == "Exit" || -z "$selected_repo" ]]; then
        echo "❌ Exiting..."
        return
    fi

    # Remove "(already open)" if present
    # selected_repo=$(echo "$selected_repo" | sed 's/ (already open)//')
    selected_repo=$(echo "$selected_repo" | sed 's/ (already open)//' | xargs)

    echo "🚀 Opening '$selected_repo' in IntelliJ IDEA..."
    idea "$selected_repo"
}