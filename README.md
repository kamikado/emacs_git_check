# git-check.el helm-git-check.el

Show git log  with helm and completion mode.

## Requirements

- [helm]
- git

## Configuration

Add the following to your emacs init file.\
    (setq load-path
    	    (append '(
	    		"\~/.emacs.d/\<path to git check\>/git-check/"
           		    ) load-path))\
    (require 'git-check)\
    (require 'helm-git-check)\
    (setq python_file_dir "\~/.emacs.d/\<path to git check\>/git-check/")
    
## Basic usage
#### <kbd>M-x</kbd> `git-check`
#### <kbd>M-x</kbd> `helm-git-check`

## Picture
![git-checkhttps](https://github.com/kamikado/emacs_git_check/blob/master/git-check.png?raw=true)
![helm-git-check](https://github.com/kamikado/emacs_git_check/blob/master/helm-git-check.png?raw=true)