This is the customization of my emacs configuration.

Most inspired by https://github.com/purcell/emacs.d/


Step1:
1. Clone the repo
2. git submodule update --init
3. Update the packages
3.1 Update auto-complete
    cd .emacs.d/packages/autocomplete
    git submodule update --init
    cp lib/popup/popup.el ./    # I have to do this to remove a popup error
    make byte-compile
 


