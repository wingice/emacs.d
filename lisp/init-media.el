(use-package emms
  :defer t
  :config
  (emms-default-players)
  (emms-minimalistic)
  (setq emms-source-file-default-directory "c:/workspace/media/Music")
  (defun my/emms-track-description (track)
    "Isolates the filename of TRACK regardless of file type."
    (file-name-nondirectory (cdr (assoc 'name track))))
  (setq emms-track-description-function 'my/emms-track-description)
  (setq emms-player-mpv-debug nil))
(provide 'init-media)
