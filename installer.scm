;; Useful for creating a bootable installation image on a laptop with proprietary wifi.
;; Generate a bootable image (e.g. for USB sticks, etc.) with:
;; $ guix system image -t iso9660 installer.scm

(define-module (nongnu system install)
  #:use-module (gnu)
  #:use-module (gnu services)
  #:use-module (gnu system)
  #:use-module (gnu system install)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages mtools)
  #:use-module (gnu packages package-management)
  #:use-module (nongnu packages linux)
  #:export (installation-os-nonfree))

(define installation-os-nonfree
  (operating-system
   (inherit installation-os)
   (kernel linux)
   (firmware (list linux-firmware))
   
   ;; Add the 'net.ifnames' argument to prevent network interfaces
   ;; from having really long names.  This can cause an issue with
   ;; wpa_supplicant when you try to connect to a wifi network.
   (kernel-arguments '("quiet" "modprobe.blacklist=radeon" "net.ifnames=0"))

   (services
    (cons*
     ;; Include the channel file so that it can be used during installation.
     (simple-service 'channel-file etc-service-type
                     (list `("channels.scm" ,(local-file "channels.scm"))))
     (operating-system-user-services installation-os)))

   ;; Add some extra packages to ease the installation process.
   (packages
    (append
     (list git curl stow vim emacs-no-x-toolkit)
     (operating-system-packages installation-os)))))

installation-os-nonfree
