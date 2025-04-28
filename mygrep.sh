#!/bin/bash

# Function to print usage
usage() {
  echo "Usage: $0 [-n] [-v] <search_string> <file>"
  echo "  -n  Show line numbers"
  echo "  -v  Invert the match (show lines that don't match)"
  echo "  --help  Show this help message"
  exit 1
}

# Function to handle the grep-like behavior
mygrep() {
  local search_string=""
  local file=""
  local invert_match=false
  local show_line_numbers=false

  # Parse options
  while getopts ":nv" opt; do
    case $opt in
      n) show_line_numbers=true ;;
      v) invert_match=true ;;
      \?) usage ;;
    esac
  done

  # Shift to process search_string and file
  shift $((OPTIND - 1))

  # Now, $1 should be the search string and $2 should be the file
  search_string="$1"
  file="$2"

  # Check if search string or file are missing
  if [ -z "$search_string" ] || [ -z "$file" ]; then
    echo "Error: Missing search string or file"
    usage
  fi


  # Check if the file exists
  if [ ! -f "$file" ]; then
    echo "Error: File '$file' does not exist"
    exit 1
  fi

  # Construct the grep command with options
  if $invert_match && $show_line_numbers; then
    echo "Running: grep -inv '$search_string' '$file'"  # Debugging output
    grep -inv "$search_string" "$file" || echo "No matches found"
  elif $invert_match; then
    echo "Running: grep -iv '$search_string' '$file'"  # Debugging output
    grep -iv "$search_string" "$file" || echo "No matches found"
  elif $show_line_numbers; then
    echo "Running: grep -in '$search_string' '$file'"  # Debugging output
    grep -in "$search_string" "$file" || echo "No matches found"
  else
    echo "Running: grep -i '$search_string' '$file'"  # Debugging output
    grep -i "$search_string" "$file" || echo "No matches found"
  fi
}

# Handle --help flag
if [ "$1" == "--help" ]; then
  usage
fi

# Call the mygrep function with arguments
mygrep "$@"