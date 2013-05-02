My emacs configuration
====================================================
Most of the file organization was inspired by 
https://github.com/purcell/emacs.d/


Steps
------------

1. Clone the repo
2. git submodule update --init
3. Update the packages
   3.1 Update auto-complete
       * cd .emacs.d/packages/autocomplete
       * git submodule update --init
       * cp lib/popup/popup.el ./    # I have to do this to remove a popup error
       * make byte-compile
 
   3.2 Update the rinari
       * cd .emacs.d/packages/rinari
       * git submodule update --init



