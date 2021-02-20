;; Markdown mode
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(add-hook 'markdown-mode-hook (lambda () (visual-line-mode)))

;; OrgMode
(define-key global-map "\C-cr" 'org-remember)
(add-to-list 'auto-mode-alist '("\\.\\(org\\ |org_archive\\|txt\\)$" . org-mode))
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)

(add-hook 'org-mode-hook
	  (lambda()
	    (add-hook 'before-save-hook 'org-agenda-to-appt t t)
	    ))
(setq org-clock-into-drawer nil)
(setq org-clock-clocktable-default-properties '(:maxlevel 5 :scope file :block today :indent t :link t))

;; appt and reminder
(require 'appt)
;;(setq org-agenda-include-diary t)
(setq appt-time-msg-list nil)
(setq org-startup-indented t)

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


(defun my-org-clocktable-indent-string (level)
  (if (= level 1)
      ""
    (let ((str "\\"))
      (while (> level 2)
        (setq level (1- level)
              str (concat str "___")))
      (concat str "_ "))))

(advice-add 'org-clocktable-indent-string :override #'my-org-clocktable-indent-string)


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
        "* TODO %?\n  %i\n  %a")
   ("b" "Bookmark" entry (file+olp+datetree "")
        "* %?\nEntered on %U\n  %i\n  %a")))

(defun popup-appt-msg(min-to-app new-time appt-msg)
  (interactive)
  (select-frame-set-input-focus (selected-frame))
  (if (functionp 'popup-notification)
      (popup-notification "GTD" appt-msg))
)

  (setq org-clock-persist 'history)
  (org-clock-persistence-insinuate) ;; Resume clocking tasks when emacs is restarted
  (setq org-clock-persist-query-resume nil) ;; Do not prompt to resume an active clock




(setq org-timer-default-timer 25)
;;Modify the org-clock-in so that a timer is started with the default
;;value except if a timer is already started :
(add-hook 'org-clock-in-hook '(lambda ()
				(if (not org-timer-current-timer)
				    (org-timer-set-timer '(16)))))
(add-hook 'org-clock-out-hook '(lambda ()
				 (setq org-mode-line-string nil)
				 (org-timer-cancel-timer)
				 ))

(add-hook 'org-timer-done-hook '(lambda()
				  (popup-notification "Congratulations!" "You Finished a Pomodoro Task!")))

(defun my-after-load-org ()
  (add-to-list 'org-modules 'org-timer))
(eval-after-load "org" '(my-after-load-org))


(setq nxml-child-indent 4 nxml-attribute-indent 4)

;; update appt each time agenda opened
(add-hook 'org-finalize-agenda-hook 'org-agenda-to-appt)
(setq appt-disp-window-function (function popup-appt-msg))
(add-hook 'org-mode-hook
	  (lambda()
	    (add-hook 'before-save-hook 'org-agenda-to-appt t t)
	    ))

(add-hook 'after-init-hook 'org-roam-mode)
(setq org-roam-tag-sources '(prop all-directories))
(setq org-roam-completion-system 'helm)

(setq org-roam-index-file "org-roam-note-index.org")
(setq org-roam-capture-templates
      '(("i" "internet tools and bookmarks" plain #'org-roam-capture--get-point
	 "%?"
	 :file-name "internet/${slug}-%<%Y%m%d%H%M%S>"
	 :head "#+title: ${title}"
	 :unnarrowed t)
	("r" "research and development" plain #'org-roam-capture--get-point
	 "%?"
	 :file-name "research/${slug}-%<%Y%m%d%H%M%S>"
	 :head "#+title: ${title}"
	 :unnarrowed t)
	("g" "growth and learning" plain #'org-roam-capture--get-point
	 "%?"
	 :file-name "growth/${slug}-%<%Y%m%d%H%M%S>"
	 :head "#+title: ${title}"
	 :unnarrowed t)
	("a" "all/general knowledges" plain #'org-roam-capture--get-point
	 "%?"
	 :file-name "general/${slug}-%<%Y%m%d%H%M%S>"
	 :head "#+title: ${title}"
	 :unnarrowed t)
	("h" "hobbies" plain #'org-roam-capture--get-point
	 "%?"
	 :file-name "hobbies/${slug}-%<%Y%m%d%H%M%S>"
	 :head "#+title: ${title}"
	 :unnarrowed t)
	))
(provide 'init-authoring)
