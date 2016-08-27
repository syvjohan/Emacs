
;;-----------------------------Emacs pluggins-----------------------------
(require 'cc-mode)
(require 'ido)
(require 'compile)
(load-library "view")


;-----------------------------Global variables-----------------------------
(defconst backgroundColor "gray15")

;;Set file extensions and their correct modes
(setq auto-mode-alist
      (append
       '(("\\.cpp$" . c++-mode)
         ("\\.h$" . c++-mode)
         ("\\.inl" . c++-mode)) auto-mode-alist))


;;-----------------------------Includes-----------------------------
(load-file "~/.emacs.d/themes.el")


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

;;insert note, name and date
(global-set-key (kbd "C-c n")
  'insert-note)

;;insert todo, name and date
(global-set-key (kbd "C-c t")
  'insert-todo)

;;Switch between header and source file
(define-key c-mode-base-map (kbd "C-c o")
  'ff-find-other-file)

;;Alignment
(define-key c-mode-base-map (kbd "C-c r")
  'alignmnet)

;;Update CLASS
(define-key c-mode-base-map (kbd "C-c u")
  'update-class )

;;Create STRUCT
(define-key c-mode-base-map (kbd "C-c s")
  'create-struct)

;;Create MAIN FILE
(define-key c-mode-base-map (kbd "C-c C-m")
  'create-main-file)

;;Create TYPES FILE
;;(define-key c-mode-base-map (kbd "C-c C-t")
;;  'create-types-files)

;;Insert FUNCTION COMMENT
(define-key c-mode-base-map (kbd "C-c f")
  'insert-function-comment)

;;Insert BLOCK COMMENT
(define-key c-mode-base-map (kbd "C-c b")   
  'insert-block-comment)    

;;Create CLASS
(define-key c-mode-base-map (kbd "C-c C-c")
  'create-class)

;-----------------------------Prototypes-----------------------------
;;Prototype source
(setq sourceCode "//Include Librarys
#include MyClass.h

//Include Files


//******
//MyClass::MyClass
//******
MyClass::MyClass() {}

//******
//MyClass::~MyClass
//******
MyClass::~MyClass() {}

")

;;Prototype Header
(setq headerCode "#ifndef MYCLASS_H
#define MYCLASS_H

//Include Librarys

//Include Files


//Forward declarations


class MyClass {
public:
  MyClass();
  ~MyClass();

private:

};

#endif //!MYCLASS_H
")

;;Prototype Main
(setq mainCode "//Include Librarys
#include <iostream>

//Include Files


int main(int argc, char **argv) {


system(pause);
return 0;
}
")

;;Prototype Types
(setq typesCode "#ifndef TYPES_H
#define TYPES_H

// Integer types
typedef unsigned char         uint8;
typedef char                  int8;
typedef unsigned short        uint16;
typedef short                 int16;
typedef unsigned int          uint32;
typedef int                   int32;
typedef unsigned long long    uint64;
typedef long long             int64;

// Float types
typedef float                 real32;
typedef double                real64;


#endif // !TYPES_H
")


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

(defun insert-note ()
"insert note, my name and date at cursor position"
(interactive)
(insert "/*NOTE (Johan " (format-time-string "%Y-%m-%d") "):   */")
(backward-char 4))

(defun insert-todo ()
"Insert todo, my name and date at cursor position"
(interactive)
(insert "/*TODO (Johan " (format-time-string "%Y-%m-%d") "):   */")
(backward-char 4))

(defun replace-word ()
  "Query-replace whole words."
  (interactive)
  (let ((current-prefix-arg  t))
    (call-interactively #'query-replace)))

(defun create-main-file (path)
  (interactive "s(Create main.cpp file) Enter path: ")

  (setq path (concat path "/main.cpp"))
  
                                        ;Check if file exist in current directory
  (if (file-exists-p path)
      (message "%s" "Filename already exist, no file where created!")
    (write-region mainCode nil path) ;Write to file.
    (message "main.cpp was succesfully created!")))

(defun create-struct (name)
  (interactive "s(Create struct) Enter name: ")
  (let ((name (update-to-name-conversion name)))
    (insert "typedef struct " name " {\n\n};")
    ))

(defun insert-function-comment (class function)
  (interactive "s(insert function comment) Enter class name:
sEnter function name: ")

  (if (string-equal class "")
      (insert "// ******\n// " function "\n// ******")
    (insert "// ******\n// " class "::" function "\n// ******")))

(defun insert-block-comment ()
  (interactive)
  (insert " /**/ ")
  (backward-char 3) ;decrement cursor position 2 steps.
  (message "Inserted block comment!"))

(defun create-types-file (path)
  (interactive "s(Create Types.h file) Enter path: ")
  
  (setq path (concat path "/Types.h"))

                                        ;Check if file exist in current directory
  (if (file-exists-p path)
      (message "%s" "Filename already exist, no file where created!")
    (write-region typesCode nil path) ;Write to file.
    (message "Types.h was succesfully created!")))

(defun create-class (directory name)
  "Create a new class(source and  header file."
  (interactive "s(Create a new class) Enter path:
sEnter class name: ")
  
  (let (path newSourceCode newHeaderCode pathSource pathHeader)
    (setq directory (concat directory "/"))
    (setq path (concat directory name))
    (setq pathSource (concat path ".cpp"))
    (setq pathHeader (concat path ".h"))

    ;;Replace default class name with user specified class name
    (setq newSourceCode (replace-word-in-string sourceCode name "MyClass"))
    (setq newHeaderCode (replace-word-in-string headerCode name "MyClass"))

    ;;Check if file exist in current directory
    (if (and (file-exists-p pathSource)
             (file-exists-p pathHeader))
        (message "%s" "Filename already exist, no files where created!")
      ;; else no files exist, create the new ones
      (progn
        (with-temp-file pathSource
          (insert newSourceCode))
        (with-temp-file pathHeader
          (insert newHeaderCode))
        (message "Created source file: %s\nCreated header file: %s"
                 pathSource pathHeader)
        ))
    ))

(defun update-class (filepath)
  (interactive "s(Update class) Enter filePath: ")
  (let (pathHeader pathSource)
    (setq pathHeader (concat filepath ".h"))
    (setq pathSource (concat filepath ".cpp"))
    
    (get-functions pathHeader)
    
                                        ;define function(s) in source file.
                                        ;    (if (file-exists-p pathSource)
                                        ;      append-to-file "hello" nil pathSource) ;do update
                                        ;    (message "%s" "File does not exist"))
    )
  )

(defun get-functions (filepath)
  (if (file-exists-p filepath) 
      (with-temp-buffer
        (insert-file-contents filepath)
        (read-word-from-string (buffer-string))
        )
    (message "%s %s" "File does not exist: " filepath)))

;;c:/Programmering/test
(defun build-cmd (projectPath)
  "Send build command to shell"
  (interactive "s(build and compile)Write project path: ")

  ;;Search build.bat file and get data
  (let (batPath fileContent)
    (setq batPath (concat projectPath "c:/Programmering/build.bat"))
    (if (file-exists-p batPath)
        (with-temp-buffer (insert-file-contents batPath)(buffer-string))
      (message "%s" (buffer-string))


      
      (let (vcvarsall cl build architecture outputDirectory targetName compile VS compile and goto dot slash command)
        ;;(setq targetName (search-word-in-build-file fileContent "TARGET_NAME="))
        ;;(message "%s" targetName)
        ;; (setq command nil)
        ;; (setq vcvarsall " vcvarsall ")
        ;; (setq architecture " x64 ")
        ;; (setq cl " cl ")
        ;; (setq build " build ")
        ;; (setq outputDirectory "bin")
        ;; (setq slash "\\")
        ;; (setq dot ".")
        ;; (setq executableExtension "exe")
        ;; (setq targetName (concat "Melodispelet" dot executableExtension))
        ;; (setq VS (concat " devenv " outputDirectory slash targetName))
        ;; (setq compile (concat outputDirectory slash targetName))
        ;; (setq and " && ")
        ;; (setq goto " cd ")
        ;; (setq command (concat command goto projectPath and vcvarsall architecture and cl and build and compile and VS))
        ;;(shell-command command))
        (message "Project does not contain any build.bat file. No action was taken!")))
    ))

(defun find-build-file ()
  (interactive)
  (message "Current Directory: %s" default-directory)
  (if (not(file-exists-p my-build-file))
      (progn (cd "..") (find-build-file))
    (concat default-directory "/" my-build-file)))

(defun build-project ()
  (interactive)
  (switch-to-buffer-other-window "*compilation*")
  (let ((temp-dir default-directory))
    (find-build-file)
    (compile my-build-file)
    (setq default-directory temp-dir)))

(defun alignmnet ()
  "Align on a single equals sign (with a space either side)."
  (interactive)
  (align-regexp
   (region-beginning) (region-end)
   "\\(\\s-*\\) = " 1 0 nil))

(defun start-of-indented-line ()
  (interactive)
  (beginning-of-line)
  (indent-for-tab-command))


;;-----------------------------Startup-----------------------------
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

  ;;Split screen in 2 horizontally frames at start up
  (split-window-at-start-up)

  ;;Changing cursor style
  (set-cursor-style)
  
  ;;Maximize window
  (w32-send-sys-command 61488)

  ;;NOTE, Emacs considers .h files to be C, not C++.
  (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
)


;;-----------------------------Hooks-----------------------------
(add-hook 'window-setup-hook 'my-config)
(add-hook 'c-mode-common-hook 'cpp-style)
