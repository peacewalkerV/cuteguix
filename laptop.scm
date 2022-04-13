;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu))
(use-modules (gnu packages linux))
(use-modules (nongnu packages linux))
(use-service-modules desktop networking ssh xorg)

(define user-name "rx")

;; Modify the default substitute mirrors.
(define %my-desktop-services
  (modify-services
   %desktop-services
   (guix-service-type
    config =>
    (guix-configuration
     (inherit config)
     (substitute-urls
      (list "https://mirrors.sjtug.sjtu.edu.cn/guix"
	    "https://substitutes.nonguix.org"))
     (authorized-keys
      (append (list (plain-file
		     "non-guix.pub"
		     "(public-key
                        (ecc (curve Ed25519)
                             (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))
	      %default-authorized-guix-keys))))))

;; The OS definition itself.
(operating-system
 (locale "en_US.utf8")
 (timezone "Asia/Shanghai")
 (keyboard-layout
  (keyboard-layout
   "us,ru"
   #:options '("ctrl:nocaps" "compose:menu" "grp:alt_shift_toggle" "parens:swap_brackets")
   #:model "thinkpad"))
 (host-name "scheme")
 (kernel linux)
 (firmware (list linux-firmware))
 (kernel-arguments '("quiet" "modprobe.blacklist=radeon" "net.ifnames=0"))
 (users
  (cons* (user-account
          (name user-name)
          (comment user-name)
          (group "users")
          (home-directory
	   (string-append "/home/" user-name))
          (supplementary-groups
	   '("wheel" "disk" "netdev" "audio" "video")))
         %base-user-accounts))
 (packages
  (append
   (map specification->package
	(list "emacs-pgtk-native-comp" "emacs-exwm" "emacs-desktop-environment" "nss-certs"))
   %base-packages))
 (services
  (append
   (list (service gnome-desktop-service-type)
         (service openssh-service-type)
         (set-xorg-configuration
          (xorg-configuration
           (keyboard-layout keyboard-layout))))
   %my-desktop-services))
 (bootloader
  (bootloader-configuration
   (bootloader grub-bootloader)
   (targets (list "/dev/sda"))
   (keyboard-layout keyboard-layout)))
 (swap-devices
  (list (swap-space (target (uuid "e2529f91-7227-4f19-94f1-0ebbaad24cdc")))))
 (file-systems
  (cons* (file-system
          (mount-point "/")
          (device
           (uuid "38209cc6-7934-46bb-a85c-1356e91fad06" 'ext4))
          (type "ext4"))
         (file-system
          (mount-point "/home")
          (device
           (uuid "d9016959-74c9-4eff-8266-246acb1c02f1" 'ext4))
          (type "ext4"))
         %base-file-systems)))
