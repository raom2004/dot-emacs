;; init-openbox.el -- Emacs init file -*- lexical-binding: t -*-
;;
;;;; ====================== HEADER =========================
;;
;; Title: Emacs Init File with a list of files to open at startup
;; Author: Ricardo Orbegozo
;; Created: 2020-04-13
;; Updated: 2023-02-14 20:11:38
;;
;;;~ Description:
;;;~  emacs init file that include other relevant dot-files,
;;;~  open and fullfil the screen with three buffers,
;;;~  and finally set which files will be shown in each buffer


(setq initial-scratch-message "# This buffer is for text that is not saved, and for org babel evaluation.
# To create a file, visit it with \\[find-file] and enter text in its buffer.\n\n#+begin_src bash :results verbatim\n\n#+end_src\n")

;;;~ FRAME 1: load custom init file: user-init-file
(progn
  (org-mode)
  ;; (org-insert-structure-template "bash")
  ;;;~ set custom init file,and also automatically showed at startup 
  ;; (setq user-init-file (buffer-file-name))
  (setq user-init-file "~/Projects/dot-emacs/init-openbox.el")
  ;; (find-file "~/Projects/dot-emacs/init-openbox.el")
  ;;;~ load other init files:
  ;;;~  * basic configuration
  (load-file "~/Projects/dot-emacs/init-essentials.el")
  ;;;~  * show startup message
  (load-file "~/Projects/dot-emacs/init-startup-time.el")
  ;;;~  * dont show startup statistics
  (remove-hook 'emacs-startup-hook 'use-package-report)
  ;;;~ set org-mode in scratch buffer (didn't work)
  ;; (setq initial-major-mode 'sh-mode); originally was emacs-lisp-mode
  )

;;;~ FRAME 2: open openbox configuration files in new frame
(progn
  (make-frame)
  (other-frame 1)
  (switch-to-buffer "*scratch*")
  (defun raom/find-file-exist-p (file) 
    (ignore-errors (find-file-existing file) (read-only-mode 1)))
  (raom/find-file-exist-p
   "~/Projects/dot-emacs/src-org/init-openbox.org")
  (raom/find-file-exist-p
   "~/Projects/dot-emacs/init-essentials.el")
  (raom/find-file-exist-p
   "~/Projects/archlinux/desktop/openbox/autostart")
  (raom/find-file-exist-p
   "~/Projects/archlinux/desktop/openbox/shortcuts-openbox.sh")
  )

;;;~ FRAME 3:
(progn
  (make-frame)
  (other-frame 2)
  (modify-frame-location-upper-right)
  )
  
(add-hook 'emacs-startup-hook
	    #'(lambda ()
		(interactive)
		(other-frame -1)
		(next-line 4)
		)
	    )
