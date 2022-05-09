; -*- mode: lisp -*-
;; based on http://doc.norang.ca/org-mode.html

(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
(require 'org)
;; dropbox and mobileorg specific configuration
;; set the location of org files on the local system.
(setq org-directory "c:/Users/singho/Dropbox/org/todo")
;; name of the file where new notes will be stored.
(setq org-mobile-inbox-for-pull "c:/Users/singho/Dropbox/org/flaggednotepad.org")
;; Dropbox root directory
(setq org-mobile-directory "C:/Users/singho/Dropbox/Apps/MobileOrg") ;; Disable for office use. Dropbox not available.
;; org-mobile-push will copy your org files to the dropbox area.
;; org-mobile-pull to integrate the changes done on your mobile device.

;; org-agenda files
(setq org-agenda-files '("C:/Users/singho/Dropbox/org/todo"))

;; org mode global TODO keywords.
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
	      (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
	      ("NEXT" :foreground "blue" :weight bold)
	      ("DONE" :foreground "forest green" :weight bold)
	      ("WAITING" :foreground "orange" :weight bold)
	      ("HOLD" :foreground "magenta" :weight bold)
	      ("CANCELLED" :foreground "forest green" :weight bold)
	      ("PHONE" :foreground "forest green" :weight bold)
	      ("MEETING" :foreground "forest green" :weight bold))))

;; if the tasks has subtasks with TODO keywords then the task is a project. one subtask of the project should have a NEXT keyword, else the project would be in stuck state.

(setq org-use-fast-todo-selection t) ;; changing tasks state is done with C-c C-t KEY
;; allows changing todo state with Shift-left and Shift-right skipping all the normal processing when entering or leaving a todo state. This cycles through the todo-states but skips setting timestamps and entering notes which is convinent when fixing the status of an entry.
(setq org-treat-S-cursor-todo-selection-as-state-change nil)

;; TODO state triggers (adding and removing tags automatically).
(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
	      ("WAITING" ("WAITING" . t))
	      ("HOLD" ("WAITING") ("HOLD" . t))
	      (done ("WAITING")("HOLD"))
	      ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
	      ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
	      ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

;; Capture templates
(setq org-default-notes-file "C:/Users/singho/Dropbox/org/todo/refile.org")

;; C-c c to capture
;; capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file "C:/Users/singho/Dropbox/org/todo/refile.org")
                   "* TODO %? \n%U\n%a\n" :clock-in t :clock-resume t)
	      ("r" "respond" entry (file "C:/Users/singho/Dropbox/org/todo/refile.org")
                   "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
	      ("n" "note" entry (file "C:/Users/singho/Dropbox/org/todo/refile.org")
                   "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
	      ("j" "Journal" entry (file+datetree "C:/Users/singho/Dropbox/org/journal/diary.org")
                   "* %? \n%U\n" :clock-in t :clock-resume t)
	      ("w" "org-protocol" entry (file "C:/Users/singho/Dropbox/org/todo/refile.org")
                   "* TODO Review %c\n%U\n" :immediate-finish t)
	      ("m" "Meeting" entry (file "C:/Users/singho/Dropbox/org/todo/refile.org")
                   "* MEETING WITH %? :MEETING:\n%U" :clock-in t :clock-resume t)
	      ("p" "Phone Call" entry (file "C:/Users/singho/Dropbox/org/todo/refile.org")
                   "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
	      ("h" "Habit" entry (file "C:/Users/singho/Dropbox/org/todo/refile.org")
                   "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

;; Remove empty drawers where the clock in and clock-out is set to zero
(defun omps/remove-empty-drawer-on-clock-out ()
  (interactive)
  (save-excursion
    (beginning-of-line 0)
    (org-remove-empty-drawer-at "LOGBOOK" (point))))

(add-hook 'org-clock-out-hook 'omps/remove-empty-drawer-on-clock-out 'append)

;; Refiling tasks
;; Targets include this file and any file contributing to the agenfa - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
				 (org-agenda-files :maxlevel . 9))))

;; use full outline paths for refile targets - file using IDO
(setq org-refile-use-outline-path t)

;; targets complete directly with IDO
(setq org-outline-path-complete-in-steps nil)

; Allow refile to create parent task with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

; Use IDO for both buffer and file completion and ido-everywhere to t
(setq org-completion-use-ido t)
;; further configuration is added to ido.el

; use current window for indirect buffer display
(setq org-indirect-buffer-dispay 'current-window)

; exclude done tasks from refile targets.
(defun omps/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets."
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'omps/verify-refile-target) ; to refile task to my todo.org file under Finances heading, Just put the cursor on the task hit C-c C-w and enter nor C-SPC sys RET and its done. IDO completion is awesome.

;; Do not dim blocked tasks
(setq org-agenda-dim-blocked-tasks nil)

;; Compact the block agenda view
(setq org-agenda-compact-blocks t)

;; custom agenda command definitions
(setq org-agenda-custom-commands
      (quote (("N" "Notes" tag "NOTE"
	       ((org-agenda-overriding-header "Notes")
		(org-tags-match-list-sublevels t)))
	      ("h" "Habits" tags-todo "STYLE=\"habit\""
	       ((org-agenda-overriding-header "Habits")
		(org-agenda-sorting-strategy
		 '(todo-state-down effort-up category-keep))))
	      (" " "Agenda"
	       ((agenda "" nil)
		(tags "REFILE"
		      ((org-agenda-overriding-header "Tasks to Refile")
		       (org-tags-match-list-sublevels nil)))
		(tags-todo "-CANCELLED/!"
			   ((org-agenda-overriding-header "Stuck Projects")
			    (org-agenda-skip-function 'omps/skip-non-stuck-projects)
			    (org-agenda-sorting-strategy
			     '(category-keep))))
		(tags-todo "-HOLD-CANCELLED/!"
			   ((org-agenda-overriding-header "Projects")
			    (org-agenda-skip-function 'omps/skip-non-projects)
			    (org-tags-match-list-sublevels 'indented)
			    (org-agenda-sorting-strategy
			     '(category-keep))))
		(tags-todo "-CANCELLED/!NEXT"
			   ((org-agenda-overiding-header (concat "Project Next Tasks"
								 (if omps/hide-scheduled-and-waiting-next-tasks
								     ""
								   " (including WAITING and SCHEDULED tasks)")))
			    (org-agenda-skip-function 'omps/skip-project-and-habits-and-single-tasks)
			    (org-tags-match-list-sublevels t)
			    (org-agenda-todo-ignore-scheduled omps/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-deadlines omps/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-with-date omps/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-sorting-strategy
			     '(todo-state-down effort-up category-keep))))
		(tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
			   ((org-agenda-overriding-header (concat "Project Subtasks"
								  (if omps/hide-scheduled-and-waiting-next-tasks
								      ""
								    " (including WAITING and SCHEDULED tasks)")))
			    (org-agenda-skip-function 'omps/skip-non-project-tasks)
			    (org-agenda-todo-ignore-scheduled omps/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-deadlines omps/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-with-date omps/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-sorting-strategy
			     '(category-keep))))
		(tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
			   ((org-agenda-overriding-header (concat "Standalone Tasks"
								  (if omps/hide-scheduled-and-waiting-next-tasks
								      ""
								    " (including WAITING and SCHEDULED tasks)")))
			    (org-agenda-skip-function 'omps/skip-project-tasks)
			    (org-agenda-todo-ignore-scheduled omps/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-deadlines omps/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-with-date omps/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-sorting-strategy
			     '(category-keep))))
		(tags-todo "-CANCELLED+WAITING|HOLD/!"
			   ((org-agenda-overriding-header (concat "Waiting and Postpones Tasks"
								  (if omps/hide-scheduled-and-waiting-next-tasks
								      ""
								    " (including WAITING and SCHEDULED tasks)")))
			    (org-agenda-skip-function 'omps/skip-non-tasks)
			    (org-tags-match-list-sublevels nil)
			    (org-agenda-todo-ignore-scheduled omps/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-deadlines omps/hide-scheduled-and-waiting-next-tasks)))
		(tags "-REFILE/"
		      ((org-agenda-overriding-header "Tasks to Archive")
		       (org-agenda-skip-function 'omps/skip-non-archivable-tasks)
		       (org-tags-match-list-sublevels nil))))
	       nil))))


;; custome filters
(defun omps/org-auto-exclude-function (tag)
  "Automatic task exclusion in the agenda with / RET"
  (and (cond
	((string=tag "hold")
	 t)
	((string= tag "farm")
	 t))
       (concat "-" tag)))

(setq org-agenda-auto-exclude-function 'omps/org-auto-exclude-function)

; Time clocking
; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)
; show lots of clocking history, makes easier to pick items off.
(setq org-clock-history-length 23)
; Resume clocking task on clock in if the clock is open
(setq org-clock-in-resume t)
; change task to next when clocking in
(setq org-clock-in-switch-to-state 'omps/clock-in-to-next)
; seperate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
; save clock data and state changes and notes in the LOGBOOK drawer 
(setq org-clock-into-drawer t)
;; remove tasks which are getting clocked quickly i.e. tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
; clock out when moving tasks to done state
(setq org-clock-out-when-done t)
; save the running clock and all clock history when exiting Emacs, load it back on startup.
(setq org-clock-persist t)
; do not prompt to resume an active clock
(setq org-clock-persist-query-resume nil)
; enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
; Include current clicking task in clock reports
(setq org-clock-report-include-clocking-task t)

(setq omps/keep-clock-running nil)

(defun omps/clock-in-to-next (kw)
  "Switch task from TODO to NEXT when clocking in.
Skips capture tasks, projects, and subprojects.
Switch projects and subprojects from NEXT back to TODO"
  (when (not (and (boundp 'org-capture-mode) org-capture-mode))
    (cond
     ((and (member (org-get-todo-state) (list "TODO"))
	   (omps/is-task-p))
      "NEXT")
     ((and (member (org-get-todo-state) (list "NEXT"))
	   (omps/is-project-p))
      "TODO"))))

(defun omps/find-project-task ()
  "Move point to the parent (project) task if any"
  (save-restriction
    (widen)
    (let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
      (while (org-up-heading-safe)
	(when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
	  (setq parent-task (point))))
      (goto-char parent-task)
      parent-task)))

(defun omps/punch-in (arg)
  "Start continuos clocking and set the default task to the selected task. if no task is selected set the organization task as the default task."
  (interative "p")
  (setq omps/keep-clock-running t)
  (if (equal major-mode 'org-agenda-mode)
      ;;
      ;; Agenda
      (let* ((marker (org-get-at-bol 'org-hd-marker))
	     (tags (org-with-point-at marker (org-get-tags-at))))
	(if (and (eq arg 4) tags)
	    (org-agenda-clock-in '(16))
	  (omps/clock-in-organization-task-as-default)))
    ;; we are no longer in agenda
    (save-restriction
      (widen)
      ; Find the tags for the current task
      (if (and (equal major-mode 'org-mode) (not (org-before-first-heading-p)) (eq arg 4))
	  (org-clock-in '(16))
	(omps/clock-in-organization-task-as-default)))))

(defun omps/punch-out ()
  (interactive)
  (setq omps/keep-clock-running nil)
  (when (org-clock-is-active)
    (org-clock-out))
  (org-agenda-remove-restriction-lock))

(defun omps/clock-in-default-task ()
  (save-excursion
    (org-with-point-at org-clock-default-task
      (org-clock-in))))

(defun omps/clock-in-parent-task ()
  (save-excursion
    (org-with-point-at org-clock-default-task
      (org-clock-in))))

(defun omps/clock-in-parent-task ()
  "Move point to the parent (project) task if any and clock in"
  (let ((parent-task))
    (save-excursion
      (save-restriction
      (widen)
      (while (and (not parent-task) (org-up-heading-safe))
	(when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
	  (setq parent-task (point))))
      (if parent-task
	  (org-with-point-at parent-task
	    (org-clock-in))
	(when omps/keep-clock-running
	  (omps/clock-in-default-task)))))))

;; ; defvar omps/organization-task-id " ; may skip this part.

(defun omps/clock-out-maybe ()
  (when (and omps/keep-clock-running
	     (not org-clock-clocking-in)
	     (marker-buffer org-clock-default-task)
	     (not org-clock-resolving-clocks-due-to-idleness))
    (omps/clock-in-parent-task)))

(add-hook 'org-clock-out-hook 'omps/clock-out-maybe 'append)

(require 'org-id)
(defun omps/clock-in-task-by-id (id)
  "Clock in a task by id"
  (org-with-point-at (org-id-find id 'marker)
    (org-clock-in nil)))

(defun omps/clock-in-last-task (arg)
  "Clock in the interrupted task if there is one
Skip the default task and get the next one.
A prefix arg forces clock in of the default task."
  (interactive "p")
  (let ((clock-in-to-task
         (cond
          ((eq arg 4) org-clock-default-task)
          ((and (org-clock-is-active)
                (equal org-clock-default-task (cadr org-clock-history)))
           (caddr org-clock-history))
          ((org-clock-is-active) (cadr org-clock-history))
          ((equal org-clock-default-task (car org-clock-history)) (cadr org-clock-history))
          (t (car org-clock-history)))))
    (widen)
    (org-with-point-at clock-in-to-task
      (org-clock-in nil))))

; use discrete minutes and no rounding increments.
(setq org-time-stamp-rounding-minutes (quote (1 1)))

; shows one minute clocking gap
(setq org-agenda-clock-consistency-checks
      (quote (:max-duration "4:00"
			    :min-duration 0
			    :max-gap 0
			    :gap-ok-around ("4:00"))))

; tag setup.
(setq org-tag-alist (quote ((:startgroup)
			    ("@errand" . ?e)
			    ("@office" . ?o)
			    ("@home" . ?H)
			    (:endgroup)
			    ("WAITING" . ?w)
			    ("HOLD" . ?h)
			    ("PERSONAL" . ?P)
			    ("WORK" . ?W)
			    ("EMACS" . ?E)
			    ("ORG" . ?O)
			    ("OMPS" . ?B)
			    ("NOTE" . ?n)
			    ("CANCELLED" . ?c)
			    ("FLAGGED" . ??))))


; Allow setting single tags without the menu
(setq org-fast-tag-selection-single-key (quote expert))

; For tag searches ignore tasks with scheduled and deadline dates
(setq org-agenda-tags-todo-honor-ignore-options t)

;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)

;; Agenda clock report parameters
(setq org-agenda-clockreport-parameter-plist
      (quote (:link t :maxlevel 5 :fileskip0 t :compact t :narrow 80)))
; Set default column view headings: Task Effort Clock_Summary
(setq org-columns-default-format "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")

; global Effort estimate values
; global STYLE property values for completion
(setq org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")
                                    ("STYLE_ALL" . "habit"))))
;; Agenda log mode items to display (closed and state changes by default)
(setq org-agenda-log-mode-items (quote (closed state)))

;; Handelling notes

;; Phone Call setup
;; Set up bbdb
(require 'bbdb)
(bbdb-initialize 'message)
(bbdb-insinuate-message)
(add-hook 'message-setup-hook 'bbdb-insinuate-mail)
;; set up calendar
(require 'calfw)
(require 'calfw-ical)
;; Set this to the URL of your calendar. Google users will use
;; the Secret Address in iCalendar Format from the calendar settings
(cfw:open-ical-calendar "https://calendar.google.com/calendar/ical/aoplus.academy%40gmail.com/private-0cfaf8666af5b5b8381310ae57d45b07/basic.ics")
;; Set up notmuch
(require 'notmuch)
;; set up mail sending using sendmail
(setq send-mail-function (quote sendmail-send-it))
(setq user-mail-address "aoplus.academy@gmail.com"
      user-full-name "Om Prakash Singh")

;; (require 'bbdb)
;; (require 'bbdb-com)
;; ;; Keybindings for phone calls in the keybindings.el
;; ; Phone capture template handleing with BBDB loopup.
;; ; Adapted from code by Gregory J. Grubbs
;; (defun omps/phone-call ()
;;   "Return name and company info for caller from the bbdb lookup"
;;   (interactive)
;;   (let * (name rec caller)
;;        (setq name (completing-read "Who is calling? "
;; 				   (bbdb-hashtable)
;; 				   'bbdb-complication-predicate
;; 				   'confirm))
;;        (when (> (length name) 0)
;; 	 ; something was supplied - look it up in bbdb
;; 	 (setq rec
;; 	       (or (first
;; 		    (or (bbdb-search (bbdb-records) name nil nil)
;; 			(bbdb-search (bbdb-records) nil name nil))))
;; 	       name))))

;; ; build the bbdb link if we have a bbdb record, otherwise just retirn the name
;; (setq caller (cond ((and rec (vector rec))
;; 		    (let ((name (bbdb-record-name rec))
;; 			  (company (bbdb-record-company rec)))
;; 		      (concat "[[bbdb:"
;; 			      name "]["
;; 			      name "]["
;; 			      (when company
;; 				(concat " - " company)))))
;; 		   (rec)
;; 		   (t "NameOfCaller")))
;; (insert caller)))

;; GTD
(setq org-agenda-span 'day)

;; finding stuck projects
(setq org-stuck-projects (quote ("" nil nil "")))


(defun omps/is-project-p ()
  "Any task with a todo keyword subtask"
  (save-restriction
    (widen)
    (let ((has-subtask)
          (subtree-end (save-excursion (org-end-of-subtree t)))
          (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
        (forward-line 1)
        (while (and (not has-subtask)
                    (< (point) subtree-end)
                    (re-search-forward "^\*+ " subtree-end t))
          (when (member (org-get-todo-state) org-todo-keywords-1)
            (setq has-subtask t))))
      (and is-a-task has-subtask))))

(defun omps/is-project-subtree-p ()
  "Any task with a todo keyword that is in a project subtree.
Callers of this function already widen the buffer view."
  (let ((task (save-excursion (org-back-to-heading 'invisible-ok)
                              (point))))
    (save-excursion
      (omps/find-project-task)
      (if (equal (point) task)
          nil
        t))))

(defun omps/is-task-p ()
  "Any task with a todo keyword and no subtask"
  (save-restriction
    (widen)
    (let ((has-subtask)
          (subtree-end (save-excursion (org-end-of-subtree t)))
          (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
        (forward-line 1)
        (while (and (not has-subtask)
                    (< (point) subtree-end)
                    (re-search-forward "^\*+ " subtree-end t))
          (when (member (org-get-todo-state) org-todo-keywords-1)
            (setq has-subtask t))))
      (and is-a-task (not has-subtask)))))

(defun omps/is-subproject-p ()
  "Any task which is a subtask of another project"
  (let ((is-subproject)
        (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
    (save-excursion
      (while (and (not is-subproject) (org-up-heading-safe))
        (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
          (setq is-subproject t))))
    (and is-a-task is-subproject)))

(defun omps/list-sublevels-for-projects-indented ()
  "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  This is normally used by skipping functions where this variable is already local to the agenda."
  (if (marker-buffer org-agenda-restrict-begin)
      (setq org-tags-match-list-sublevels 'indented)
    (setq org-tags-match-list-sublevels nil))
  nil)

(defun omps/list-sublevels-for-projects ()
  "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  This is normally used by skipping functions where this variable is already local to the agenda."
  (if (marker-buffer org-agenda-restrict-begin)
      (setq org-tags-match-list-sublevels t)
    (setq org-tags-match-list-sublevels nil))
  nil)

(defvar omps/hide-scheduled-and-waiting-next-tasks t)

(defun omps/toggle-next-task-display ()
  (interactive)
  (setq omps/hide-scheduled-and-waiting-next-tasks (not omps/hide-scheduled-and-waiting-next-tasks))
  (when  (equal major-mode 'org-agenda-mode)
    (org-agenda-redo))
  (message "%s WAITING and SCHEDULED NEXT Tasks" (if omps/hide-scheduled-and-waiting-next-tasks "Hide" "Show")))

(defun omps/skip-stuck-projects ()
  "Skip trees that are not stuck projects"
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (if (omps/is-project-p)
          (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
                 (has-next ))
            (save-excursion
              (forward-line 1)
              (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
                (unless (member "WAITING" (org-get-tags-at))
                  (setq has-next t))))
            (if has-next
                nil
              next-headline)) ; a stuck project, has subtasks but no next task
        nil))))

(defun omps/skip-non-stuck-projects ()
  "Skip trees that are not stuck projects"
  ;; (omps/list-sublevels-for-projects-indented)
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (if (omps/is-project-p)
          (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
                 (has-next ))
            (save-excursion
              (forward-line 1)
              (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
                (unless (member "WAITING" (org-get-tags-at))
                  (setq has-next t))))
            (if has-next
                next-headline
              nil)) ; a stuck project, has subtasks but no next task
        next-headline))))

(defun omps/skip-non-projects ()
  "Skip trees that are not projects"
  ;; (omps/list-sublevels-for-projects-indented)
  (if (save-excursion (omps/skip-non-stuck-projects))
      (save-restriction
        (widen)
        (let ((subtree-end (save-excursion (org-end-of-subtree t))))
          (cond
           ((omps/is-project-p)
            nil)
           ((and (omps/is-project-subtree-p) (not (omps/is-task-p)))
            nil)
           (t
            subtree-end))))
    (save-excursion (org-end-of-subtree t))))

(defun omps/skip-project-trees-and-habits ()
  "Skip trees that are projects"
  (save-restriction
    (widen)
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((omps/is-project-p)
        subtree-end)
       ((org-is-habit-p)
        subtree-end)
       (t
        nil)))))

(defun omps/skip-projects-and-habits-and-single-tasks ()
  "Skip trees that are projects, tasks that are habits, single non-project tasks"
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((org-is-habit-p)
        next-headline)
       ((and omps/hide-scheduled-and-waiting-next-tasks
             (member "WAITING" (org-get-tags-at)))
        next-headline)
       ((omps/is-project-p)
        next-headline)

       ((and (omps/is-task-p) (not (omps/is-project-subtree-p)))
        next-headline)
       (t
        nil)))))

(defun omps/skip-project-tasks-maybe ()
  "Show tasks related to the current restriction.
When restricted to a project, skip project and sub project tasks, habits, NEXT tasks, and loose tasks.
When not restricted, skip project and sub-project tasks, habits, and project related tasks."
  (save-restriction
    (widen)
    (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
           (next-headline (save-excursion (or (outline-next-heading) (point-max))))
           (limit-to-project (marker-buffer org-agenda-restrict-begin)))
      (cond
       ((omps/is-project-p)
        next-headline)
       ((org-is-habit-p)
        subtree-end)
       ((and (not limit-to-project)
             (omps/is-project-subtree-p))
        subtree-end)
       ((and limit-to-project
             (omps/is-project-subtree-p)
             (member (org-get-todo-state) (list "NEXT")))
        subtree-end)
       (t
        nil)))))

(defun omps/skip-project-tasks ()
  "Show non-project tasks.
Skip project and sub-project tasks, habits, and project related tasks."
  (save-restriction
    (widen)
    (let* ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((omps/is-project-p)
        subtree-end)
       ((org-is-habit-p)
        subtree-end)
       ((omps/is-project-subtree-p)
        subtree-end)
       (t
        nil)))))

(defun omps/skip-non-project-tasks ()
  "Show project tasks.
Skip project and sub-project tasks, habits, and loose non-project tasks."
  (save-restriction
    (widen)
    (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
           (next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((omps/is-project-p)
        next-headline)
       ((org-is-habit-p)
        subtree-end)
       ((and (omps/is-project-subtree-p)
             (member (org-get-todo-state) (list "NEXT")))
        subtree-end)
       ((not (omps/is-project-subtree-p))
        subtree-end)
       (t
        nil)))))

(defun omps/skip-projects-and-habits ()
  "Skip trees that are projects and tasks that are habits"
  (save-restriction
    (widen)
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((omps/is-project-p)
        subtree-end)
       ((org-is-habit-p)
        subtree-end)
       (t
        nil)))))

(defun omps/skip-non-subprojects ()
  "Skip trees that are not projects"
  (let ((next-headline (save-excursion (outline-next-heading))))
    (if (omps/is-subproject-p)
        nil
      next-headline)))

;; archive setup
(setq org-archive-mark-done nil)
(setq org-archive-location "%s_archive::* Archived Tasks")

(defun omps/skip-non-archivable-tasks ()
  "Skip trees that are not available for archiving"
  (save-restriction
    (widen)
    ;; Consider only tasks with done todo headings as archivable candidates
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max))))
          (subtree-end (save-excursion (org-end-of-subtree t))))
      (if (member (org-get-todo-state) org-todo-keywords-1)
          (if (member (org-get-todo-state) org-done-keywords)
              (let* ((daynr (string-to-int (format-time-string "%d" (current-time))))
                     (a-month-ago (* 60 60 24 (+ daynr 1)))
                     (last-month (format-time-string "%Y-%m-" (time-subtract (current-time) (seconds-to-time a-month-ago))))
                     (this-month (format-time-string "%Y-%m-" (current-time)))
                     (subtree-is-current (save-excursion
                                           (forward-line 1)
                                           (and (< (point) subtree-end)
                                                (re-search-forward (concat last-month "\\|" this-month) subtree-end t)))))
                (if subtree-is-current
                    subtree-end ; Has a date in this month or last month, skip it
                  nil))  ; available to archive
            (or subtree-end (point-max)))
        next-headline))))

;; ;; org-babel setup need to change the path
;; (setq org-ditaa-jar-path "~/git/org-mode/contrib/scripts/ditaa.jar")
;; (setq org-plantuml-jar-path "~/java/plantuml.jar")

;; (add-hook 'org-babel-after-execute-hook 'omps/display-inline-images 'append)

;; ;; ; Make babel results blocks lowercase
;; (setq org-babel-results-keyword "results")

;; (defun omps/display-inline-images ()
;;   (condition-case nil
;;       (org-display-inline-images)
;;     (error nil)))

;; (org-babel-do-load-languages
;;  (quote org-babel-load-languages)
;;  (quote ((emacs-lisp . t)
;;          (dot . t)
;;          (ditaa . t)
;;          (R . t)
;;          (python . t)
;;          (ruby . t)
;;          (gnuplot . t)
;;          (clojure . t)
;;          (sh . t)
;;          (ledger . t)
;;          (org . t)
;;          (plantuml . t)
;;          (latex . t))))

;; ;; ; Do not prompt to confirm evaluation
;; ;; ; This may be dangerous - make sure you understand the consequences
;; ;; ; of setting this -- see the docstring for details
;; ;; (setq org-confirm-babel-evaluate nil)

;; ;; ; Use fundamental mode when editing plantuml blocks with C-c '
;; (add-to-list 'org-src-lang-modes (quote ("plantuml" . fundamental)))

;; Don't enable this because it breaks access to emacs from my Android phone
(setq org-startup-with-inline-images nil)


;; ;; publishing
;; ; experimenting with docbook exports - not finished
;; (setq org-export-docbook-xsl-fo-proc-command "fop %s %s")
;; (setq org-export-docbook-xslt-proc-command "xsltproc --output %s /usr/share/xml/docbook/stylesheet/nwalsh/fo/docbook.xsl %s")
;; ;
;; ; Inline images in HTML instead of producting links to the image
(setq org-html-inline-images t)
;; ; Do not use sub or superscripts - I currently don't need this functionality in my documents
;; (setq org-export-with-sub-superscripts nil)
;; ; Use org.css from the norang website for export document stylesheets
(setq org-html-head-extra "<link rel=\"stylesheet\" href=\"http://doc.norang.ca/org.css\" type=\"text/css\" />")
;; (setq org-html-head-include-default-style nil)
;; ; Do not generate internal css formatting for HTML exports
;; (setq org-export-htmlize-output-type (quote css))
;; ; Export with LaTeX fragments
;; (setq org-export-with-LaTeX-fragments t)
;; ; Increase default number of headings to export
;; (setq org-export-headline-levels 6)

;; ; List of projects
;; ; norang       - http://www.norang.ca/
;; ; doc          - http://doc.norang.ca/
;; ; org-mode-doc - http://doc.norang.ca/org-mode.html and associated files
;; ; org          - miscellaneous todo lists for publishing
;; (setq org-publish-project-alist
;;       ;
;;       ; http://www.norang.ca/  (norang website)
;;       ; norang-org are the org-files that generate the content
;;       ; norang-extra are images and css files that need to be included
;;       ; norang is the top-level project that gets published
;;       (quote (("norang-org"
;;                :base-directory "~/git/www.norang.ca"
;;                :publishing-directory "/ssh:www-data@www:~/www.norang.ca/htdocs"
;;                :recursive t
;;                :table-of-contents nil
;;                :base-extension "org"
;;                :publishing-function org-html-publish-to-html
;;                :style-include-default nil
;;                :section-numbers nil
;;                :table-of-contents nil
;;                :html-head "<link rel=\"stylesheet\" href=\"norang.css\" type=\"text/css\" />"
;;                :author-info nil
;;                :creator-info nil)
;;               ("norang-extra"
;;                :base-directory "~/git/www.norang.ca/"
;;                :publishing-directory "/ssh:www-data@www:~/www.norang.ca/htdocs"
;;                :base-extension "css\\|pdf\\|png\\|jpg\\|gif"
;;                :publishing-function org-publish-attachment
;;                :recursive t
;;                :author nil)
;;               ("norang"
;;                :components ("norang-org" "norang-extra"))
;;               ;
;;               ; http://doc.norang.ca/  (norang website)
;;               ; doc-org are the org-files that generate the content
;;               ; doc-extra are images and css files that need to be included
;;               ; doc is the top-level project that gets published
;;               ("doc-org"
;;                :base-directory "~/git/doc.norang.ca/"
;;                :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs"
;;                :recursive nil
;;                :section-numbers nil
;;                :table-of-contents nil
;;                :base-extension "org"
;;                :publishing-function (org-html-publish-to-html org-org-publish-to-org)
;;                :style-include-default nil
;;                :html-head "<link rel=\"stylesheet\" href=\"/org.css\" type=\"text/css\" />"
;;                :author-info nil
;;                :creator-info nil)
;;               ("doc-extra"
;;                :base-directory "~/git/doc.norang.ca/"
;;                :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs"
;;                :base-extension "css\\|pdf\\|png\\|jpg\\|gif"
;;                :publishing-function org-publish-attachment
;;                :recursive nil
;;                :author nil)
;;               ("doc"
;;                :components ("doc-org" "doc-extra"))
;;               ("doc-private-org"
;;                :base-directory "~/git/doc.norang.ca/private"
;;                :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs/private"
;;                :recursive nil
;;                :section-numbers nil
;;                :table-of-contents nil
;;                :base-extension "org"
;;                :publishing-function (org-html-publish-to-html org-org-publish-to-org)
;;                :style-include-default nil
;;                :html-head "<link rel=\"stylesheet\" href=\"/org.css\" type=\"text/css\" />"
;;                :auto-sitemap t
;;                :sitemap-filename "index.html"
;;                :sitemap-title "Norang Private Documents"
;;                :sitemap-style "tree"
;;                :author-info nil
;;                :creator-info nil)
;;               ("doc-private-extra"
;;                :base-directory "~/git/doc.norang.ca/private"
;;                :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs/private"
;;                :base-extension "css\\|pdf\\|png\\|jpg\\|gif"
;;                :publishing-function org-publish-attachment
;;                :recursive nil
;;                :author nil)
;;               ("doc-private"
;;                :components ("doc-private-org" "doc-private-extra"))
;;               ;
;;               ; Miscellaneous pages for other websites
;;               ; org are the org-files that generate the content
;;               ("org-org"
;;                :base-directory "~/git/org/"
;;                :publishing-directory "/ssh:www-data@www:~/org"
;;                :recursive t
;;                :section-numbers nil
;;                :table-of-contents nil
;;                :base-extension "org"
;;                :publishing-function org-html-publish-to-html
;;                :style-include-default nil
;;                :html-head "<link rel=\"stylesheet\" href=\"/org.css\" type=\"text/css\" />"
;;                :author-info nil
;;                :creator-info nil)
;;               ;
;;               ; http://doc.norang.ca/  (norang website)
;;               ; org-mode-doc-org this document
;;               ; org-mode-doc-extra are images and css files that need to be included
;;               ; org-mode-doc is the top-level project that gets published
;;               ; This uses the same target directory as the 'doc' project
;;               ("org-mode-doc-org"
;;                :base-directory "~/git/org-mode-doc/"
;;                :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs"
;;                :recursive t
;;                :section-numbers nil
;;                :table-of-contents nil
;;                :base-extension "org"
;;                :publishing-function (org-html-publish-to-html)
;;                :plain-source t
;;                :htmlized-source t
;;                :style-include-default nil
;;                :html-head "<link rel=\"stylesheet\" href=\"/org.css\" type=\"text/css\" />"
;;                :author-info nil
;;                :creator-info nil)
;;               ("org-mode-doc-extra"
;;                :base-directory "~/git/org-mode-doc/"
;;                :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs"
;;                :base-extension "css\\|pdf\\|png\\|jpg\\|gif\\|org"
;;                :publishing-function org-publish-attachment
;;                :recursive t
;;                :author nil)
;;               ("org-mode-doc"
;;                :components ("org-mode-doc-org" "org-mode-doc-extra"))
;;               ;
;;               ; http://doc.norang.ca/  (norang website)
;;               ; org-mode-doc-org this document
;;               ; org-mode-doc-extra are images and css files that need to be included
;;               ; org-mode-doc is the top-level project that gets published
;;               ; This uses the same target directory as the 'doc' project
;;               ("tmp-org"
;;                :base-directory "/tmp/publish/"
;;                :publishing-directory "/ssh:www-data@www:~/www.norang.ca/htdocs/tmp"
;;                :recursive t
;;                :section-numbers nil
;;                :table-of-contents nil
;;                :base-extension "org"
;;                :publishing-function (org-html-publish-to-html org-org-publish-to-org)
;;                :html-head "<link rel=\"stylesheet\" href=\"http://doc.norang.ca/org.css\" type=\"text/css\" />"
;;                :plain-source t
;;                :htmlized-source t
;;                :style-include-default nil
;;                :auto-sitemap t
;;                :sitemap-filename "index.html"
;;                :sitemap-title "Test Publishing Area"
;;                :sitemap-style "tree"
;;                :author-info t
;;                :creator-info t)
;;               ("tmp-extra"
;;                :base-directory "/tmp/publish/"
;;                :publishing-directory "/ssh:www-data@www:~/www.norang.ca/htdocs/tmp"
;;                :base-extension "css\\|pdf\\|png\\|jpg\\|gif"
;;                :publishing-function org-publish-attachment
;;                :recursive t
;;                :author nil)
;;               ("tmp"
;;                :components ("tmp-org" "tmp-extra")))))

;; ; I'm lazy and don't want to remember the name of the project to publish when I modify
;; ; a file that is part of a project.  So this function saves the file, and publishes
;; ; the project that includes this file
;; ;
;; ; It's bound to C-S-F12 so I just edit and hit C-S-F12 when I'm done and move on to the next thing
;; (defun omps/save-then-publish (&optional force)
;;   (interactive "P")
;;   (save-buffer)
;;   (org-save-all-org-buffers)
;;   (let ((org-html-head-extra)
;;         (org-html-validation-link "<a href=\"http://validator.w3.org/check?uri=referer\">Validate XHTML 1.0</a>"))
;;     (org-publish-current-project force)))

;; (global-set-key (kbd "C-s-<f12>") 'omps/save-then-publish)



;; for exporting to latex
(setq org-latex-listings t)

;; export to html without the xml header
(setq org-html-xml-declaration (quote (("html" . "")
                                       ("was-html" . "<?xml version=\"1.0\" encoding=\"%s\"?>")
                                       ("php" . "<?php echo \"<?xml version=\\\"1.0\\\" encoding=\\\"%s\\\" ?>\"; ?>"))))

;; allow binding of variables on export without confirmation
(setq org-export-allow-BIND t)

;; Reminders
; Erase all reminders and rebuilt reminders for today from the agenda
(defun omps/org-agenda-to-appt ()
  (interactive)
  (setq appt-time-msg-list nil)
  (org-agenda-to-appt))

; Rebuild the reminders everytime the agenda is displayed
(add-hook 'org-finalize-agenda-hook 'omps/org-agenda-to-appt 'append)

; This is at the end of my .emacs - so appointments are set up when Emacs starts
(omps/org-agenda-to-appt)

; Activate appointments so we get notifications
(appt-activate t)

; If we leave Emacs running overnight - reset the appointments one minute after midnight
(run-at-time "24:01" nil 'omps/org-agenda-to-appt)

;; abbrev mode
;; Enable abbrev-mode
(add-hook 'org-mode-hook (lambda () (abbrev-mode 1)))

;; Skeletons
;;
;; sblk - Generic block #+begin_FOO .. #+end_FOO
(define-skeleton skel-org-block
  "Insert an org block, querying for type."
  "Type: "
  "#+begin_" str "\n"
  _ - \n
  "#+end_" str "\n")

(define-abbrev org-mode-abbrev-table "sblk" "" 'skel-org-block)

;; splantuml - PlantUML Source block
(define-skeleton skel-org-block-plantuml
  "Insert a org plantuml block, querying for filename."
  "File (no extension): "
  "#+begin_src plantuml :file " str ".png :cache yes\n"
  _ - \n
  "#+end_src\n")

(define-abbrev org-mode-abbrev-table "splantuml" "" 'skel-org-block-plantuml)

(define-skeleton skel-org-block-plantuml-activity
  "Insert a org plantuml block, querying for filename."
  "File (no extension): "
  "#+begin_src plantuml :file " str "-act.png :cache yes :tangle " str "-act.txt\n"
  (omps/plantuml-reset-counters)
  "@startuml\n"
  "skinparam activity {\n"
  "BackgroundColor<<New>> Cyan\n"
  "}\n\n"
  "title " str " - \n"
  "note left: " str "\n"
  "(*) --> \"" str "\"\n"
  "--> (*)\n"
  _ - \n
  "@enduml\n"
  "#+end_src\n")

(defvar omps/plantuml-if-count 0)

(defun omps/plantuml-if () 
  (incf omps/plantuml-if-count)
  (number-to-string omps/plantuml-if-count))

(defvar omps/plantuml-loop-count 0)

(defun omps/plantuml-loop () 
  (incf omps/plantuml-loop-count)
  (number-to-string omps/plantuml-loop-count))

(defun omps/plantuml-reset-counters ()
  (setq omps/plantuml-if-count 0
        omps/plantuml-loop-count 0)
  "")

(define-abbrev org-mode-abbrev-table "sact" "" 'skel-org-block-plantuml-activity)

(define-skeleton skel-org-block-plantuml-activity-if
  "Insert a org plantuml block activity if statement"
  "" 
  "if \"\" then\n"
  "  -> [condition] ==IF" (setq ifn (omps/plantuml-if)) "==\n"
  "  --> ==IF" ifn "M1==\n"
  "  -left-> ==IF" ifn "M2==\n"
  "else\n"
  "end if\n"
  "--> ==IF" ifn "M2==")

(define-abbrev org-mode-abbrev-table "sif" "" 'skel-org-block-plantuml-activity-if)

(define-skeleton skel-org-block-plantuml-activity-for
  "Insert a org plantuml block activity for statement"
  "Loop for each: " 
  "--> ==LOOP" (setq loopn (omps/plantuml-loop)) "==\n"
  "note left: Loop" loopn ": For each " str "\n"
  "--> ==ENDLOOP" loopn "==\n"
  "note left: Loop" loopn ": End for each " str "\n" )

(define-abbrev org-mode-abbrev-table "sfor" "" 'skel-org-block-plantuml-activity-for)

(define-skeleton skel-org-block-plantuml-sequence
  "Insert a org plantuml activity diagram block, querying for filename."
  "File appends (no extension): "
  "#+begin_src plantuml :file " str "-seq.png :cache yes :tangle " str "-seq.txt\n"
  "@startuml\n"
  "title " str " - \n"
  "actor CSR as \"Customer Service Representative\"\n"
  "participant CSMO as \"CSM Online\"\n"
  "participant CSMU as \"CSM Unix\"\n"
  "participant NRIS\n"
  "actor Customer"
  _ - \n
  "@enduml\n"
  "#+end_src\n")

(define-abbrev org-mode-abbrev-table "sseq" "" 'skel-org-block-plantuml-sequence)

;; sdot - Graphviz DOT block
(define-skeleton skel-org-block-dot
  "Insert a org graphviz dot block, querying for filename."
  "File (no extension): "
  "#+begin_src dot :file " str ".png :cache yes :cmdline -Kdot -Tpng\n"
  "graph G {\n"
  _ - \n
  "}\n"
  "#+end_src\n")

(define-abbrev org-mode-abbrev-table "sdot" "" 'skel-org-block-dot)

;; sditaa - Ditaa source block
(define-skeleton skel-org-block-ditaa
  "Insert a org ditaa block, querying for filename."
  "File (no extension): "
  "#+begin_src ditaa :file " str ".png :cache yes\n"
  _ - \n
  "#+end_src\n")

(define-abbrev org-mode-abbrev-table "sditaa" "" 'skel-org-block-ditaa)

;; selisp - Emacs Lisp source block
(define-skeleton skel-org-block-elisp
  "Insert a org emacs-lisp block"
  ""
  "#+begin_src emacs-lisp\n"
  _ - \n
  "#+end_src\n")

(define-abbrev org-mode-abbrev-table "selisp" "" 'skel-org-block-elisp)

;; Focus on current work.
;; Narrowing to the current subtree
(global-set-key (kbd "<f5>") 'omps/org-todo)

(defun omps/org-todo (arg)
  (interactive "p")
  (if (equal arg 4)
      (save-restriction
        (omps/narrow-to-org-subtree)
        (org-show-todo-tree nil))
    (omps/narrow-to-org-subtree)
    (org-show-todo-tree nil)))

(global-set-key (kbd "<S-f5>") 'omps/widen)

(defun omps/widen ()
  (interactive)
  (if (equal major-mode 'org-agenda-mode)
      (progn
        (org-agenda-remove-restriction-lock)
        (when org-agenda-sticky
          (org-agenda-redo)))
    (widen)))

(add-hook 'org-agenda-mode-hook
          '(lambda () (org-defkey org-agenda-mode-map "W" (lambda () (interactive) (setq omps/hide-scheduled-and-waiting-next-tasks t) (omps/widen))))
          'append)

(defun omps/restrict-to-file-or-follow (arg)
  "Set agenda restriction to 'file or with argument invoke follow mode.
I don't use follow mode very often but I restrict to file all the time
so change the default 'F' binding in the agenda to allow both"
  (interactive "p")
  (if (equal arg 4)
      (org-agenda-follow-mode)
    (widen)
    (omps/set-agenda-restriction-lock 4)
    (org-agenda-redo)
    (beginning-of-buffer)))

(add-hook 'org-agenda-mode-hook
          '(lambda () (org-defkey org-agenda-mode-map "F" 'omps/restrict-to-file-or-follow))
          'append)

(defun omps/narrow-to-org-subtree ()
  (widen)
  (org-narrow-to-subtree)
  (save-restriction
    (org-agenda-set-restriction-lock)))

(defun omps/narrow-to-subtree ()
  (interactive)
  (if (equal major-mode 'org-agenda-mode)
      (progn
        (org-with-point-at (org-get-at-bol 'org-hd-marker)
          (omps/narrow-to-org-subtree))
        (when org-agenda-sticky
          (org-agenda-redo)))
    (omps/narrow-to-org-subtree)))

(add-hook 'org-agenda-mode-hook
          '(lambda () (org-defkey org-agenda-mode-map "N" 'omps/narrow-to-subtree))
          'append)

(defun omps/narrow-up-one-org-level ()
  (widen)
  (save-excursion
    (outline-up-heading 1 'invisible-ok)
    (omps/narrow-to-org-subtree)))

(defun omps/get-pom-from-agenda-restriction-or-point ()
  (or (and (marker-position org-agenda-restrict-begin) org-agenda-restrict-begin)
      (org-get-at-bol 'org-hd-marker)
      (and (equal major-mode 'org-mode) (point))
      org-clock-marker))

(defun omps/narrow-up-one-level ()
  (interactive)
  (if (equal major-mode 'org-agenda-mode)
      (progn
        (org-with-point-at (omps/get-pom-from-agenda-restriction-or-point)
          (omps/narrow-up-one-org-level))
        (org-agenda-redo))
    (omps/narrow-up-one-org-level)))

(add-hook 'org-agenda-mode-hook
          '(lambda () (org-defkey org-agenda-mode-map "U" 'omps/narrow-up-one-level))
          'append)

(defun omps/narrow-to-org-project ()
  (widen)
  (save-excursion
    (omps/find-project-task)
    (omps/narrow-to-org-subtree)))

(defun omps/narrow-to-project ()
  (interactive)
  (if (equal major-mode 'org-agenda-mode)
      (progn
        (org-with-point-at (omps/get-pom-from-agenda-restriction-or-point)
          (omps/narrow-to-org-project)
          (save-excursion
            (omps/find-project-task)
            (org-agenda-set-restriction-lock)))
        (org-agenda-redo)
        (beginning-of-buffer))
    (omps/narrow-to-org-project)
    (save-restriction
      (org-agenda-set-restriction-lock))))

(add-hook 'org-agenda-mode-hook
          '(lambda () (org-defkey org-agenda-mode-map "P" 'omps/narrow-to-project))
          'append)

(defvar omps/project-list nil)

(defun omps/view-next-project ()
  (interactive)
  (let (num-project-left current-project)
    (unless (marker-position org-agenda-restrict-begin)
      (goto-char (point-min))
      ; Clear all of the existing markers on the list
      (while omps/project-list
        (set-marker (pop omps/project-list) nil))
      (re-search-forward "Tasks to Refile")
      (forward-visible-line 1))

    ; Build a new project marker list
    (unless omps/project-list
      (while (< (point) (point-max))
        (while (and (< (point) (point-max))
                    (or (not (org-get-at-bol 'org-hd-marker))
                        (org-with-point-at (org-get-at-bol 'org-hd-marker)
                          (or (not (omps/is-project-p))
                              (omps/is-project-subtree-p)))))
          (forward-visible-line 1))
        (when (< (point) (point-max))
          (add-to-list 'omps/project-list (copy-marker (org-get-at-bol 'org-hd-marker)) 'append))
        (forward-visible-line 1)))

    ; Pop off the first marker on the list and display
    (setq current-project (pop omps/project-list))
    (when current-project
      (org-with-point-at current-project
        (setq omps/hide-scheduled-and-waiting-next-tasks nil)
        (omps/narrow-to-project))
      ; Remove the marker
      (setq current-project nil)
      (org-agenda-redo)
      (beginning-of-buffer)
      (setq num-projects-left (length omps/project-list))
      (if (> num-projects-left 0)
          (message "%s projects left to view" num-projects-left)
        (beginning-of-buffer)
        (setq omps/hide-scheduled-and-waiting-next-tasks t)
        (error "All projects viewed.")))))

(add-hook 'org-agenda-mode-hook
          '(lambda () (org-defkey org-agenda-mode-map "V" 'omps/view-next-project))
          'append)


;; force show the next headline
(setq org-show-entry-below (quote ((default))))

;; Limit the agenda to a subtree
(add-hook 'org-agenda-mode-hook
          '(lambda () (org-defkey org-agenda-mode-map "\C-c\C-x<" 'omps/set-agenda-restriction-lock))
          'append)

(defun omps/set-agenda-restriction-lock (arg)
  "Set restriction lock to current task subtree or file if prefix is specified"
  (interactive "p")
  (let* ((pom (omps/get-pom-from-agenda-restriction-or-point))
         (tags (org-with-point-at pom (org-get-tags-at))))
    (let ((restriction-type (if (equal arg 4) 'file 'subtree)))
      (save-restriction
        (cond
         ((and (equal major-mode 'org-agenda-mode) pom)
          (org-with-point-at pom
            (org-agenda-set-restriction-lock restriction-type))
          (org-agenda-redo))
         ((and (equal major-mode 'org-mode) (org-before-first-heading-p))
          (org-agenda-set-restriction-lock 'file))
         (pom
          (org-with-point-at pom
            (org-agenda-set-restriction-lock restriction-type))))))))
;; Limit restriction lock highlighting to the headline only
(setq org-agenda-restriction-lock-highlight-subtree nil)

;; Always hilight the current agenda line
(add-hook 'org-agenda-mode-hook
          '(lambda () (hl-line-mode 1))
          'append)

;; The following custom-set-faces create the highlights
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(org-mode-line-clock ((t (:background "grey75" :foreground "red" :box (:line-width -1 :style released-button)))) t))

;; Keep tasks with dates on the global todo lists
(setq org-agenda-todo-ignore-with-date nil)

;; Keep tasks with deadlines on the global todo lists
(setq org-agenda-todo-ignore-deadlines nil)

;; Keep tasks with scheduled dates on the global todo lists
(setq org-agenda-todo-ignore-scheduled nil)

;; Keep tasks with timestamps on the global todo lists
(setq org-agenda-todo-ignore-timestamp nil)

;; Remove completed deadline tasks from the agenda view
(setq org-agenda-skip-deadline-if-done t)

;; Remove completed scheduled tasks from the agenda view
(setq org-agenda-skip-scheduled-if-done t)

;; Remove completed items from search results
(setq org-agenda-skip-timestamp-if-done t)

(setq org-agenda-include-diary nil)
(setq org-agenda-diary-file "C:/Users/singho/Dropbox/org/journal/diary.org")

(setq org-agenda-insert-diary-extract-time t)

;; Include agenda archive files when searching for things
(setq org-agenda-text-search-extra-files (quote (agenda-archives)))

;; Show all future entries for repeating tasks
(setq org-agenda-repeating-timestamp-show-all t)

;; Show all agenda dates - even if they are empty
(setq org-agenda-show-all-dates t)

;; Sorting order for tasks on the agenda
(setq org-agenda-sorting-strategy
      (quote ((agenda habit-down time-up user-defined-up effort-up category-keep)
              (todo category-up effort-up)
              (tags category-up effort-up)
              (search category-up))))

;; Start the weekly agenda on Monday
(setq org-agenda-start-on-weekday 1)

;; Enable display of the time grid so we can see the marker for the current time
(setq org-agenda-time-grid (quote ((daily today remove-match)
                                   #("----------------" 0 16 (org-heading t))
                                   (0900 1100 1300 1500 1700))))

;; Display tags farther right
(setq org-agenda-tags-column -102)

;;
;; Agenda sorting functions
;;
(setq org-agenda-cmp-user-defined 'omps/agenda-sort)

(defun omps/agenda-sort (a b)
  "Sorting strategy for agenda items.
Late deadlines first, then scheduled, then non-late deadlines"
  (let (result num-a num-b)
    (cond
     ; time specific items are already sorted first by org-agenda-sorting-strategy

     ; non-deadline and non-scheduled items next
     ((omps/agenda-sort-test 'omps/is-not-scheduled-or-deadline a b))

     ; deadlines for today next
     ((omps/agenda-sort-test 'omps/is-due-deadline a b))

     ; late deadlines next
     ((omps/agenda-sort-test-num 'omps/is-late-deadline '> a b))

     ; scheduled items for today next
     ((omps/agenda-sort-test 'omps/is-scheduled-today a b))

     ; late scheduled items next
     ((omps/agenda-sort-test-num 'omps/is-scheduled-late '> a b))

     ; pending deadlines last
     ((omps/agenda-sort-test-num 'omps/is-pending-deadline '< a b))

     ; finally default to unsorted
     (t (setq result nil)))
    result))

;; (defmacro omps/agenda-sort-test (fn a b)
;;   "Test for agenda sort"
;;   `(cond
;;     ; if both match leave them unsorted
;;     ((and (apply ,fn (list ,a))
;;           (apply ,fn (list ,b)))
;;      (setq result nil))
;;     ; if a matches put a first
;;     ((apply ,fn (list ,a))
;;      (setq result -1))
;;     ; otherwise if b matches put b first
;;     ((apply ,fn (list ,b))
;;      (setq result 1))
;;     ; if none match leave them unsorted
;;     (t nil)))

;; (defmacro omps/agenda-sort-test-num (fn compfn a b)
;;   `(cond
;;     ((apply ,fn (list ,a))
;;      (setq num-a (string-to-number (match-string 1 ,a)))
;;      (if (apply ,fn (list ,b))
;;          (progn
;;            (setq num-b (string-to-number (match-string 1 ,b)))
;;            (setq result (if (apply ,compfn (list num-a num-b))
;;                             -1
;;                           1)))
;;        (setq result -1)))
;;     ((apply ,fn (list ,b))
;;      (setq result 1))
;;     (t nil)))

;; (defun omps/is-not-scheduled-or-deadline (date-str)
;;   (and (not (omps/is-deadline date-str))
;;        (not (omps/is-scheduled date-str))))

;; (defun omps/is-due-deadline (date-str)
;;   (string-match "Deadline:" date-str))

;; (defun omps/is-late-deadline (date-str)
;;   (string-match "\\([0-9]*\\) d\. ago:" date-str))

;; (defun omps/is-pending-deadline (date-str)
;;   (string-match "In \\([^-]*\\)d\.:" date-str))

;; (defun omps/is-deadline (date-str)
;;   (or (omps/is-due-deadline date-str)
;;       (omps/is-late-deadline date-str)
;;       (omps/is-pending-deadline date-str)))

;; (defun omps/is-scheduled (date-str)
;;   (or (omps/is-scheduled-today date-str)
;;       (omps/is-scheduled-late date-str)))

;; (defun omps/is-scheduled-today (date-str)
;;   (string-match "Scheduled:" date-str))

;; (defun omps/is-scheduled-late (date-str)
;;   (string-match "Sched\.\\(.*\\)x:" date-str))


;; ;; Use sticky agenda's so they persist
;; (setq org-agenda-sticky t)
;; ;; (require 'org-checklist)

;; ;; handeling blocked tasks
;; (setq org-enforce-todo-dependencies t)

;; ;; org show leading star
;; (setq org-hide-leading-stars nil)

;; ;; org indent mode
;; (setq org-startup-indented t)

;; ;; org handeling blank lines
;; (setq org-cycle-separator-lines 0)

;; (setq org-blank-before-new-entry (quote ((heading)
;;                                          (plain-list-item . auto))))

;; ;; add new task quickly
;; (setq org-insert-heading-respect-content nil)

;; ;; Notes on top
;; (setq org-reverse-note-order nil)

;; ;; search and show results
;; (setq org-show-following-heading t)
;; (setq org-show-hierarchy-above t)
;; (setq org-show-siblings (quote ((default))))

;; ;; editing and special key handling.
;; (setq org-special-ctrl-a/e t)
;; (setq org-special-ctrl-k t)
;; (setq org-yank-adjusted-subtrees t)

;; ;; attachments
;; (setq org-id-method (quote uuidgen))

;; ;; deadlines and agenda visiblity
;; (setq org-deadline-warning-days 30)

;; ;; export to csv
;; (setq org-table-export-default-format "orgtbl-to-csv")

;; ;; Logging
;; (setq org-log-done (quote time))
;; (setq org-log-into-drawer t)
;; (setq org-log-state-notes-insert-after-drawers nil)
;; (setq org-todo-keywords
;;       (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
;;               (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))

;; ;; Limiting time spent on tasks -- need to set it up.
;; ;; (setq org-clock-sound "/usr/local/lib/tngchime.wav")

;; ;; habit tracking

;; ; position the habit graph on the agenda to the right of the default
;; (setq org-habit-graph-column 50)
;; (run-at-time "06:00" 86400 '(lambda () (setq org-habit-show-habits t)))

;; (global-auto-revert-mode t)
;; ;; auto save mode
;; (setq org-crypt-disable-auto-save nil)

(require 'org-crypt)
(org-crypt-use-before-save-magic)
(setq org-tags-exclude-from-inheritance (quote ("crypt")))
;; GPG key to use for encryption
;; Either the Key ID or set to nil to use symmetric encryption.
(setq org-crypt-key nil)

;; Speed commands
(setq org-use-speed-commands t)
(setq org-speed-commands-user (quote (("0" . ignore)
                                      ("1" . ignore)
                                      ("2" . ignore)
                                      ("3" . ignore)
                                      ("4" . ignore)
                                      ("5" . ignore)
                                      ("6" . ignore)
                                      ("7" . ignore)
                                      ("8" . ignore)
                                      ("9" . ignore)

                                      ("a" . ignore)
                                      ("d" . ignore)
                                      ("h" . omps/hide-other)
                                      ("i" progn
                                       (forward-char 1)
                                       (call-interactively 'org-insert-heading-respect-content))
                                      ("k" . org-kill-note-or-show-branches)
                                      ("l" . ignore)
                                      ("m" . ignore)
                                      ("q" . omps/show-org-agenda)
                                      ("r" . ignore)
                                      ("s" . org-save-all-org-buffers)
                                      ("w" . org-refile)
                                      ("x" . ignore)
                                      ("y" . ignore)
                                      ("z" . org-add-note)

                                      ("A" . ignore)
                                      ("B" . ignore)
                                      ("E" . ignore)
                                      ("F" . omps/restrict-to-file-or-follow)
                                      ("G" . ignore)
                                      ("H" . ignore)
                                      ("J" . org-clock-goto)
                                      ("K" . ignore)
                                      ("L" . ignore)
                                      ("M" . ignore)
                                      ("N" . omps/narrow-to-org-subtree)
                                      ("P" . omps/narrow-to-org-project)
                                      ("Q" . ignore)
                                      ("R" . ignore)
                                      ("S" . ignore)
                                      ("T" . omps/org-todo)
                                      ("U" . omps/narrow-up-one-org-level)
                                      ("V" . ignore)
                                      ("W" . omps/widen)
                                      ("X" . ignore)
                                      ("Y" . ignore)
                                      ("Z" . ignore))))

(defun omps/show-org-agenda ()
  (interactive)
  (if org-agenda-sticky
      (switch-to-buffer "*Org Agenda( )*")
    (switch-to-buffer "*Org Agenda*"))
  (delete-other-windows))

;; org-protocol
(require 'org-protocol)

;; Newline before saving the file


(setq require-final-newline nil)


(setq require-final-newline t)

;; insert inactive timestamps and exclude from export
(defvar omps/insert-inactive-timestamp t)

(defun omps/toggle-insert-inactive-timestamp ()
  (interactive)
  (setq omps/insert-inactive-timestamp (not omps/insert-inactive-timestamp))
  (message "Heading timestamps are %s" (if omps/insert-inactive-timestamp "ON" "OFF")))

(defun omps/insert-inactive-timestamp ()
  (interactive)
  (org-insert-time-stamp nil t t nil nil nil))

(defun omps/insert-heading-inactive-timestamp ()
  (save-excursion
    (when omps/insert-inactive-timestamp
      (org-return)
      (org-cycle)
      (omps/insert-inactive-timestamp))))

(add-hook 'org-insert-heading-hook 'omps/insert-heading-inactive-timestamp 'append)

(global-set-key (kbd "<f9> t") 'omps/insert-inactive-timestamp)
(setq org-export-with-timestamps nil)
(setq org-return-follows-link t)
;; highlight clock when running overtime.
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(org-mode-line-clock ((t (:foreground "red" :box (:line-width -1 :style released-button)))) t))

;; Meeting notes
(defun omps/prepare-meeting-notes ()
  "Prepare meeting notes for email
   Take selected region and convert tabs to spaces, mark TODOs with leading >>>, and copy to kill ring for pasting"
  (interactive)
  (let (prefix)
    (save-excursion
      (save-restriction
        (narrow-to-region (region-beginning) (region-end))
        (untabify (point-min) (point-max))
        (goto-char (point-min))
        (while (re-search-forward "^\\( *-\\\) \\(TODO\\|DONE\\): " (point-max) t)
          (replace-match (concat (make-string (length (match-string 1)) ?>) " " (match-string 2) ": ")))
        (goto-char (point-min))
        (kill-ring-save (point-min) (point-max))))))

;; Remove highlights after changes
(setq org-remove-highlights-with-change nil)
(setq org-remove-highlights-with-change t)

;; change lists to bullet
(setq org-list-demote-modify-bullet (quote (("+" . "-")
                                            ("*" . "-")
                                            ("1." . "-")
                                            ("1)" . "-")
                                            ("A)" . "-")
                                            ("B)" . "-")
                                            ("a)" . "-")
                                            ("b)" . "-")
                                            ("A." . "-")
                                            ("B." . "-")
                                            ("a." . "-")
                                            ("b." . "-"))))
;; remove indentation on agenda views
(setq org-tags-match-list-sublevels t)
;; agenda persistent filter
(setq org-agenda-persistent-filter t)
;; Mail links open compose mail
(setq org-link-mailto-program (quote (compose-mail "%a" "%s")))


;; Bookmark handling
;;
(global-set-key (kbd "<C-f6>") '(lambda () (interactive) (bookmark-set "SAVED")))
(global-set-key (kbd "<f6>") '(lambda () (interactive) (bookmark-jump "SAVED")))

;; remove multiple state log changes from agenda
(setq org-agenda-skip-additional-timestamps-same-entry t)

;; Drop old style refrence in tables
(setq org-table-use-standard-references (quote from))

;; use system setting for file and applications


(setq org-file-apps (quote ((auto-mode . emacs)
                            ("\\.mm\\'" . system)
                            ("\\.x?html?\\'" . system)
                            ("\\.pdf\\'" . system))))


;; overwrite current window with agenda
; Overwrite the current window with the agenda
(setq org-agenda-window-setup 'current-window)
;; delete id's when cloning
(setq org-clone-delete-id t)
;; cycle plain lists
(setq org-cycle-include-plain-lists t)
;; showing source block with highlight
(setq org-src-fontify-natively t)
(setq org-structure-template-alist
      (quote (("s" "#+begin_src ?\n\n#+end_src" "<src lang=\"?\">\n\n</src>")
              ("e" "#+begin_example\n?\n#+end_example" "<example>\n?\n</example>")
              ("q" "#+begin_quote\n?\n#+end_quote" "<quote>\n?\n</quote>")
              ("v" "#+begin_verse\n?\n#+end_verse" "<verse>\n?\n</verse>")
              ("c" "#+begin_center\n?\n#+end_center" "<center>\n?\n</center>")
              ("l" "#+begin_latex\n?\n#+end_latex" "<literal style=\"latex\">\n?\n</literal>")
              ("L" "#+latex: " "<literal style=\"latex\">?</literal>")
              ("h" "#+begin_html\n?\n#+end_html" "<literal style=\"html\">\n?\n</literal>")
              ("H" "#+html: " "<literal style=\"html\">?</literal>")
              ("a" "#+begin_ascii\n?\n#+end_ascii")
              ("A" "#+ascii: ")
              ("i" "#+index: ?" "#+index: ?")
              ("I" "#+include %file ?" "<include file=%file markup=\"?\">"))))

;; Next is for TASKS
(defun omps/mark-next-parent-tasks-todo ()
  "Visit each parent task and change NEXT states to TODO"
  (let ((mystate (or (and (fboundp 'org-state)
                          state)
                     (nth 2 (org-heading-components)))))
    (when mystate
      (save-excursion
        (while (org-up-heading-safe)
          (when (member (nth 2 (org-heading-components)) (list "NEXT"))
            (org-todo "TODO")))))))

(add-hook 'org-after-todo-state-change-hook 'omps/mark-next-parent-tasks-todo 'append)
(add-hook 'org-clock-in-hook 'omps/mark-next-parent-tasks-todo 'append)
;; startup in folded view
(setq org-startup-folded t)
;; allow alphabetical lists entry
(setq org-alphabetical-lists t)
;; using org-struct mode for mail
(add-hook 'message-mode-hook 'orgstruct++-mode 'append)
(add-hook 'message-mode-hook 'turn-on-auto-fill 'append)
(add-hook 'message-mode-hook 'bbdb-define-all-aliases 'append)
(add-hook 'message-mode-hook 'orgtbl-mode 'append)
(add-hook 'message-mode-hook 'turn-on-flyspell 'append)
(add-hook 'message-mode-hook
          '(lambda () (setq fill-column 72))
          'append)
;; use flyspell for error correction


;; flyspell mode for spell checking everywhere
(add-hook 'org-mode-hook 'turn-on-flyspell 'append)

;; Disable keys in org-mode
;;    C-c [ 
;;    C-c ]
;;    C-c ;
;;    C-c C-x C-q  cancelling the clock (we never want this)
(add-hook 'org-mode-hook
          '(lambda ()
             ;; Undefine C-c [ and C-c ] since this breaks my
             ;; org-agenda files when directories are include It
             ;; expands the files in the directories individually
             (org-defkey org-mode-map "\C-c[" 'undefined)
             (org-defkey org-mode-map "\C-c]" 'undefined)
             (org-defkey org-mode-map "\C-c;" 'undefined)
             (org-defkey org-mode-map "\C-c\C-x\C-q" 'undefined))
          'append)

(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c M-o") 'omps/mail-subtree))
          'append)

(defun omps/mail-subtree ()
  (interactive)
  (org-mark-subtree)
  (org-mime-subtree))

;; preserving source block indentation
(setq org-src-preserve-indentation nil)
(setq org-edit-src-content-indentation 0)

;; prevent editing invisible text
(setq org-catch-invisible-edits 'error)

;; use utf-8 as default coding
(setq org-export-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(set-charset-priority 'unicode)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))

;; Keep clock duration in hrs
(setq org-time-clocksum-format
      '(:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))

;; create uniqe ids for tasks while linking
(setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)

;; automatic hourly commits this saves all buffers for the commit.
(run-at-time "00:59" 3600 'org-save-all-org-buffers)


;; Todo.txt
(require 'todotxt)
(setq todotxt-file (expand-file-name "~/.todo/todo.txt"))

;; Twitter
(require 'twittering-mode)
(setq twittering-use-master-password t)
(setq twittering-icon-mode t)

;; Python3 for nnreddit
(setq elpy-rpc-python-command "python3")
