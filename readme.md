My emacs configuration
====================================================
Most of the file organization was inspired by 
https://github.com/purcell/emacs.d/


Steps
------------
1. Clone the repo to .emacs.d
2. Start emacs, M-x package-refresh-contents
3. Close emacs and start it again. it will automatically install required packages.
4. After installing, removing, or upgrading packages, run `M-x refresh-package-quickstart` to rebuild the package startup cache.

You are ready to go, enjoy!


Further customization
---------------------
If you want to change, just change the lisp file freely.
If you want to add some local configuration which only applied to local machine, you can add
a local-conf-body.el in lisp sub folder. It will be automatically loaded. You can set
working-directory, agenda-file location etc on this file.


Notes
---------------------
- This config enables `package-quickstart` to speed up startup.
- If you change installed packages, run `M-x refresh-package-quickstart` once so Emacs can rebuild its quickstart cache.
- After changing Emacs major versions, rebuild packages compiled by the old version using `M-x package-recompile-all`, then restart Emacs. In particular, Marginalia compiled for an older Emacs can report `void-function compat--seconds-to-string` in Vertico file completion on Emacs 31. Recompiling Marginalia and refreshing its native cache fixes this without disabling annotations.
- Dired uses Dirvish, enabled globally once at startup. TAB and left-click expand/collapse directories or visit regular files; middle/right-click keep the existing Dired actions.
- On macOS, Dired uses GNU `gls` if installed, otherwise Emacs's `ls-lisp` (BSD `ls` cannot handle `--dired`). Restart Emacs after changing this configuration so existing Dired buffers do not retain the old setup.

Pomodoro workflow
---------------------
- Clocking into an Org task starts the work countdown: 25 minutes by default, or the task's Effort duration when set (existing Org behavior).
- When it finishes, the task clocks out and the daily Pomodoro count increases. On macOS, the existing notification and screen lock remain enabled unless presentation mode is on.
- The completion handler clocks out and schedules break reminders before updating statistics or sending its notification, so errors in those side effects do not prevent the break reminders. Standalone countdowns without an active task do not count as completed Pomodoros or start break reminders.
- After a 5-minute break, a notification titled `Pomodoro break is over` asks you to clock in. It repeats every minute until you clock into any task, which cancels the reminders and starts a fresh work countdown.
- Break reminders use `popup-notification`: on macOS, a native notification with the Glass sound. macOS notification settings and Focus mode can silence alerts. Reminders do not lock the screen or automatically clock in.
- Manually clocking out does not start break reminders. These timers are not persisted across Emacs restarts.
- Before presenting, run `M-x my-pomodoro-presentation-mode`; run it again afterward to restore alerts. The global mode shows `Present` in the mode line and starts disabled in each new Emacs session. It does not detect meetings or screen sharing automatically.
- Presentation mode suppresses completion notifications, repeated break reminders, Org's built-in countdown notification/sound, and automatic countdown-triggered screen locking (including standalone countdowns). Manual `M-x lock-screen` on macOS and unrelated Org notifications still work.
- Presentation mode does not pause countdowns or change clock tracking/statistics: a completed work countdown still clocks out and increments the daily count. After disabling the mode, pending break reminders resume on their next scheduled tick, without replaying suppressed alerts. Clocking in still cancels break reminders while presenting.
- macOS Focus alone does not prevent automatic clock-out or screen locking. Presentation mode affects this Emacs workflow, not notifications from other applications.
- Restart Emacs after changing this configuration; the workflow is installed when Org loads.
