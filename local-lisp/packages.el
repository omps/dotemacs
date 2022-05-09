(package-initialize)

;; load emacs package repostiroies.
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("elpy" . "https://jorgenschaefer.github.io/packages/")))


(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)

;;(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    ein
    elpy
    flycheck
    material-theme
    py-autopep8
    ;; send email, access contacts and calendar
    bbdb
    bbdb-vcard
    calfw
    calfw-ical
    notmuch
    ;; for social media
    nnreddit
    bitlbee
    todotxt
    twittering-mode
    ;; for writers
    muse
    flyspell
    org
    wc-mode
    writegood-mode
    fountain-mode ;; for script writing
    writeroom-mode ;;removes all the distractions
    ))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

