;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules
  (gnu home)
  (gnu packages)
  (gnu services)
  (guix gexp)
  (gnu home services shells))

(home-environment
  (packages
    (map (compose list specification->package+output)
         (list "mpv"
               "emacs-pdf-tools"
               "autoconf"
               "font-ipa-mj-mincho"
               "stow"
               "krita"
               "ffmpegthumbs"
               "maim"
               "scrot"
               "screenfetch"
               "clojure"
               "sbcl"
               "racket"
               "font-fira-code"
               "unzip"
               "zip"
               "git"
               "libreoffice"
               "firefox"
               "dolphin")))
  (services
    (list (service
            home-bash-service-type
            (home-bash-configuration
              (aliases
                '(("grep" . "grep --color=auto")
                  ("ll" . "ls -l")
                  ("ls" . "ls -p --color=auto")))
              (bashrc
                (list (local-file
                        ".config/guix/home-config/.bashrc"
                        "bashrc")))
              (bash-profile
                (list (local-file
                        ".config/guix/home-config/.bash_profile"
                        "bash_profile"))))))))
