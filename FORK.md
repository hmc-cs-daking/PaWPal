# Using forks for PaWPal

If you forked and cloned PaWPal for the first time, type

```
git remote add upstream https://github.com/hmc-cs-daking/PaWPal.git
```

This tells git that your forked repository should be syncable with the main 
repository.

Before you start a piece of work, or to sync up, you should do

```
git fetch upstream
git pull
git checkout master
git merge upstream/master
```

In order, this will:

1. Retrieve latest changes from the main repo

2. Pull your forked repo from github

3. Switch to the master branch (You should only be merging from your master branch. If you do any local branch work, merge to your master branch first)

4. Merges the main repo and your forked repo

After making changes, commit and push your changes. Then, you can make a pull 
request to the main repo.
