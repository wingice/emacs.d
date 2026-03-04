;; Since mp3 files whith Chinese characters will cause troubles on Windows, so switch to VLC media player
;; EMMS core
;; (use-package emms
;;   :init (require 'emms-setup)
;;   :config
;;   (emms-standard)
;;   (emms-default-players))

;; ;; EMMS player that launches mpv via command line (no IPC)
;; (use-package emms-player-mpv-cli
;;   :ensure nil
;;   :no-require t
;;   :after emms
;;   :init
;;   (defvar my-mpv-command "mpv"
;;     "Command or full path to mpv.exe. Set to absolute path if not on PATH, e.g., \"C:/Program Files/mpv/mpv.exe\".")
;;   :config
;;   (require 'emms)
;;   (require 'emms-player-simple)

;;   (defvar my-emms-mpv-proc nil
;;     "Process handle for the mpv instance started by the EMMS CLI player.")

;;   (defun emms-player-mpv-cli-playable-p (track)
;;     "Play files and URLs using plain mpv."
;;     (memq (emms-track-type track) '(file url)))

;;   (defun emms-player-mpv-cli-start (track)
;;     "Start mpv for TRACK without IPC."
;;     (let* ((name (emms-track-get track 'name))
;;            (args (list my-mpv-command
;;                        "--no-config"
;;                        "--quiet" "--really-quiet"
;;                        "--no-video"
;;                        "--save-position-on-quit"
;;                        name)))
;;       (when (process-live-p my-emms-mpv-proc)
;;         (delete-process my-emms-mpv-proc)
;;         (setq my-emms-mpv-proc nil))
;;       (setq my-emms-mpv-proc
;;             (make-process
;;              :name "emms-mpv-cli"
;;              :buffer "*emms-mpv-cli*"
;;              :command args
;;              :noquery t
;;              :stderr (get-buffer-create "*emms-mpv-cli*")
;;              :sentinel (lambda (proc event)
;;                          ;; When mpv exits, tell EMMS to advance/stop.
;;                          (when (and (not (process-live-p proc))
;;                                     (buffer-live-p (get-buffer "*emms-mpv-cli*")))
;;                            (emms-player-stopped)))))
;;       ;; Mark started so EMMS knows playback began.
;;       (emms-player-started emms-player-mpv-cli)))

;;   (defun emms-player-mpv-cli-stop ()
;;     "Stop the current mpv process."
;;     (when (process-live-p my-emms-mpv-proc)
;;       (delete-process my-emms-mpv-proc)
;;       (setq my-emms-mpv-proc nil))
;;     (emms-player-stopped))

;;   ;; Define the EMMS player object
;;   (defvar emms-player-mpv-cli
;;     (emms-player
;;      #'emms-player-mpv-cli-start
;;      #'emms-player-mpv-cli-stop
;;      #'emms-player-mpv-cli-playable-p))

;;   ;; Match standard audio formats (same helper EMMS uses)
;;   (emms-player-set emms-player-mpv-cli 'regex
;;                    (apply #'emms-player-simple-regexp emms-player-base-format-list))

;;   ;; Register: prefer this CLI player and remove the IPC one if present
;;   (add-to-list 'emms-player-list emms-player-mpv-cli)
;;   (setq emms-player-list (delq (and (boundp 'emms-player-mpv) emms-player-mpv)
;;                                emms-player-list)))

;; ;; Provide feature so other configs can (require 'emms-player-mpv-cli)
;; (provide 'emms-player-mpv-cli)


(provide 'init-media)
