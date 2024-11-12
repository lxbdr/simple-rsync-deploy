#!/bin/bash

# require a .deploy.env file to be present
if [ ! -f .deploy.env ]; then
  echo "Please create a .deploy.env file with the following content:"
  echo "target_path=ABSOLUTE PATH TO PLUGIN DIR WITHOUT TRAILING SLASH"
  echo "remote_server=SSH USER@HOST"
  echo "Do not use quotes. Consider adding the file to .gitignore."
  exit 1
else
  source .deploy.env
fi

# require a .deployignore 
if [ ! -f .deployignore ]; then
  echo "Please create a .deployignore file with at least following content:"
  echo ".deploy.env"
  echo ".deployignore"
  echo "deploy.sh"
  echo "- Any other patterns which are recognized by rsync for --exclude -"
  echo "Consider adding the file to .gitignore."
  exit 1
fi

# check if target_path is set
if [ -z "$target_path" ]; then
  echo "Please set target_path in .deploy.env"
  exit 1
fi

# check if remote_server is set
if [ -z "$remote_server" ]; then
  echo "Please set remote_server in .deploy.env"
  exit 1
fi

from="./"
to="$remote_server:$target_path"
to_port="22"

echo "Deploying local files to LIVE"
read -p "Do dry run? " -n 1 -r
echo # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Start dry run"
  rsync -aruv --delete --dry-run -e "ssh -o StrictHostKeyChecking=no -p ${to_port}" --exclude-from .deployignore "$from" "$to"
  echo "Dry run finished"
fi

read -p "Are you sure you want to deploy? " -n 1 -r
echo # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
  # do dangerous stuff
  rsync -aruv --delete -e "ssh -o StrictHostKeyChecking=no -p ${to_port}" --exclude-from .deployignore "$from" "$to"
  ssh -t "$remote_server" "cd $target_path && composer install && composer dump-autoload -o"
fi

exit 0
