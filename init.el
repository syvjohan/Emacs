;;NOTE Below configuration is only tested in windows!

;;Global variables
(setq backgroundColor "gray15")

;;-----------------------------Emacs pluggins-----------------------------
(require 'cc-mode)
(require 'ido)
(require 'compile)
(load-library "view")

;-----------------------------Include-----------------------------------
(add-hook 'find-file-hook 'my-c-cpp-hook)
(defun my-c-cpp-hook ()
  (when (string= (file-name-extension buffer-file-name) "cpp")
    (load-file "~/.emacs.d/init_c_cpp.el")
    ))


;-----------------------------Key-bindings-----------------------------
;;Open list with emacs commands
(global-set-key (kbd "C-c h")
  'open-list-with-commands)

;;Open init file
(global-set-key (kbd "C-c i")
  'open-init-file)

;;Open cmd
(global-set-key (kbd "<f2>")
  'open-cmd)

;;cmd build
(global-set-key (kbd "<f3>")
  'build-cmd)

;;Comment marked lines
 (global-set-key (kbd "C-c k")
  'smart-comment)

;;Moving to start of line
(global-set-key (kbd "C-a")
  'smarter-move-to-beginning-of-line)

;;indent
(global-set-key (kbd "<backtab>")
  'indent-for-tab-command)

;;save current buffer
(global-set-key (kbd "C-x C-s")
  'save-current-buffer)

(global-set-key (kbd "C-c b")
  'set-c-cpp-style)

;;-----------------------------Style-----------------------------
(defun set-font-style ()
  "Set font style"
  (interactive)             
  (global-hl-line-mode 1)
  (set-face-background 'hl-line "gray20")
  (set-face-attribute 'region nil :background "dim grey")
  (set-background-color backgroundColor)
  (set-foreground-color "PeachPuff3")
  (set-mouse-color "DarkOrange3")
  (add-to-list 'default-frame-alist '(font . "Courier New-13.0"))
  (set-face-attribute 'default nil :font "Courier New-13.0")

  (set-face-attribute 'mode-line-highlight nil :background "dim grey")
  (set-face-attribute 'modeline-buffer-id nil :foreground "DarkOrange3")
  (set-face-attribute 'mode-line nil :background "gray30")
  (set-face-attribute 'mode-line nil :foreground "gray100")
  (set-face-attribute 'mode-line-inactive nil :foreground "gray100")
  (set-face-attribute 'mode-line-inactive nil :background "gray20")
  
  (set-face-attribute 'font-lock-builtin-face nil :foreground "#EBCA9F")
  (set-face-attribute 'font-lock-comment-face nil :italic t :foreground "gray50")
  (set-face-attribute 'font-lock-constant-face nil :foreground "lemon chiffon")
  (set-face-attribute 'font-lock-doc-face nil :foreground "olive drab")
  (set-face-attribute 'font-lock-function-name-face nil :bold t :foreground "DarkSeaGreen4")
  (set-face-attribute 'font-lock-keyword-face nil :foreground "DarkGoldenrod")
  (set-face-attribute 'font-lock-string-face nil :foreground "yellow3")
  (set-face-attribute 'font-lock-type-face nil :foreground "lightgoldenrod3")
  (set-face-attribute 'font-lock-variable-name-face nil :foreground "khaki4")
  (set-face-attribute 'font-lock-warning-face nil :foreground "firebrick")
  (set-face-attribute 'font-lock-negation-char-face nil :foreground "pink1"))

;;-----------------------------Functions-----------------------------
(defun search-word-in-build-file(string searchedKeyWord)
  (let (retValue)
    (with-temp-buffer
      (insert string)
      (goto-char (point-min))
      (setq retValue (re-search-forward searchedKeyWord))
    retValue)))

(defun read-word-from-string (string)
  (let (ch word)
    (setq ch (read-char string))
    (if (string/= ch "#/Space")
      (message "%s" ch))))

(defun replace-word-in-string(string replacementWord searchedWord)
  (let (retString)
    (with-temp-buffer
      (insert string)
      (goto-char (point-min))
      (while (re-search-forward searchedWord nil t)
        (replace-match replacementWord nil t))
      (setq retString (buffer-string)) ;returns all content in buffer as a string
      )
    retString))

;;Capitalize character in string.
;;Ex: player_rec->Player_Rec, player->Player, playerrec->Playerrec
(defun update-to-name-conversion (string)
  (capitalize string))

;;Opens a new window with a guide to emacs commands
(defun open-list-with-commands ()
  "Split screen and Open file containing commands in rigth window"
  (interactive)

  (split-window-right (floor (* 0.40 (window-width))))
  (find-file "commands_list.txt")) 

(defun open-init-file ()
  "Open the init file."
  (interactive)
  (find-file user-init-file))

(defun set-cursor-style ()
  "Set colors"
  (interactive)
  (set-cursor-color "#cc9900"))

(defun split-window-at-start-up ()
  (split-window-horizontally))

(defun open-cmd ()
  "Opens shell inside emacs in a new frame and split window"
  (interactive)
  (split-window-right (floor (* 0.50 (window-width))))
  (shell))

(defun smart-comment ()
  (interactive)
  (if (use-region-p)
      (comment-or-uncomment-region (region-beginning) (region-end))
  (comment-or-uncomment-region (line-beginning-position) (line-end-position))))

(defun smarter-move-to-beginning-of-line (arg)
"Smarter function for moving to the start of a line"
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1)))
  )

(defun start-of-indented-line ()
  (interactive)
  (beginning-of-line)
  (indent-for-tab-command))

(defun save-current-buffer ()
  "Untabify and save the current buffer."
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (untabify (point-min) (point-max))))
  (save-buffer))

;;Bright-red TODOs and bright-green NOTE
(setq fixme-modes '(c++-mode c-mode emacs-lisp-mode))
(make-face 'font-lock-fixme-face)
(make-face 'font-lock-note-face)
(mapc (lambda (mode)
        (font-lock-add-keywords
         mode
         '(("\\<\\(TODO\\)" 1 'font-lock-fixme-face t)
           ("\\<\\(NOTE\\)" 1 'font-lock-note-face t))))
      fixme-modes)
(modify-face 'font-lock-fixme-face "Red" nil nil t nil t nil nil)
(modify-face 'font-lock-note-face "Dark Green" nil nil t nil t nil nil)

(add-hook 'c-mode-common-hook 'my-config)

;;My Config
(defun my-config ()
  ;;Disable welcome screen
  (setq inhibit-startup-message t)
  
  ;;Disable menu-bar
  (menu-bar-mode -1)

  ;;Disable toolbar
  (tool-bar-mode -1)
  
  ;;Disable sound
  (setq visible-bell 1)

  ;;Disable scroll bar
  (scroll-bar-mode -1)
  
  ;word moving command will cursor into between camelCaseWords.
  (global-subword-mode)
  
  ;;Disable line wrapping
  (set-default 'truncate-lines t)
  
  ;; Globally enable ido-mode (auto completion for filenames)
  (ido-mode t)

  ;; Globally enable line numbers
  (global-linum-mode t)

  ;; Globally enable matching ([{}])
  (electric-pair-mode t)

  ;;Change color on matching parantheses when cursor is on the paranthes.
  (setq show-paren-delay 0)
  (show-paren-mode 1)
  
  ;Global tab settings
  (setq tab-width 4
        indent-tabs-mode nil)

  ; Word-based completion always on
  (abbrev-mode t)

  ;Disable line wrapping
  (set-default 'truncate-lines t)

  ;;Set file extensions and their correct modes
  (setq auto-mode-alist
        (append
         '(("\\.cpp$" . c++-mode)
           ("\\.h$" . c++-mode)
           ("\\.inl" . c++-mode)) auto-mode-alist))

  ;;Split screen in 2 horizontally frames at start up
  (split-window-at-start-up)

  ;;Changing cursor style
  (set-cursor-style)

  ;;Contains all font settings.
  (set-font-style)

  ;;NOTE, Emacs considers .h files to be C, not C++.
  (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode)))  

;-----------------------------custom-----------------------------

(add-hook 'window-setup-hook 'toggle-frame-maximized t)
(add-hook 'window-setup-hook 'my-config t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
