My emacs configuration
====================================================
Most of the file organization was inspired by 
https://github.com/purcell/emacs.d/


Steps
------------
1. Clone the repo to .emacs.d
2. Start emacs, M-x package-refresh-contents
3. Close emacs and start it again. it will automatically install required packages.

You are ready to go, enjoy!


Further customization
---------------------
If you want to change, just change the lisp file freely.
If you want to add some local configuration which only applied to local machine, you can add
a local-conf-body.el in lisp sub folder. It will be automatically loaded. You can set
working-directory, agenda-file location etc on this file.
