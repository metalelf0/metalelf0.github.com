---
title: 'Git: preview conflicts'
date: "2014-07-12T00:00:00Z"
categories:
- posts
- technical
tags:
- git
---


Hi everyone!

What we're trying to tackle today is a very common problem, that I'm sure all of you encountered. Suppose you're on your git feature branch, you want to merge it into another branch (being it master, staging, production, whatever) and you're asking yourself: _will there be conflicts?_.

If you're using Github, you can simply open the Pull Request page for your feature branch and look for the following box:

![github-safe-merge](assets/images/2014-07-12-git-preview-conflicts-without-touching-the-working-copy/github-safe-merge.png)

This is informing you there will be no conflicts and a merge will run smooth.

But what could you do if you didn't use Github, or you were just too lazy to open it? Creating a new branch just to do the merge is a solution, but I was pretty sure git had something better to offer `;)`

The best solution I found [here on StackOverflow](http://stackoverflow.com/questions/501407/is-there-a-git-merge-dry-run-option) is this: create the following git aliases in your `~/.gitconfig` file:

```
[alias]
  # check how the merge of dev into master will go:
  # git dry dev master
  dry = "!f() { git merge-tree `git merge-base $2 $1` $2 $1; }; f"

  # see if there will be any conflicts merging dev into master:
  # git conflicts dev master
  conflicts = "!f() { git merge-tree `git merge-base $2 $1` $2 $1 | grep -A3 'changed in both'; }; f"
```

The first command will show the changelog for the merge of your feature branch into master:

```
╰─$ git dry feature_two staging
changed in both
  base   100644 e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 first_file
  our    100644 deba01fc8d98200761c46eb139f11ac244cf6eb5 first_file
  their  100644 dc1ff7f95ac4812480edad5ec13d4c1a20066377 first_file
@@ -1 +1,5 @@
+<<<<<<< .our
 something
+=======
well, something else?
+>>>>>>> .their
```

This is showing us there will be a conflict when trying to merge the `feature_two` branch into `staging`: the file `first_file` is changed in both the branches, and this will generate a conflict.

The second command is just a shorthand that will limit the output to the lines related to the changed files, without the full changelog.

```
╰─$ git conflicts feature_two staging
changed in both
  base   100644 e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 first_file
  our    100644 deba01fc8d98200761c46eb139f11ac244cf6eb5 first_file
  their  100644 dc1ff7f95ac4812480edad5ec13d4c1a20066377 first_file
```

I hope you found this interesting, feel free to comment if you think it's still improvable!
