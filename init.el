;;Below configuration is for windows!

;;Global variables

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


;-----------------------------lists-----------------------------------
;;list containing types
(setq lst-types '(void bool char int float))


;-----------------------------Key-bindings-----------------------------

;;Create STRUCT
(global-set-key (kbd "C-c s")
  'create-struct)

;;Create MAIN FILE
(global-set-key (kbd "C-c m")
  'create-main-file)

;;Create TYPES FILE
(global-set-key (kbd "C-c t")
  'create-types-files)

;;Insert FUNCTION COMMENT
(global-set-key (kbd "C-c f")
  'insert-function-comment)

;;Insert BLOCK COMMENT
(global-set-key (kbd "C-c b")   
  'insert-block-comment)    

;;Create CLASS
(global-set-key (kbd "C-c c")
  'create-class) 

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

;;Update CLASS
(global-set-key (kbd "C-c u")
  'update-class )

;;Comment marked lines
(global-set-key (kbd "C-c k")
 'smart-comment)

;;Moving to start of line
(global-set-key (kbd "C-a")
  'smarter-move-to-beginning-of-line)

;;Switch between header and source file
(global-set-key (kbd "C-c o")
  'ff-find-other-file)

;;Indentation
(global-set-key (kbd "<tab>")
  'tab-indentation)

;;Alignment
(global-set-key (kbd "C-c r")
  'alignmnet)

;-----------------------------Functions-----------------------------

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
    (message "%s %s" "File does not exist: " filepath))
)
  
(defun read-word-from-string (string)
  (let (ch word)
    (setq ch (read-char string))
    (if (string/= ch "#/Space")
      (message "%s" ch)
    )
  )
)

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

(defun insert-function-comment (class function)
  (interactive "s(insert function comment) Enter class name:
sEnter function name: ")

  (let ((class (update-to-name-conversion class)))
    (let ((function (update-to-name-conversion function)))
      (if (string-equal class "")
          (insert "// ******\n// " function "\n// ******")
      (insert "// ******\n// " class "::" function "\n// ******")
      (message "Inserted function comment!")))))

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

(defun set-font-style ()
  "Set font size"
  (interactive)
  (set-face-attribute 'default nil :height 120)
  (set-face-attribute 'modeline-buffer-id nil :foreground "dark orange"))

(defun split-window-at-start-up ()
  (split-window-horizontally))

(defun open-cmd ()
  "Opens shell inside emacs in a new frame and split window"
  (interactive)
  (split-window-right (floor (* 0.50 (window-width))))
  (shell))

(defun build-cmd (projectPath)
  "Send build command to shell"
  (interactive "s(build and compile)Write project path: ")

  ;;Search build.bat file and get data
  (let (batPath fileContent)
    (setq batPath (concat projectPath "/build.bat"))

    (if (file-exists-p batPath)
      (setq fileContent (with-temp-buffer
                          (insert-file-contents batPath)
                          (buffer-string)))
      (message "hejjo")
      
      (let (vcvarsall cl build architecture outputDirectory targetName compile VS compile and goto dot slash command)
        ;;(setq targetName (search-word-in-build-file fileContent "TARGET_NAME="))
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
    

(defun search-word-in-build-file(string searchedKeyWord)
  (let (retValue)
    (with-temp-buffer
      (insert string)
      (goto-char (point-min))
      (setq retValue (re-search-forward searchedKeyWord))
    retValue)))

(defun smart-comment ()
  (interactive)
  (if (use-region-p)
      (comment-or-uncomment-region (region-beginning) (region-end))
  (comment-or-uncomment-region (line-beginning-position) (line-end-position))))

(defun alignmnet ()
   "Align on a single equals sign (with a space either side)."
  (interactive)
  (align-regexp
   (region-beginning) (region-end)
   "\\(\\s-*\\) = " 1 0 nil))

(defun tab-indentation ()
  "insert 4 whitespaces"
  (interactive)
  (insert "    "))

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

;; Initialize package module.
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; Load plugins here :
(require 'cc-mode)
(require 'ido)

;; My Config
(defun my-config ()
  ;; Globally enable ido-mode (auto completion for filenames)
  (ido-mode t)

  ;; Globally enable line numbers
  (global-linum-mode t)

  ;; Globally enable matching ([{}])
  (electric-pair-mode t)

  ;(load-theme 'zenburn t)

  (split-window-at-start-up)
  (set-cursor-style)
  (set-font-style))

(defun my-startup-hook ()
  (interactive)
  (my-config)
  (set-default 'truncate-lines t))

(add-hook 'window-setup-hook 'my-startup-hook t)

 ;; if indent-tabs-mode is off, untabify before saving
(add-hook 'write-file-hooks 
          (lambda () (if (not indent-tabs-mode)
                         (untabify (point-min) (point-max)))
            nil ))

; NOTE, Emacs considers .h files to be C, not C++.

;-----------------------------Disble functionality-----------------------------

;Disable tab
(setq-default indent-tabs-mode nil)'disable-tab

;;Disable menu-bar
(menu-bar-mode -1)

;;Disable toolbar
(tool-bar-mode -1)

;;Disable sound
(setq visible-bell 1)

;-----------------------------custom-----------------------------

;;Full size window
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (wombat)))
 '(initial-frame-alist (quote ((fullscreen . maximized)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )