;; Markdown mode  -*- lexical-binding: t; -*-
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

;; the appointment notification facility
(setq
 appt-message-warning-time 3
 appt-display-mode-line t ;; show in the modeline
 display-time-default-load-average nil
 appt-display-format 'window) ;; use our func

;;(appt-activate 1) ;; active appt (appointment notification)
(display-time) ;; time display is required for this...


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
  (defun my-org-capture () (interactive) (org-capture  "t" "t"))
  (advice-add 'remember :override #'org-capture)
  (eval-after-load "org" '(my-after-load-org))
  (setq org-timer-default-timer 25)

  (setq org-clock-clocktable-default-properties '(:maxlevel 5 :scope file :block today :indent t :link t))
  (add-to-list 'auto-mode-alist '("\\.\\(org\\ |org_archive\\|txt\\)$" . org-mode))
  ;;Modify the org-clock-in so that a timer is started with the default
  ;;value except if a timer is already started :
  (add-hook 'org-clock-in-hook #'(lambda ()
				   (org-timer-set-timer '(16))
				   (start-screen-timer)
				   ))
  (add-hook 'org-clock-out-hook #'(lambda ()
				   (setq org-mode-line-string nil)
				   (org-timer-stop)
				   ))
  (add-hook 'org-timer-done-hook #'(lambda()
				    (popup-notification "Congratulations!" "You Finished a Pomodoro Task!")))
  ;; update appt each time agenda opened
  (add-hook 'org-finalize-agenda-hook 'org-agenda-to-appt)
  (advice-add 'org-clocktable-indent-string :override #'my-org-clocktable-indent-string)
  (global-set-key (kbd "<f2>") 'my-org-capture)
  (global-set-key (kbd "S-<f2>") 'my-capture-file)
  (define-key org-mode-map (kbd "M-.") 'nf/link-to-headline)
  :bind (("C-c a" . 'org-agenda)
         ("C-c c" . 'my-org-capture)
         ("C-c r" . 'remember)))

(setq org-agenda-custom-commands
      '(("d" "Daily Planner"
         ((agenda "")
          (tags-todo "@work"                                         ;; todos sorted by context
                ((org-agenda-prefix-format "[ ] %T: ")
                 (org-agenda-sorting-strategy '(tag-up priority-down))
                 (org-agenda-todo-keyword-format "%-12s")
		 (org-deadline-warning-days 5)
                 (org-agenda-overriding-header "TODO@work:")))
          (tags-todo "@home"                                         ;; todos sorted by context
                ((org-agenda-prefix-format "[ ] %T: ")
                 (org-agenda-sorting-strategy '(tag-up priority-down))
                 (org-agenda-todo-keyword-format "%-12s")
		 (org-deadline-warning-days 5)
                 (org-agenda-overriding-header "TODO@home:")))
	  (tags "action" ((org-agenda-overriding-header "Next Action:")))
	  (todo "TODO" ((org-agenda-overriding-header "TODO:")
			(org-agenda-sorting-strategy '(tag-up priority-down))
			))
	  (todo "LTDO" ((org-agenda-overriding-header "LTDO:")
			(org-agenda-sorting-strategy '(tag-up priority-down))
			))
	  (todo "HOLD" ((org-agenda-overriding-header "Hold and Waiting:")
			(org-agenda-sorting-strategy '(tag-up priority-down))
			))
	  (todo "DELEGATED" ((org-agenda-overriding-header "Delegated:")
			(org-agenda-sorting-strategy '(tag-up priority-down))
			))
	  ))
        ))

(setq org-todo-keywords
  '((sequence "TODO" "LTDO" "HOLD" "|" "DONE" "DELEGATED")))

(setq org-capture-templates
 '(("t" "Todo" entry (file+headline "" "Tasks")
    "* TODO %?\n  %i\n  %a\n\n")
 '("r" "Reminder" entry (file+headline "" "Reminders")
    "* %?\n  %i\n  %a\n\n")
 '("b" "Bookmark" entry (file+headline "" "Bookmarks")
    "* TODO %?\n  %i\n  %a\n\n")
 '("f" "Reference" entry (file+headline "" "Reference")
    "* TODO %?\n  %i\n  %a\n\n"))
)


(defun nf/parse-headline (x)
    (plist-get (cadr x) :raw-value))

(defun nf/get-headlines ()
  (org-element-map (org-element-parse-buffer) 'headline #'nf/parse-headline))

(defun nf/link-to-headline ()
  "Insert an internal link to a headline."
  (interactive)
  (let* ((headlines (nf/get-headlines))
	 (choice (completing-read "Headings: " headlines nil t))
	 )
    (org-insert-link buffer-file-name (concat "*" choice) choice)))

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

(defun useful()
  (interactive)
  (org-roam-capture))

(defun delete-existed-file(filename)
  (when (file-exists-p filename) (delete-file filename)))

(defconst webdav-user (getenv "WEBDAV_USER"))  ;; Need an ENV var WEBDAV_USER=user:token
(defconst webdav-path "https://domi.teracloud.jp/dav/gtd/")
(defconst server-file-name "mgtd.org")

(defun download-webdav-file(local_file_path)
  (interactive)
  (shell-command (concat "curl -u " webdav-user " " webdav-path server-file-name " --output " local_file_path)))

(defun upload-webdav-file(local_file_path)
  (interactive)
  (shell-command (concat "curl -T " local_file_path " -u " webdav-user " " webdav-path)))

(defun mobile-gtd-tmp-file()
  (file-truename (concat emacs-tmp-dir server-file-name)))

(defun mobile-gtd-read()
  (interactive)
  (setq tmp-file (mobile-gtd-tmp-file))
  (delete-existed-file tmp-file)
  (download-webdav-file tmp-file)
  (find-file tmp-file))

(defun mobile-gtd-push()
  (interactive)
  (setq tmp-file (mobile-gtd-tmp-file))
  (upload-webdav-file tmp-file))

(provide 'init-authoring)
