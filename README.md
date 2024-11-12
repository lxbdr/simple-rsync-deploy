# Simple rsync deployment

- Deploy directory to remote via SSH using rsync
- Exclude files
- Dry run

# WARNING
The script will prompt for a dry run and before executing the actual command. The command has the `--delete` flag to sync the contents, which will delete files on remote not present in the local directory.
Make sure to double check all paths before running this. Deleted files cannot or not easily be restored.

## Installation
Copy deploy.sh file to the directory whose content you want to deploy.
Make it executable with `chmod +x deploy.sh`.

Create a `.deploy.env` file, add these content:
```
target_path=ABSOLUTE PATH TO PLUGIN DIR WITHOUT TRAILING SLASH
remote_server=USER@HOST (SSH)
```

Create a `.deployignore` file, add these contents and all other lines which are compatible with rsync `--exclude`:
```
.deployignore
.deploy.env
deploy.sh
.git
.env
```

Run with `./deploy.sh`
