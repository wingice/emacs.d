;; Markdown mode  -*- lexical-binding: t; -*-
(use-package markdown-mode
  :ensure t
  :mode (("\\.text\\'" . markdown-mode)
         ("\\.md\\'" . markdown-mode))
  :hook (markdown-mode . visual-line-mode))

;; appt and reminder
(require 'appt)
;;(setq org-agenda-include-diary t)
(setq appt-time-msg-list nil)
;; the appointment notification facility
(setq
 appt-message-warning-time 3
 appt-display-mode-line t ;; show in the modeline
 display-time-default-load-average nil
 appt-display-format 'window) ;; use our func

;;(appt-activate 1) ;; active appt (appointment notification)
(display-time-mode 1)


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


(define-minor-mode my-pomodoro-presentation-mode
  "Silence Pomodoro alerts and automatic locking while presenting.
Countdowns, clock tracking, and statistics continue normally.
Break reminders resume on their next scheduled tick when disabled."
  :global t
  :group 'org-clock
  :lighter " Present")

(defun my-pomodoro--quiet-countdown-notification (notify &rest args)
  "Call NOTIFY with ARGS unless a countdown expires while presenting."
  ;; Emacs records the timer identity before invoking its callback.  Org
  ;; notifies before running its done hook, so guarding that hook is too late.
  (unless (and my-pomodoro-presentation-mode
               (timerp org-timer-countdown-timer)
               (eq timer-event-last org-timer-countdown-timer))
    (apply notify args)))

(with-eval-after-load 'org-timer
  (advice-add 'org-notify :around #'my-pomodoro--quiet-countdown-notification))

(defvar my-pomodoro-break-reminder-timer nil
  "Timer reminding me to clock in after a Pomodoro break.")

(defun my-pomodoro--cancel-break-reminder ()
  "Cancel any pending reminder to clock in."
  (when (timerp my-pomodoro-break-reminder-timer)
    (cancel-timer my-pomodoro-break-reminder-timer))
  (setq my-pomodoro-break-reminder-timer nil))

(defun my-pomodoro--remind-to-clock-in ()
  "Remind me to clock in, unless a task is already being clocked."
  (if (org-clocking-p)
      (my-pomodoro--cancel-break-reminder)
    (unless my-pomodoro-presentation-mode
      (popup-notification "Pomodoro break is over"
                          "Ready to resume? Clock in to a task to start your next work session."))))

(defun my-pomodoro--start-break-reminder ()
  "Remind me after five minutes, then every minute until I clock in."
  (my-pomodoro--cancel-break-reminder)
  (setq my-pomodoro-break-reminder-timer
        (run-at-time (* 5 60) 60 #'my-pomodoro--remind-to-clock-in)))

(defun my-pomodoro--clock-in ()
  "Cancel break reminders and start the task's work countdown."
  (my-pomodoro--cancel-break-reminder)
  (org-timer-set-timer '(16)))

(defun my-pomodoro--clock-out ()
  "Clear the clock display and stop the work countdown."
  (setq org-mode-line-string nil)
  (when org-timer-start-time
    (org-timer-stop)))

(defun my-pomodoro--finish ()
  "Clock out and schedule break reminders for a completed work session."
  (when (org-clocking-p)
    ;; Start the break before tracking or notification errors can interrupt it.
    (org-clock-out)
    (my-pomodoro--start-break-reminder)
    (my-pomodoro-increment-today-count)
    (unless my-pomodoro-presentation-mode
      (popup-notification "Congratulations!" "You Finished a Pomodoro Task!"))))

(use-package org
  :defer t
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
  (advice-add 'remember :override #'my-org-capture)
  (eval-after-load "org" '(my-after-load-org))
  (setq org-timer-default-timer 25)

  (setq org-clock-clocktable-default-properties '(:maxlevel 5 :scope file :block today :indent t :link t))
  (add-to-list 'auto-mode-alist '("\\.\\(org\\ |org_archive\\|txt\\)$" . org-mode))
  (add-hook 'org-clock-in-hook #'my-pomodoro--clock-in)
  (add-hook 'org-clock-out-hook #'my-pomodoro--clock-out)
  (add-hook 'org-timer-done-hook #'my-pomodoro--finish)
  ;; update appt each time agenda opened
  (add-hook 'org-finalize-agenda-hook 'org-agenda-to-appt)
  (advice-add 'org-clocktable-indent-string :override #'my-org-clocktable-indent-string)
  (global-set-key (kbd "<f2>") 'my-org-capture)
  (global-set-key (kbd "S-<f2>") 'my-capture-file)
  (global-set-key (kbd "C-c m") 'my-meeting-increment-today-count)
  (define-key org-mode-map (kbd "M-.") 'nf/link-to-headline)
  :bind (("C-c l" . 'org-store-link)
	 ("C-c a" . 'org-agenda)
         ("C-c c" . 'my-org-capture)
         ("C-c r" . 'remember)))

(add-hook 'org-mode-hook 'auto-save-visited-mode)

(setq org-agenda-prefix-format
      (quote
       ((agenda . "%-14c%?-14t% s")
        (timeline . "% s")
        (todo . "%-14:c")
        (tags . "%-14:c")
	(tags-todo "[ ] %T: ")
        (search . "%-14:c"))))

(setq org-agenda-custom-commands
      '(("d" "Daily Planner"
         ((agenda "")
          (tags-todo "@work"                                         ;; todos sorted by context
                (
                 (org-agenda-sorting-strategy '(tag-up priority-down))
                 (org-agenda-todo-keyword-format "%-12s")
		 (org-deadline-warning-days 5)
                 (org-agenda-overriding-header "TODO@work:")))
          (tags-todo "@home"                                         ;; todos sorted by context
                (
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
    "* TODO %x \n  %i\n  %a\n\n")
 '("r" "Reminder" entry (file+headline "" "Reminders")
    "* %?\n  %i\n  %a\n\n")
 '("b" "Bookmark" entry (file+headline "" "Bookmarks")
    "* TODO %?\n  %i\n  %a\n\n")
 '("f" "Reference" entry (file+headline "" "Reference")
    "* TODO %?\n  %i\n  %a\n\n"))
)

(defun my-org-get-clock-segment-timestamps (line)
  "Return (T1 T2) timestamps from LINE, or nil if LINE is not a CLOCK range."
  (let ((org-clock-regexp (concat "CLOCK: " org-ts-regexp3 "--" org-ts-regexp3)))
    (when (string-match org-clock-regexp line)
      (list (match-string 1 line) (match-string 9 line)))))

(ert-deftest org-timestamp-test ()
  (should (equal
           (my-org-get-clock-segment-timestamps "CLOCK: [2019-09-26 Thu 00:29]--[2019-09-26 Thu 01:11] => 0:42")
           '("2019-09-26 Thu 00:29" "2019-09-26 Thu 01:11"))))

(ert-deftest my-pomodoro-presentation-silences-only-countdown-alerts ()
  "Presentation mode silences even countdowns started before enabling it."
  (require 'org-timer)
  (let ((org-timer-start-time nil)
        (org-timer-pause-time nil)
        (org-timer-countdown-timer nil)
        (org-timer-countdown-timer-title nil)
        (org-timer-display nil)
        (org-timer-mode-line-timer nil)
        (org-timer-mode-line-string nil)
        (org-timer-set-hook nil)
        (org-timer-stop-hook nil)
        (org-timer-done-hook nil)
        (my-pomodoro-presentation-mode nil)
        (timer-event-last nil)
        (timer-event-last-1 nil)
        (timer-event-last-2 nil)
        notifications sounds)
    (cl-letf (((symbol-function 'org-show-notification)
               (lambda (message) (push message notifications)))
              ((symbol-function 'org-clock-play-sound)
               (lambda (sound) (push sound sounds))))
      (unwind-protect
          (with-temp-buffer
            (rename-buffer "Presentation countdown test" t)
            (org-timer-set-timer 60)
            (my-pomodoro-presentation-mode 1)
            (org-notify "Unrelated Org alert" 'other-sound)
            (should (equal notifications '("Unrelated Org alert")))
            (should (equal sounds '(other-sound)))
            (setq notifications nil sounds nil)
            (timer-event-handler org-timer-countdown-timer)
            (should-not notifications)
            (should-not sounds)
            (should-not org-timer-start-time)
            (should-not org-timer-countdown-timer)
            (my-pomodoro-presentation-mode -1)
            (org-timer-set-timer 60)
            (let ((expected (concat org-timer-countdown-timer-title ": time out")))
              (timer-event-handler org-timer-countdown-timer)
              (should (equal notifications (list expected)))))
        (when org-timer-start-time
          (org-timer-stop))
        (my-pomodoro-presentation-mode -1)))))

(ert-deftest my-pomodoro-finish-preserves-break-on-side-effect-error ()
  "Tracking and notification failures must not leave the task clocked in."
  (dolist (failure '(tracking notification))
    (let ((org-clock-marker (make-marker))
          (org-clock-hd-marker (make-marker))
          (org-clock-history nil)
          (org-clock-current-task nil)
          (org-clock-start-time nil)
          (org-clock-in-hook nil)
          (org-clock-out-hook nil)
          (org-clock-in-resume nil)
          (org-clock-persist nil)
          (org-clock-out-remove-zero-time-clocks t)
          (my-pomodoro-presentation-mode nil)
          (my-pomodoro-break-reminder-timer nil))
      (unwind-protect
          (with-temp-buffer
            (org-mode)
            (insert "* Work\n")
            (goto-char (point-min))
            (org-clock-in)
            (cl-letf (((symbol-function 'my-pomodoro-increment-today-count)
                       (lambda ()
                         (when (eq failure 'tracking)
                           (signal 'file-error '("Tracking file unavailable")))))
                      ((symbol-function 'popup-notification)
                       (lambda (&rest _)
                         (signal 'file-error '("Notification unavailable")))))
              (should-error (my-pomodoro--finish) :type 'file-error))
            (should-not (org-clocking-p))
            (should (memq my-pomodoro-break-reminder-timer timer-list)))
        (my-pomodoro--cancel-break-reminder)
        (when (org-clocking-p)
          (org-clock-out))))))

(defun my-org-compute-timestamp-difference (later-timestamp earlier-timestamp)
  "Computes the number of seconds difference in string timestamps as a float."
  (-
   (float-time (apply #'encode-time (org-parse-time-string later-timestamp)))
   (float-time (apply #'encode-time (org-parse-time-string earlier-timestamp)))))

(defun my-org-float-time-diff-to-hours-minutes (diff)
  "Returns a float time difference in hh:mm format."
  (let* ((hours (floor (/ diff 3600)))
     (diff_minus_hours (- diff (* 3600 hours)))
     (minutes (floor (/ diff_minus_hours 60))))
    (car (split-string (format "%2d:%02d" hours minutes)))))



(defun my-org-clock-merge ()
  "Merge current CLOCK line with the next when their timestamps touch within 10 min."
  (interactive)
  (let* ((start (line-beginning-position))
         (ts1 (my-org-get-clock-segment-timestamps
               (buffer-substring start (line-end-position))))
         (ts2 (and ts1
                   (save-excursion
                     (forward-line)
                     (my-org-get-clock-segment-timestamps
                      (buffer-substring (line-beginning-position)
                                        (line-end-position)))))))
    (when (and ts2
               (< (my-org-compute-timestamp-difference (car ts1) (cadr ts2)) 600))
      (forward-line)
      (delete-region start (line-end-position))
      (org-cycle)
      (insert (format "CLOCK: [%s]--[%s]" (car ts2) (cadr ts1)))
      (org-ctrl-c-ctrl-c))))
(add-hook 'org-clock-out-hook #'my-org-clock-merge)



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

(defun current-line-empty-p()
  (string-match-p "\\`\\s-*$" (thing-at-point 'line)))

(defconst my-pomodoro-stats-format " Summary: %d meetings, %d pomodoros"
  "Format string for daily pomodoro/meeting stats appended to the date headline.")

(defconst my-pomodoro-stats-regexp " Summary: \\([0-9]+\\) meetings, \\([0-9]+\\) pomodoros"
  "Regexp matching the stats string produced by `my-pomodoro-stats-format'.")

(defun my-pomodoro-tracking-file ()
  (expand-file-name (format-time-string "tracking%Y.org") org-directory))

(defun my-pomodoro-today-regexp ()
  (regexp-quote (format-time-string "[%Y-%m-%d %a]")))

(defun my-pomodoro--update-stats (meetings-delta pomodoros-delta)
  "Increment meetings and/or pomodoros count at current line.
MEETINGS-DELTA and POMODOROS-DELTA are integers added to the current counts."
  (if (re-search-forward my-pomodoro-stats-regexp (line-end-position) t)
      (let ((meetings  (+ (string-to-number (match-string 1)) meetings-delta))
            (pomodoros (+ (string-to-number (match-string 2)) pomodoros-delta)))
        (replace-match (format my-pomodoro-stats-format meetings pomodoros)))
    (end-of-line)
    (insert (format my-pomodoro-stats-format meetings-delta pomodoros-delta))))

(defun my-pomodoro-update-count ()
  "Increment the pomodoro count at current line."
  (my-pomodoro--update-stats 0 1))

(defun my-meeting-update-count ()
  "Increment the meeting count at current line."
  (my-pomodoro--update-stats 1 0))

(defun my-pomodoro-increment-today-count ()
  "Find today's headline in tracking file and increment the pomodoro count."
  (interactive)
  (with-current-buffer (find-file-noselect (my-pomodoro-tracking-file))
    (save-excursion
      (goto-char (point-min))
      (when (re-search-forward (my-pomodoro-today-regexp) nil t)
        (my-pomodoro-update-count)))
    (save-buffer)))

(defun my-meeting-increment-today-count ()
  "Find today's headline in tracking file and increment the meeting count."
  (interactive)
  (with-current-buffer (find-file-noselect (my-pomodoro-tracking-file))
    (save-excursion
      (goto-char (point-min))
      (when (re-search-forward (my-pomodoro-today-regexp) nil t)
        (my-meeting-update-count)))
    (save-buffer)))

(defun start-today()
  (interactive)
  (unless (current-line-empty-p)
	  (move-beginning-of-line 2))
  (insert "*** \n")
  (forward-char -1)
  (insert (format-time-string "[%Y-%m-%d %a]"))
  (insert (format my-pomodoro-stats-format 0 0))
  (move-beginning-of-line 2)
  (insert "**** Meetings, Planning and Email processing\n")
  (org-clock-in)
  (move-beginning-of-line 1)
  (org-insert-heading " ")
  ;;(insert "\n")
  (forward-char -1)
)


(use-package org-roam
  :after org
  :ensure t
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (setq org-roam-index-file "org-roam-note-index.org")
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:16}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  (setq org-roam-capture-templates
      '(
	("r" "career: reserach,internet,development" plain "%?"
	 :target (file+head "career/${slug}-%<%Y%m%d%H%M%S>.org"
			    "#+title: ${title}")
	 :unnarrowed t)
	("f" "family/life" plain "%?"
	 :target (file+head "family/${slug}-%<%Y%m%d%H%M%S>.org"
			    "#+title: ${title}")
	 :unnarrowed t)
	("o" "Other/general knowledges" plain "%?"
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

(defun useful()
  (interactive)
  (org-roam-capture))

(defun delete-existed-file(filename)
  (when (file-exists-p filename) (delete-file filename)))

;; Credentials read from ~/.authinfo(.gpg):
;;   machine domi.teracloud.jp login USER password TOKEN
(defconst webdav-host "domi.teracloud.jp")
(defconst webdav-path (concat "https://" webdav-host "/dav/gtd/"))

(defun webdav--curl (label &rest args)
  "Run curl with ARGS, reporting LABEL in the echo area.
Credentials read from ~/.authinfo (netrc format)."
  (message "%s..." label)
  (with-temp-buffer
    (let ((status (apply #'call-process "curl" nil t nil
                         "--fail" "--silent" "--show-error"
                         "--netrc-file" (expand-file-name "~/.authinfo")
                         args)))
      (unless (eq status 0)
        (error "%s...failed (curl %s): %s" label status (buffer-string)))))
  (message "%s...done" label))

(defconst server-file-name "mgtd.org")

(defun download-webdav-file (local-file)
  "Download `server-file-name' from WebDAV to LOCAL-FILE."
  (interactive "FLocal file: ")
  (webdav--curl (format "Downloading %s" server-file-name)
                "--output" local-file (concat webdav-path server-file-name)))

(defun upload-webdav-file (local-file)
  "Upload LOCAL-FILE to the WebDAV directory."
  (interactive "fLocal file: ")
  (webdav--curl (format "Uploading %s" (file-name-nondirectory local-file))
                "--upload-file" local-file webdav-path))

(defun mobile-gtd-tmp-file()
  (file-truename (concat emacs-tmp-dir server-file-name)))

(defun mobile-gtd-read()
  (interactive)
  (setq tmp-file (mobile-gtd-tmp-file))
  (delete-existed-file tmp-file)
  (download-webdav-file tmp-file)
  (if (file-exists-p tmp-file)
      (find-file tmp-file)
    (message "Warning: tmp file %s does not exist, download may have failed" tmp-file)))

(defun mobile-gtd-push()
  (interactive)
  (setq tmp-file (mobile-gtd-tmp-file))
  (upload-webdav-file tmp-file))


;; (use-package javelin
;;   :ensure t
;;   :config
;;   (global-javelin-minor-mode 1))

(provide 'init-authoring)
