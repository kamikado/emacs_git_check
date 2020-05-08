;;; git-check.el --- Show git log with compilation mode
;; Copyright (C) 2020 Kazuhiko Kamikado <kamikado3@gmail.com>

;; Add the following to your Emacs init file:
;;  (require 'git-check)
;; (setq load-path
;;       (append '(
;; 		"~/.emacs.d/<path to git check>/git-check/"
;;                 ) load-path))
;; (setq python_file_dir "~/.emacs.d/<path to git check>/git-check/")
;; (define-key global-map (kbd "M-s") 'git-check)

;;; Code:

;; file path for parse.py
(setq python_file_dir "")

(defvar my/file-column-pattern-add
  "\\+\\([[:digit:]]+\\):\\([[:digit:]]+\\):\\(.*\\)"
  "A regexp pattern to match line number and column number with grouped output.")

(defvar my/file-column-pattern-remove
  "\\-\\([[:digit:]]+\\):\\([[:digit:]]+\\):\\(.*\\)"
  "A regexp pattern to match line number and column number with grouped output.")

(defvar my/file-column
  "^File: \\(.*\\)"
  "A regexp pattern to match line number and column number with grouped output.")

(defface face-add
  '((t :background "darkgreen" :weight bold)) "highlight incorrect output in red")

(defface face-remove
  '((t :background "darkred" :weight bold)) "show expected output in green")

(defface face-file
  '((t :foreground "black" :background "gold" :weight bold)) "show expected output in green")

(defun my/compilation-match-grouped-filename ()
  "Match filename backwards when a line/column match is found in grouped output mode."
  (save-match-data
    (save-excursion
      (when (re-search-backward "^File: \\(.*\\)$" (point-min) t)
        (list (match-string 1))))))

(define-compilation-mode my-git-mode "MyGit"
  "My git results compilation mode"
  (set (make-local-variable 'compilation-error-regexp-alist) '(compilation-my-add compilation-my-remove compilation-my-file))
  (set (make-local-variable 'compilation-error-regexp-alist-alist)
       (list (cons 'compilation-my-add  (list my/file-column-pattern-add
					       'my/compilation-match-grouped-filename 1 2
					       nil nil '(0 'face-add)))
	     (cons 'compilation-my-remove  (list my/file-column-pattern-remove
       						 'my/compilation-match-grouped-filename 1 2
       						 nil nil '(0 'face-remove)))
	     (cons 'compilation-my-file  (list my/file-column 1 0 0 nil nil '(0 'face-file)))
	     )
       )
  )

(defun git-check (num)
  "`num' represent deps of git log Show git history in my-git-change mode."
  (interactive (list (read-number "Input Num: " 0)))
  (setq num (number-to-string num))
  (setq command (concat python_file_dir "parse.py " num))
  (compilation-start command #'my-git-mode `(lambda (mode-name) , "*git-check*"))
  )

(provide 'git-check)

;; Local Variables:
;; coding: utf-8
;; End:

;;; git-check.el ends here
