source ~/.zsh/colors.zsh  # Load color definitions

# undo commit
function undo_commit() {
    current_branch=$(git symbolic-ref --short HEAD)
    if [ $? -ne 0 ]; then
        echo "Error: Not on a valid branch"
        return 1
    fi
    print -P "${YELLOW}You are about undo commit on '$current_branch' branch.${RESET}"
    print -P -n "Want to proceed? (y/n): "
    read proceed_undoing
    if [[ "$proceed_undoing" == "y" || "$proceed_undoing" == "Y" ]]; then
        uc
        break
    elif [[ "$proceed_undoing" == "n" || "$proceed_undoing" == "N" ]]; then
        break
    else
        print -P "${CYAN}Invalid response. Please enter y or n. Or to end, press control + C.${RESET}"
    fi
}

function last_commit_messages() {

    if [ -z "$1" ]; then
        git log -n 7 --pretty=format:"%C(yellow)%h%C(reset) - %C(cyan)%s%C(reset)"
        print -P "${RED}Usage: com_msg <required_number_of_last_commit_messages>${RESET}"
        return 1
    fi

    number=$1
    git log -n ${number} --pretty=format:"%C(yellow)%h%C(reset) - %C(cyan)%s%C(reset)"
}

# push to remote
function push_to_remote() {

    current_branch=$(git symbolic-ref --short HEAD)
    if [ $? -ne 0 ]; then
        print -P "${RED}Error: Not on a valid branch: '$current_branch' branch.${RESET}"
        return 1
    fi
    print -P "${YELLOW}On are currently on: '$current_branch' branch.${RESET}"

    git diff --quiet
    local unstaged=$?

    git diff --cached --quiet
    local staged=$?

    if [[ $unstaged -eq 1 || $staged -eq 1 ]]; then
        print -P "${GREEN}Found changes to commit. Continuing...${RESET}"
        # Ask the user whether they want to run 'git add .'
        question="Do you want to run 'git add .'?"
        while true; do
            print -P -n "${MAGENTA}$question (y/n):${RESET} "
            # echo -n "$question (y/n): "
            read git_add_response
            if [[ "$git_add_response" == "y" || "$git_add_response" == "Y" ]]; then
                break
            elif [[ "$git_add_response" == "n" || "$git_add_response" == "N" ]]; then
                break
            else
                print -P "${CYAN}Invalid response. Please enter y or n. Or to end, press control + C.${RESET}"
            fi
        done

        if [[ "$git_add_response" == "y" || "$git_add_response" == "Y" ]]; then
            git add .
            print -P "${GREEN}Executed 'git add .' command.${RESET}"
        else
            print -P "${RED}Not executing git add. Ending process.${RESET}"
            return 1
        fi

        # Ask the user whether they want to run 'git commit -m'
        question="Do you want to run 'git commit -m'?"
        while true; do
            print -P -n "${MAGENTA}$question (y/n):${RESET} "
            read commit_response
            if [[ "$commit_response" == "y" || "$commit_response" == "Y" ]]; then
                break
            elif [[ "$commit_response" == "n" || "$commit_response" == "N" ]]; then
                break
            else
                print -P "${CYAN}Invalid response. Please enter y or n. Or to end, press control + C.${RESET}"
            fi
        done

        if [[ "$commit_response" == "y" || "$commit_response" == "Y" ]]; then
            com_msg
            local commit_message
            while true; do
                print -P -n "${MAGENTA}Please enter commit message:${RESET} "
                read commit_message
                if [[ "$commit_message" != "" ]]; then
                    break
                else
                    print -P "${CYAN}Please provide some commit message. To end, press control + C.${RESET}"
                fi
            done

            git commit -m "$commit_message"
            if [ $? -ne 0 ]; then
                print -P "${RED}Error: not able to commit changes. Ending process.${RESET}"
                return 1
            fi
            print -P "${GREEN}Executed 'git commit -m' command.${RESET}"
        else
            print -P "${RED}Not executing git commit. Ending process.${RESET}"
            return 1
        fi
    else
        print -P "${CYAN}No changes to commit. Jumping to merging with master...${RESET}"
    fi


    question="Do you want to merge with master?"
    while true; do
        print -P -n "${MAGENTA}$question (y/n):${RESET} "
        read merge_response
        if [[ "$merge_response" == "y" || "$merge_response" == "Y" ]]; then
            print -P "${CYAN}Going to fetch master.${RESET}"
            mas
            chk -
            git merge master
            if [[ $? -ne 0 ]]; then
                print -P "${RED}Not able to merge with master.${RESET}"
                break
            fi
            print -P "${GREEN}Merged with master.${RESET}"
            break
        elif [[ "$merge_response" == "n" || "$merge_response" == "N" ]]; then
            break
        else
            print -P "${CYAN}Invalid response. Please enter y or n. Or to end, press control + C.${RESET}"
        fi
    done

    # Ask the user whether they want to run 'git push'
    question="Do you want to run 'git push'?"
    while true; do
        print -P -n "${MAGENTA}$question (y/n):${RESET} "
        read push_response
        if [[ "$push_response" == "y" || "$push_response" == "Y" ]]; then
            break
        elif [[ "$push_response" == "n" || "$push_response" == "N" ]]; then
            break
        else
            print -P "${CYAN}Invalid response. Please enter y or n. Or to end, press control + C.${RESET}"
        fi
    done

    if [[ "$push_response" == "y" || "$push_response" == "Y" ]]; then
        git push
        if [ $? -ne 0 ]; then
            print -P "${RED}Error: pushing current branch.${RESET}"

            # Ask the user whether they want to force run 'git push'
            question="Do you want to force run 'git push'?"
            while true; do
                print -P -n "${MAGENTA}$question (y/n):${RESET} "
                read force_push_response
                if [[ "$force_push_response" == "y" || "$force_push_response" == "Y" ]]; then
                    break
                elif [[ "$force_push_response" == "n" || "$force_push_response" == "N" ]]; then
                    break
                else
                    print -P "${CYAN}Invalid response. Please enter y or n. Or to end, press control + C.${RESET}"
                fi
            done

            if [[ "$force_push_response" == "y" || "$force_push_response" == "Y" ]]; then
                git push origin "$current_branch" -f
                if [ $? -ne 0 ]; then
                    print -P "${RED}Error: force pushing current branch.${RESET}"
                else
                    print -P "${GREEN}Executed 'git push origin ${current_branch} -f' command.${RESET}"
                fi
            else
                print -P "${RED}Not executing git force push. Ending process.${RESET}"
                return 1
            fi
        else
            print -P "${GREEN}Executed 'git push origin ${current_branch}' command.${RESET}"
        fi
    else
        print -P "${RED}Not executing git push. Ending process.${RESET}"
        return 1
    fi
}


function create_branch() {
    if [ -z "$1" ]; then
        print -P "${RED}Usage: create_branch <ticket_number>${RESET}"
        return 1
    fi

    ticket_number=$1
    full_branch_name="rough-${ticket_number}"

    git checkout -b "$full_branch_name"

    if [ $? -eq 0 ]; then
        print -P "${GREEN}Switched to a new branch '$full_branch_name'.${RESET}"
    else
        print -P "${RED}Failed to create a new branch '$full_branch_name'.${RESET}"
    fi
}

# Git Branch Navigator and Checkout Function with Exit Option
function git_branch_checkout() {
  # Check if we are in a git repository
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not inside a git repository!"
    return 1
  fi

  # Fetch the list of branches and add an "EXIT" option
  local branch
  branch=$( (gbc \
    | grep -v HEAD \
    | sed 's/.* //' \
    | sed 's#remotes/[^/]*/##' \
    | sort -u ; echo "EXIT") \
    | fzf --preview="git log -5 --oneline --color=always {}" \
          --header="⬆️⬇️ Select a branch to checkout (or EXIT)" \
          --prompt="Branch> " \
          --height=15 \
          --border)

  # If no branch was selected (user pressed ESC or Ctrl+C), exit
  if [[ -z "$branch" ]]; then
    echo "⚠️  No branch selected. Exiting."
    return 0
  fi

  # If the user selected EXIT, exit the function
  if [[ "$branch" == "EXIT" ]]; then
    echo "👋 Exiting without switching branches."
    return 0
  fi

  # Checkout the selected branch
  echo "🚀 Checking out branch: $branch"
  git checkout "$branch"
}
