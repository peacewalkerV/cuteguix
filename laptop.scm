;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu))
(use-modules (gnu packages linux))
(use-modules (nongnu packages linux))
(use-service-modules desktop networking ssh xorg)

(define user-name "scm")

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
   (list (specification->package "emacs-native-comp")
         (specification->package "emacs-exwm")
         (specification->package "emacs-desktop-environment")
         (specification->package "nss-certs"))
   %base-packages))
 (services
  (append
   (list (service mate-desktop-service-type)
         (service openssh-service-type)
         (set-xorg-configuration
          (xorg-configuration
           (keyboard-layout keyboard-layout))
	  sddm-service-type))
   %my-desktop-services))
 (bootloader
  (bootloader-configuration
   (bootloader grub-bootloader)
   (targets (list "/dev/sda"))
   (keyboard-layout keyboard-layout)))
 (swap-devices
  (list (swap-space (target (uuid "beb86695-976a-47bb-b719-bb48e24f3e6b")))))
 (file-systems
  (cons* (file-system
          (mount-point "/boot")
          (device (uuid "E772-1E7B" 'fat32))
          (type "vfat"))
         (file-system
          (mount-point "/")
          (device
           (uuid "484c292b-ef9a-46cf-956d-2d70e006b54c" 'ext4))
          (type "ext4"))
         (file-system
          (mount-point "/home")
          (device
           (uuid "9274e1b2-bc17-4d68-bf49-050978e73384" 'ext4))
          (type "ext4"))
         %base-file-systems)))
