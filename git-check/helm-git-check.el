;;; helm-git-check.el --- Show git log with helm
;; Copyright (C) 2020 Kazuhiko Kamikado <kamikado3@gmail.com>
;; Package-Requires: (helm-core "1.9.8")

;; Add the following to your Emacs init file:
;; (require 'helm-git-check)
;; (setq load-path
;;       (append '(
;; 		"~/.emacs.d/<path to git check>/git-check/"
;;                 ) load-path))
;; (setq python_file_dir "~/.emacs.d/<path to git check>/git-check/")
;; (define-key global-map (kbd "M-q") 'helm-git-check)

;;; Code:
(require 'helm)

(defvar my-helm-source
  '((name . "my-helm-git-change")
    (init . my-check-init)
    (candidates . my-check-candidates)
    (fuzzy-match . t)
    (action . (("Go to" . my-check-action-goto-error)))
    )
  )

(defvar my-check-candidates nil)

(defun my-check-init ()
  "Initialize helm-source."
  (let
      ((output (shell-command-to-string (concat python_file_dir "parse.py for_helm"))))
    (setq output (split-string output "\n"))
    (setq my-check-candidates (mapcar 'my-check-make-candidate output))
    )
  )

(defun make_face (arg posinega)
  "Check whther erace or add"
  (if (string-equal posinega "+")
      (propertize arg 'face '(t :background "darkgreen" :weight bold))
    (propertize arg 'face '(t :background "darkred" :weight bold))
    )
  )

(defun my-check-make-candidate (error)
  "Return a cons constructed from string of message and ERROR."
  (let ((error_str  (format "%s" error))
	(error_str_split (split-string error ":"))
	(posinega (car (cdr (split-string error " "))))
	)
    (list (make_face error_str posinega) (format "%s" (car error_str_split)) (format "%s"(car (cdr error_str_split))))
    )
  )

(defun my-check-action-goto-error (candidate)
  "Visit error of CANDIDATE."
  (let* ((target_dir (car candidate))
	 (target_line (car (cdr candidate))))
    (switch-to-buffer (buffer-name (find-file-noselect target_dir)))
    (goto-char (point-min))
    (forward-line (- (string-to-number target_line) 1))
    )
  )

(defun helm-git-check ()
  "Show git history with `helm'."
  (interactive)
  (helm :sources 'my-helm-source
        :buffer "*helm-git-change*"
        )
  )


(provide 'helm-git-check)

;; Local Variables:
;; coding: utf-8
;; End:

;;; helm-git-check.el ends here
