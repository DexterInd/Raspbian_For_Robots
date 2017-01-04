feedback() {
  # first parameter is text to be displayed
  # this sets the text color to a pinkish color for visibility
  # the last tput resets colors to default
  # one could also set background color with setb instead of setaf
  #http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x405.html
  echo -e "$(tput setaf 3)$1$(tput sgr0)"
}

delete_line_from_file() {
  # first parameter is the string to be matched 
  # the lines that contain that string will get deleted
  # second parameter is the filename
  if [ -f $2 ]
  then
    sudo sed -i "/$1/d" $2
    feedback "deleted $1 from $2"
  fi
}

insert_before_line_in_file() {
  # first argument is the line that needs to be inserted DO NOT USE PATHS WITH / in them
  # second argument is a partial match of the line we need to find to insert before
  # third arument is filename

  feedback "Inserting $1 before $2 in $3"
  if [ -f $3 ]
  then
    feedback "sudo sed -i '/$2/i $1' $3"
    sudo sed -i "/$2/i $1" $3
  fi
}

find_in_file() {
  # first argument is what to look for
  # second argument is the filename
  feedback "looking for $1 in $2"
  if grep -q "$1" $2
  then
    return 0
  else
    return 1
  fi
}

file_exists() {
  # Only one argument: the file to look for
  # returns 0 on SUCCESS
  # returns 1 on FAIL
  if [ -f $1 ]
  then
    return 0
  else
    return 1
  fi
}

file_does_not_exists(){
  # Only one argument: the file to look for
  # returns 0 on SUCCESS
  # returns 1 on FAIL
  feedback "looking for $1"
  if [ ! -f $1 ]
  then
    feedback "not found $1"
    return 0
  else
    feedback "found $1"
    return 1
  fi
}

file_exists_in_folder(){
  # can only be run using bash, not sh
  # first argument: file to look for
  # second argument: folder path
  pushd $2
  status = file_exists
  popd
  return status
}

add_line_to_end_of_file() {
  # first parameter is what to add
  # second parameter is filename
  if [ -f $2 ]
  then
    echo $1 >> $2
    feedback "added $1 in $2"
  fi 
}