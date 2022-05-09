;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;; (package-initialize)


(let ((minver "23.3"))
  (when (version<= emacs-version minver)
    (error "Your Emacs is too old -- this config requires v%s or higher" minver)))
(when (version<= emacs-version "24")
  (message "Your Emacs is old, and some functionality in this config will be disabled. Please upgrade if possible."))
;;
;;(setenv "PATH" (concat (getenv "PATH") ":D:\Program\\ Files\Emacs\Aspell\bin"))
;;(setq exec-path (append exec-path '("D:\Program Files\Emacs\Aspell\bin")))
(setenv "DICPATH"
	(concat (getenv "HOME") "D:\\cygwin64\\usr\\share\\myspell\\"))

(global-flycheck-mode)

(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))
(setq ispell-program-name "D:\\cygwin64\\bin\\hunspell.exe")
;; Custom hotkeys for spell checking in emacs.
(global-unset-key (kbd "M-$"))  ;unbind emacs default key for ispell-word
(global-set-key (kbd "<f7>") 'ispell-word)
(global-set-key (kbd "C-<f7>") 'flyspell-mode)
;;; Specify which dictionary to use at startup (english, ...). Uncomment one of the following lines:
(setq ispell-dictionary "english")
;; (setq-default ispell-program-name "aspell")

;; encryption
(setq epg-gpg-program "D:\\GnuPG\\bin\\gpg.exe")
;; windows/dos GNUPG setup
;; (if (memq system-type '(windows-nt ms-dos))
;;     (custom-set-variables
;;      '(epg-gpg-home-directory "C:\\GnuPG4")
;;      '(epg-gpg-program (concat epg-gpg-home-directory "/bin/gpg.exe"))
;;      '(epg-gpgconf-program  (concat epg-gpg-home-directory "/bin/gpgconf.exe"))))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
;; (require 'init-benchmarking) ;; Measure startup time

(defconst *spell-check-support-enabled* nil) ;; Enable with t if you prefer
(defconst *is-a-mac* (eq system-type 'darwin))

;;----------------------------------------------------------------------------
;; Temporarily reduce garbage collection during startup
;;----------------------------------------------------------------------------
(defconst sanityinc/initial-gc-cons-threshold gc-cons-threshold
  "Initial value of `gc-cons-threshold' at start-up time.")
(setq gc-cons-threshold (* 128 1024 1024))
(add-hook 'after-init-hook
          (lambda () (setq gc-cons-threshold sanityinc/initial-gc-cons-threshold)))

(defun load-directory (dir)
  (let ((load-it (lambda (f)
		   (load-file (concat (file-name-as-directory dir) f)))
		 ))
    (mapc load-it (directory-files dir nil "\\.el$"))))
(load-directory "~/.emacs.d/local-lisp/")
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files nil)
 '(package-selected-packages
   (quote
    (whois emojify elfeed twittering-mode yagist wgrep web-mode undo-tree sos rainbow-mode py-autopep8 puppet-mode ox-tiddly ox-jira org-projectile org-jira nose multiple-cursors material-theme jira-markup-mode jekyll-modes jedi-direx httprepl httpcode http-twiddle http-post-simple http howm howdoi horoscope hl-todo highlight-unique-symbol highlight-thing highlight hierarchy helm-unicode helm-tramp helm-sql-connect helm-pydoc helm-jira helm-hoogle helm-growthforecast helm-grepint helm-google helm-go-package helm-gitlab helm-gitignore helm-github-stars helm-git-grep helm-git helm-directory helm-dictionary helm-describe-modes helm-company helm-chrome google-this google-maps google-contacts google gitlab-ci-mode gitignore-templates github-theme github-stars github-search github-pullrequest github-notifier github-modern-theme github-issues github-elpa github-clone github-browse-file git-link ghub+ gh-md fullframe flymake-python-pyflakes flymake-json flycheck-pyflakes exec-path-from-shell elpygen elpy el-get ein dracula-theme confluence company-web company-ansible color-theme-sanityinc-solarized color-theme-modern color-theme codesearch code-archive browse-at-remote better-defaults))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-mode-line-clock ((t (:background "grey75" :foreground "red" :box (:line-width -1 :style released-button))))))

;; Do not show emacs welcome message
(setq inhibit-startup-screen t)

;; backup files in seperate backup directory
;;(setq backup-directory-alist
;;      '(("." . ,(expand-file-name
;;		 (concat user-emacs-directory "backups")))))

;; make backup of files even when they're in version control
(setq vc-make-backup-files t)

;; enable ido mode for autocompletion.
(ido-mode)

;; enable elpy mode for python development on startup
;;(package-initialize)
(elpy-enable)
(add-hook 'python-mode-hook 'elpy-mode)
(with-eval-after-load 'elpy
  (remove-hook 'elpy-modules 'elpy-module-flymake)
  (add-hook 'elpy-mode-hook 'flycheck-mode)
  (add-hook 'elpy-mode-hook 'elpy-use-ipython "ipython")
  (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save))

;; enable rainbow mode for editing css files.
(add-hook 'css-mode-hook 'my-css-mode-hook)
(defun my-css-mode-hook ()
  (rainbow-mode 1))
(put 'upcase-region 'disabled nil)

(setq epg-gpg-program "/usr/bin/gpg")

;; Adding the function to insert date.
(defun now ()
  "Insert string for the current time formatted like '2:34 PM' or 1507121460"
  (interactive)                 ; permit invocation in minibuffer
  ;;(insert (format-time-string "%D %-I:%M %p")))
  ;;(insert (format-time-string "%02y%02m%02d%02H%02M%02S")))
  (insert (format-time-string "%02y%02m%02d%02H%02M")))

(defun today ()
  "Insert string for today's date nicely formatted in American style,
  e.g. Sunday, September 17, 2000 or standard 17-09-2000."
  (interactive)       ; permit invocation in minibuffer
  ;;(insert (format-time-string "%A, %B %e, %Y")))
  (insert (format-time-string "%d-%m-%y")));

;; (add-to-list 'load-path "~/.emacs.d/vendor/emacs-gitlab")
;;(require 'gitlab)
(eval-after-load "python"
  '(define-key python-mode-map "\C-cx" 'jedi-direx:pop-to-buffer))
(add-hook 'jedi-mode-hook 'jedi-direx:setup)


;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'material t) ;; load material theme
;; (global-linum-mode t) ;; enable line numbers globally

;; PYTHON CONFIGURATION
;; --------------------------------------

(elpy-enable)
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")

;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

(defun duplicate-line ()
  (interactive)
  (save-mark-and-execursion
   (beginning-of-line)
   (insert (think-at-point 'line t))))

(global-set-key (kbd "C-S-d") 'duplicate-line)

(defun move-line-down ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines 1))
    (forward-line)
    (move-to-column col)))

(defun move-line-up ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines -1))
    (forward-line -1)
    (move-to-column col)))

(global-set-key (kbd "C-S-j") 'move-line-down)
(global-set-key (kbd "C-S-k") 'move-line-up)
;; open line above and below.
(defun open-line-below ()
  (interactive)
  (end-of-line)
  (newline)
  (indent-for-tab-command))

(defun open-line-above ()
  (interactive)
  (begienning-of-line)
  (newline)
  (forward-line -1)
  (indent-for-tab-command))

;; come out of multiple cursor mode using C-g
(require 'multiple-cursors)
(global-set-key (kbd "C-|") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-line-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-line-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-line-like-this)
(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click)
(define-key mc/keymap (kbd "<return>") nil)

;; enable company mode.
(add-hook 'after-init-hook 'global-company-mode)

;; fuzzy file search using helm and projectile.
(require 'projectile)
(setq projectile-indexing-method 'alien)
(setq projectile-enable-caching t)
(projectile-global-mode)

(require 'helm)
(require 'helm-config)
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))
(helm-autoresize-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(setq helm-M-x-fuzzy-match t)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(helm-mode 1)

;; Speedbar
(global-set-key (kbd "<f8>") 'speedbar)

;; dumb jump to jump to definitions
;; (dumb-jump-mode)

;; save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

;; searching the web using webjump
(global-set-key (kbd "C-x w") 'webjump)
;; Add urban dictionary to webjump
(eval-after-load "webjump"
  '(add-to-list 'webjump-sites
		'("Urban-Dictionay" . [simple-query "www.urbandictionary.com" "http://www.urbandictionary.com/define.php?term=" ""])
		'("stackoverflow" . "www.stackoverflow.com")))


;; join line
(global-set-key (kbd "M-j")
		(lambda ()
		  (interactive)
		  (join-line -1)))
;; enable undo-tree
 (global-undo-tree-mode)

;; yaml syntax
(defun yaml-mode-syntax-propertize-function (beg end)
  (save-excursion
    (goto-char beg)
    (while (search-forward "#" end t)
      (save-excursion
        (forward-char -1)
        (unless (bolp)
          (forward-char -1)           ;; move to char preceding #
          (when (looking-at "[^ \t]")
            (forward-char 1) ;; move to # again
            (put-text-property (point) (1+ (point))
                               'syntax-table (string-to-syntax "_"))))))))

;; init.el ends here
