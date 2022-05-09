; #+DATE: [2022-05-07 Sat 17:37]
 (setq org-publish-project-alist
      '(("thackl.github.io" ;; my blog project (just a name)
         ;; Path to org files.
         :base-directory "d:/Users/Singho/projects/omps.github.io/_org"
         :base-extension "org"
         ;; Path to Jekyll Posts
         :publishing-directory "d:/Users/Singho/projects/omps.github.io/_posts"
         :recursive t
         :publishing-function org-html-publish-to-html
         :headline-levels 4
         :html-extension "html"
         :body-only t
	 )))

;; (setq org2blog/wp-blog-alist
;;       '(
;;         ("omps.in"
;;          :url "https://www.omps.in/xmlrpc.php"
;;          :username "omps"
;;          :password "XLgk1erqa@fDAfe^bBT)eIFg")
;;         ("aoplus.in"
;;          :url "https://example2.com/xmlrpc.php"
;;          :username "username"
;;          :password "password")
;; 	))


;; weblogger settings
(require 'weblogger)
(require 'xml-rpc)
;; (setq load-path (cons "~/.emacs.d/metaweblog/" load-path))
(require 'metaweblog)

;; (setq load-path (cons "~/.emacs.d/org2blog/" load-path))
(require 'org2blog-autoloads)
(setq org2blog/wp-blog-alist
       '(("wordpress"
          :url "http://omps.in/xmlrpc.php"
          :username "org2blog"
          :default-title "Hello World"
          :default-categories ("emacs")
          :tags-as-categories blog-from-emacs)
         ("my-blog"
          :url "http://singhom/~omps/wordpress/xmlrpc.php"
          :username "admin")))
