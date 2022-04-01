;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu))
(use-service-modules desktop networking ssh xorg)

(define user-name "oh")

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

(operating-system
 (locale "en_US.utf8")
 (timezone "Asia/Shanghai")
 (keyboard-layout
  (keyboard-layout "us,ru" #:options '("ctrl:nocaps")))
 (host-name "scheme")
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
	(list "emacs-native-comp" "emacs-exwm" "emacs-desktop-environment" "nss-certs"))
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
   (bootloader grub-efi-bootloader)
   (targets (list "/boot/efi"))
   (keyboard-layout keyboard-layout)))
 (swap-devices
  (list (swap-space (target (uuid "6f66ccb8-dcbc-456a-8a9e-fac7dbfb20d0")))))
 (file-systems
  (cons* (file-system
          (mount-point "/boot/efi")
          (device (uuid "5C00-F2EB" 'fat32))
          (type "vfat"))
         (file-system
          (mount-point "/")
          (device
           (uuid "13c97113-bc51-4185-bfb9-218c10a298d4" 'ext4))
          (type "ext4"))
         (file-system
          (mount-point "/home")
          (device
           (uuid "081d275f-145d-4b3a-80f7-cb5ba15b1fd4" 'ext4))
          (type "ext4"))
	 (file-system
          (mount-point (string-append "/home/" user-name "/hdd"))
          (device (uuid "d1210c09-8ca7-4665-a690-a21f31e0e0ce" 'ext4))
          (type "ext4")
          (create-mount-point? #t))
         %base-file-systems)))
