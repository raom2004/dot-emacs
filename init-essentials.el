;;;~ org global customization

(use-package org
  :defer t
  :bind (("C-c a" . org-agenda)
	 ("C-c c" . org-capture)
	 ("C-c l" . org-store-link)
	 )

  ;;;~ download notes.org file from github
  :ensure-system-package
  ;; ("~/Documents/org/notes.org" .
  ;;  "git clone https://github.com/raom2004/notes ~/Documents/org")
  ("~/Projects/notes/notes.org" .
   "git clone https://github.com/raom2004/notes ~/Projects/notes")

  ;; :init
  :config

  ;;;~ functions to update fields in org files (/Projects/dot-emacs/src-org)

  (defun ra/find-replace (from to)
    "Find and replase string. It supports 'regexpr'."
    (interactive)
    (save-excursion
      (beginning-of-buffer)
      (while (re-search-forward from nil t)
        (replace-match to t))))

  (defun ra/org-update-updated ()
    (interactive)
    "Update field: 'Updated' in org buffer"
    (ra/find-replace
     "\\(^;; Updated: \\)\\(.*\\)"
     (format-time-string "\\1%Y-%m-%d %H:%M:%S")))

  (defun ra/org-update-source ()
    (interactive)
    "Update field: 'Source' in org buffer"
    (ra/find-replace
     "\\(^;; Source: \\)\\(.*\\)"
     (format "\\1%s"(file-name-nondirectory (buffer-file-name)))))

  (defun ra/src-org-update-fields ()
    (interactive)
    "Update fields 'Updated' (last modified) and 'Source' (org file) before save org files in '/home/angel/Projects/dot-emacs/src-org/' "
    (when
	(and (derived-mode-p 'org-mode)
	     (string-equal (file-name-directory (buffer-file-name))
			   "/home/angel/Projects/dot-emacs/src-org/"))
      (ra/org-update-updated)
      (ra/org-update-source)))

  ;;;~ functions to update fields in org files (/Projects/dot-emacs/src-org)
  ;;;~  source: https://emacs.stackexchange.com/questions/28871/how-to-remove-m-from-org-babel-code-block-executing-on-linux-from-windows-os

  (defadvice org-babel-sh-evaluate (around set-shell activate)
    "Add header argument :file-coding that sets the buffer-file-coding-system."
    (let ((file-coding-param (cdr (assoc :file-coding params))))
      (if file-coding-param
          (let ((file-coding (intern file-coding-param))
		(default-file-coding (default-value 'buffer-file-coding-system)))
            (setq-default buffer-file-coding-system file-coding)
            ad-do-it
            (setq-default buffer-file-coding-system default-file-coding))
	ad-do-it)))

  ;; :config

  ;;;~ hook to update fields in org files (/Projects/dot-emacs/src-org)

  (add-hook 'org-mode-hook
	    #'(lambda()
		(add-hook
		 'write-contents-functions 'ra/src-org-update-fields)) nil)
  
  ;;;~ set path to org directory
  (setq org-directory
        (expand-file-name "../Documents/org" user-emacs-directory))
  ;;;~ set path to org files
  (setq org-agenda-files
	(expand-file-name "../Documents/org/todo.org" user-emacs-directory))
  (setq org-default-notes-file
	(expand-file-name "../Projects/notes/notes.org" user-emacs-directory))
	;; (expand-file-name "../Documents/org/notes.org" user-emacs-directory))
  ;;;~ set persistent org mode clock in history
  (setq org-clock-persist 'history)
  (setq org-clock-persist-file
	(expand-file-name "../config/org-clock-save.org" user-emacs-directory))
  
  ;;;~ org basic customizations
  (setq org-adapt-indentation nil) 
  (setq org-confirm-babel-evaluate nil)
  (setq org-confirm-elisp-link-function nil)
  ;; (setq org-hide-emphasis-markers t) ;; hide markers: // ** == 
  (setq org-tags-column -66) 

  ;;;~ org babel customization

  (setq org-src-fontify-natively t) 
  (setq org-src-preserve-indentation t)  ;; do not indent code blocks
  (setq org-src-window-setup 'current-window) ;; eval in new frame

  ;;;~ open link in new window 

  (setq org-link-frame-setup
	'((vm . vm-visit-folder-other-frame)
	  (vm-imap . vm-visit-imap-folder-other-frame)
	  (gnus . org-gnus-no-new-news)
	  (file . find-file)                 ;open link in new window  
	  ;; (file . find-file-other-window) ;open link in new window  
	  ;; (file . find-file-other-frame)  ;open link in new frame
	  (wl . wl-other-frame)))

    ;;;~ org custom templates

  (setq org-structure-template-alist
	'(
	    ;;;~ text bloques
	  ("E" . "example")
	  ("M" . "comment")
	  ("N" . "notes")
	  ("Q" . "quote")
	    ;;;~ markup bloques
	  ("a" . "export ascii")
	  ("h" . "export html")
	  ("l" . "export latex")
	  ("x" . "export xml")
	    ;;;~ code bloques
	  ("0" . "src")
	  ("c" . "src C")
	  ("e" . "src emacs-lisp")
	  ("s" . "src shell :results verbatim")
	  ("b" . "src bash :results verbatim")
	  ("p" . "src python :results output")
	  )
	)	

    ;;;~ org add template
  
  (add-to-list
   'org-structure-template-alist
   '("B" .
     "src bash :results verbatim :dir \"/sudo::/\" :wrap src bash")
   t				;added at the end
   )

  (add-to-list
   'org-structure-template-alist
   '("P" .
     "src python :session python-session :results output :preamble (venv-workon \"biopython\")")
   t				;added at the end
   )

    ;;;~ org load babel languages

  (org-babel-do-load-languages
   'org-babel-load-languages
   '(
     (C          . t) ;; C, C++
     ;; (R          . t)
     ;; (clojure    . t)
     ;; (ditaa      . t)
     ;; (dot        . t) ;; graphviz-dot-mode
     (emacs-lisp . t)
     ;; (haskell    . t)
     ;; (js         . t)
     ;; (latex      . t)
     ;; (lua      . t)
     (org        . t)
     ;; (prolog     . t)
     (python     . t)
     ;; (sh         . t)
     (shell      . t)
     ;; (sql        . t)
     ;; (sqlite     . t)
     ))

  ;; perl support
  
  (require 'ob-perl)
  
  (use-package gnuplot
    :ensure t
    )

  (use-package gnuplot-mode
    :ensure t
    )

  ); end -- org --
