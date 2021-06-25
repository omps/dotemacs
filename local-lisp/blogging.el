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
