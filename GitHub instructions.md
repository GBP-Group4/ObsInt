# Begin using GitHub in JupyterHub
## Start new terminal

mkdir ProjectWork\
cd ProjectWork\
git init\
git config --global user.email "insert github email here"\
git config --global user.name "insert github name here"\
git remote add origin https://github.com/GBP-Group4/ObsInt \
git pull origin main
## List branches
git branch -a
## Checkout existing branch
git checkout <branch_name>
## Create new branch and publish to in GitHub 
git checkout -b <new_branch>\
git push -u origin <new_branch>
## After working on the code
git commit -m 'Type message here'
## For an already existing branch in GitHub
git push origin <branch_name>
## Delete a branch on GitHub 
git push origin :BranchName
## Delete a branch locally (Force delete use -D)
git branch -d <branch_name>

# Steps to follow:
NEVER work on the main branch\
Tell GROUP every time a pull request has been merged with main. Don’t let your group members fall behind.\
Pull often, just to be sure. Even if no one has told you about changes on main, pull anyways.\
There is a visual of how far behind your branch is from main on GitHub under Branches.\
Double check with Group members before merging.\
Make sure you are on a branch before you start coding. Get in the habit of checking.

## get the latest pull version from main (Before October 2020 it was referred to as master, courtesy Black Lives Matter)
git pull origin main
## Checkout current branch or create a branch
git checkout <branch_name>
## add file you want to make changes to
git add <file_name>
## after making changes to the file, commit locally with a meaningful message
git commit -m 'Type message here'
# push to GitHub once you feel its ready to merge with main.
git push origin <branch_name>
## or 
git push
## merge your branch with main. Comment on pull request.
git merge main
## review on GitHub and you can delete branch name after successful merge
git branch -d <branch_name>
