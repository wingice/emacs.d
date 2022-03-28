;; Markdown mode
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(add-hook 'markdown-mode-hook (lambda () (visual-line-mode)))

;; appt and reminder
(require 'appt)
;;(setq org-agenda-include-diary t)
(setq appt-time-msg-list nil)
;; the appointment notification facility
(setq
  appt-message-warning-time 3
  appt-display-mode-line t ;; show in the modeline
)

;;(appt-activate 1) ;; active appt (appointment notification)
(display-time) ;; time display is required for this...

;; the appointment notification facility
(setq
 appt-message-warning-time 3
 appt-display-mode-line t ;; show in the modeline
 display-time-default-load-average nil
 appt-display-format 'window) ;; use our func

(defun popup-appt-msg(min-to-app new-time appt-msg)
  (interactive)
  (select-frame-set-input-focus (selected-frame))
  (if (functionp 'popup-notification)
      (popup-notification "GTD" appt-msg))
)
(setq appt-disp-window-function (function popup-appt-msg))


(defun my-org-clocktable-indent-string (level)
  (if (= level 1)
      ""
    (let ((str "\\"))
      (while (> level 2)
        (setq level (1- level)
              str (concat str "___")))
      (concat str "_ "))))




(use-package org
  :defer
  :hook (org-mode . (lambda ()(add-hook 'before-save-hook 'org-agenda-to-appt t t)))
  :config
  (setq org-clock-into-drawer nil)
  (setq org-clock-clocktable-default-properties '(:maxlevel 5 :scope file :block today :indent t :link t))
  (setq org-clock-into-drawer nil)
  (setq org-startup-indented t)
  (setq org-clock-persist 'history)
  (org-clock-persistence-insinuate) ;; Resume clocking tasks when emacs is restarted
  (setq org-clock-persist-query-resume nil) ;; Do not prompt to resume an active clock
  (defun my-after-load-org ()  (add-to-list 'org-modules 'org-timer))
  (eval-after-load "org" '(my-after-load-org))
  (setq org-timer-default-timer 25)

  (setq org-clock-clocktable-default-properties '(:maxlevel 5 :scope file :block today :indent t :link t))
  (add-to-list 'auto-mode-alist '("\\.\\(org\\ |org_archive\\|txt\\)$" . org-mode))
  ;;Modify the org-clock-in so that a timer is started with the default
  ;;value except if a timer is already started :
  (add-hook 'org-clock-in-hook '(lambda ()
				  (if (not org-timer-default-timer)
				      (org-timer-set-timer '(16)))))
  (add-hook 'org-clock-out-hook '(lambda ()
				   (setq org-mode-line-string nil)
				   (org-timer-cancel-timer)
				   ))
  (add-hook 'org-timer-done-hook '(lambda()
				    (popup-notification "Congratulations!" "You Finished a Pomodoro Task!")))
  ;; update appt each time agenda opened
  (add-hook 'org-finalize-agenda-hook 'org-agenda-to-appt)
  (advice-add 'org-clocktable-indent-string :override #'my-org-clocktable-indent-string)
  :bind (("C-c a" . 'org-agenda)
         ("C-c c" . 'org-capture)
         ("C-c r" . 'org-remember)))

(setq org-agenda-custom-commands
      '(("d" "Daily Planner"
         ((agenda "")
          (tags-todo "NA"                                         ;; todos sorted by context
                ((org-agenda-prefix-format "[ ] %T: ")
                 (org-agenda-sorting-strategy '(tag-up priority-down))
                 (org-agenda-todo-keyword-format "")
		 (org-deadline-warning-days 5)
                 (org-agenda-overriding-header "TODO & NA:")))

	  (todo "TODO" ((org-agenda-overriding-header "Todo:")
			(org-agenda-sorting-strategy '(tag-up priority-down))
			))
	  (todo "HOLD" ((org-agenda-overriding-header "Hold and Waiting:")
			(org-agenda-sorting-strategy '(tag-up priority-down))
			))
	  (todo "DELEGATED" ((org-agenda-overriding-header "Delegated:")
			(org-agenda-sorting-strategy '(tag-up priority-down))
			))
	  (tags "NA" ((org-agenda-overriding-header "Next Action:")))
	  ))
        ))

(setq org-todo-keywords
  '((sequence "TODO" "HOLD" "|" "DONE" "DELEGATED")))

(setq org-capture-templates
 '(("t" "Todo" entry (file+headline "" "Tasks")
        "* TODO %?\n  %i\n  %a\n")
   ("b" "Bookmark" entry (file+headline "" "Bookmarks")
        "* %?\nEntered on %U\n  %i\n  %a\n")))

(use-package emacsql-sqlite3
  :ensure t
  )


(use-package org-roam
  :after org
  :ensure t
  :commands (org-oram-node-find org-roam-node-insert)
  :init
  (setq org-roam-database-connector 'sqlite3)
  (setq org-roam-v2-ack t)
  :config
  (setq org-roam-tag-sources '(prop all-directories))
  (setq org-roam-completion-system 'helm)
  (setq org-roam-index-file "org-roam-note-index.org")
  (org-roam-db-autosync-mode)
  (setq org-roam-capture-templates
      '(("i" "internet tools and bookmarks" plain "%?"
	 :target (file+head "internet/${slug}-%<%Y%m%d%H%M%S>.org"
	                    "#+title: ${title}")
	 :unnarrowed t)
	("r" "research and development" plain "%?"
	 :target (file+head "research/${slug}-%<%Y%m%d%H%M%S>.org"
			    "#+title: ${title}")
	 :unnarrowed t)
	("g" "growth and learning" plain "%?"
	 :target (file+head "growth/${slug}-%<%Y%m%d%H%M%S>.org"
			    :head "#+title: ${title}")
	 :unnarrowed t)
	("h" "hobbies" plain "%?"
	 :target (file+head "hobbies/${slug}-%<%Y%m%d%H%M%S>.org"
			    "#+title: ${title}")
	 :unnarrowed t)
	("p" "parenting" "%?"
	 :target (file+head "parenting/${slug}-%<%Y%m%d%H%M%S>.org"
			    "#+title: ${title}")
	 :unnarrowed t)
	("a" "all/general knowledges" plain "%?"
	 :target (file+head "general/${slug}-%<%Y%m%d%H%M%S>.org"
	                    "#+title: ${title}")
	 :unnarrowed t)
	)))


(defun compile-on-save-start ()
  (let ((buffer (compilation-find-buffer)))
    (unless (get-buffer-process buffer)
      (recompile))))

(define-minor-mode compile-on-save-mode
  "Minor mode to automatically call `recompile' whenever the
current buffer is saved. When there is ongoing compilation,
nothing happens."
  :lighter " CoS"
    (if compile-on-save-mode
    (progn  (make-local-variable 'after-save-hook)
        (add-hook 'after-save-hook 'compile-on-save-start nil t))
      (kill-local-variable 'after-save-hook)))

  (global-set-key (kbd "C-c n i") 'org-roam-node-insert)
  (global-set-key (kbd "C-c n f") 'org-roam-node-find)

(provide 'init-authoring)
