;TODO: add support for more extensions, and add automatically magit-svn if possible

(setq
 vc-handled-backends '(Git Hg CVS SVN Bzr)
 ;; always opening the real file instead!
 vc-follow-symlinks t)

(autoload 'svn-status "psvn" "svn status" t)

(autoload 'magit "magit")
(autoload 'magit-status "magit")

(eval-after-load 'magit-svn
  '(require 'magit-svn))

(defun ca-detect-git-svn ()
  "Detects if the project is actually git-svn or not"
  (interactive)
  (with-temp-buffer
    (insert-file-contents ".git/config")
    (goto-line 0)
    ;; (catch)
    (condition-case err
        (re-search-forward "svn-remote")
      (search-failed -1))))

(setq magit-log-edit-confirm-cancellation t)
;; use tty which should be faster, passphrase not allowed here
(setq magit-process-connection-type nil)
(setq magit-process-popup-time 10)

(add-hook 'magit-log-edit-mode-hook 'orgtbl-mode)
(add-hook 'magit-log-edit-mode-hook 'orgstruct-mode)
(add-hook 'magit-log-edit-mode-hook 'flyspell-mode)
(add-hook 'magit-log-edit-mode-hook 'auto-fill-mode)

;TODO: use  (vc-ensure-vc-buffer) to make it more general

(defun ca-is-version-control-file ()
  "Return nil unless the file is in the git files"
  (if (vc-working-revision (buffer-file-name))
      (auto-revert-mode t)))

(add-hook 'find-file-hook 'ca-is-version-control-file)

(provide 'ca-vc)
