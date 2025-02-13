#  usage: fr <search-text>
alias fr='find_repo'
find_repo_output=""
function find_repo() {
    if [ -z "$1" ]; then
        ls -al
        return 1
    fi
    find_repo_output=$(ls -al | grep $1)
    echo "$find_repo_output"
}


# usage crr <row-no>
alias crr='openVScode'
function openVScode() {
  row_number=$1
  dir_name=$(echo "$find_repo_output" | awk "NR==$row_number {print \$9}")
  if [ -n "$dir_name" ]; then
    code "$dir_name"
  else
    echo "Invalid row number: $row_number"
  fi
}

alias open_zsh_files='cd && code .zsh'