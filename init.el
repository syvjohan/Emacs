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

;;Alignment
(global-set-key (kbd "C-c r")
  'alignmnet)

;;indent
(global-set-key (kbd "<backtab>")
  'indent-for-tab-command)

;-----------------------------Emacs pluggins-----------------------------
(require 'cc-mode)
(require 'ido)
(require 'compile)
(load-library "view")


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
    (message "%s %s" "File does not exist: " filepath)))
  
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
  "Set font style"
  (interactive)
  (let ((backgroundColor "gray15"))              
    (global-hl-line-mode 1)
    (set-face-background 'hl-line "gray20")
    (set-face-attribute 'region nil :background "dim grey")
    (set-background-color backgroundColor)
    (set-foreground-color "PeachPuff3")
    (add-to-list 'default-frame-alist '(font . "Courier New-13.0"))
    (set-face-attribute 'default t :font "Courier New-13.0") 
    (set-face-attribute 'modeline-buffer-id nil :foreground "dark orange")
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
    (set-face-attribute 'font-lock-negation-char-face nil :foreground "pink1")


    (defface font-lock-operator-bracket-face
      '((((class color) (background light))
	 :background backgroundColor ))
      "Basic face for highlighting bracket operator {} [] ()"
      :group 'basic-faces)

    (defface font-lock-operator-arithmetic-face
      '((((class color) (background light))
	 :background backgroundColor))
      "Basic face for highlighting arithmetic operators + - / * % "
      :group 'basic-faces)

    (defface font-lock-operator-relational-face
      '((((class color) (background light))
	 :background backgroundColor))
      "Basic face for highlighting relational operators != ==  < > <= >= "
      :group 'basic-faces)

    (defface font-lock-operator-bitwise-face
      '((((class color) (background light))
	 :background backgroundColor))
      "Basic face for highlighting bitwise operators & | ^ ~ << >>"
      :group 'basic-faces)

    (defface font-lock-operator-logical-face
      '((((class color) (background light))
	 :background backgroundColor))
      "Basic face for highlighting logical operators && || !"
      :group 'basic-faces)

    (defface font-lock-operator-assignment-face
      '((((class color) (min-colors 88) (background light))
	 :background backgroundColor))
      "Basic face for highlighting assignment operators = += -= *= /= &= <<= >>= ^= |= "
      :group 'basic-faces)

    (defface font-lock-operator-misc-face
      '((((class color) (background light))
	 :background backgroundColor))
      "Basic face for highlighting sizeof() ? :  sizeof"
      :group 'basic-faces)

    (defface font-lock-operator-others-face
      '((((class color) (background light))
	 :background backgroundColor))
      "Basic face for highlighting double font/backslash // \ . , -> "
      :group 'basic-faces)

    (defface font-lock-print-keywords-face
      '((((class color)(background light))
	 :background backgroundColor))
      "Basic face for highlighting print keywords."
      :group 'basic-faces)

    (defface font-lock-char-face
      '((((class color)(background light))
	 :background backgroundColor))
      "Basic face for highlighting '."
      :group 'basic-faces)

    (defface font-lock-semicolon-face
      '((((class color)(background light))
	 :background backgroundColor))
      "Basic face for highlighting semicolon"
      :group 'basic-faces)
    
    (defface font-lock-loop-keywords-face
      '((((class color)(background light))
	 :background backgroundColor))
      "Basic face for highlighting loop keywords"
      :group 'basic-faces)
    
    (defface font-lock-if-keyword-face
      '((((class color)(background light))
	 :background backgroundColor))
      "Basic face for highlighting if keyword"
      :group 'basic-faces)    

     (defface font-lock-const-keyword-face
      '((((class color)(background light))
	 :background backgroundColor))
      "Basic face for highlighting const keyword"
      :group 'basic-faces)  
    
    (set-face-foreground 'font-lock-operator-bracket-face "darkseagreen4")
    (set-face-foreground 'font-lock-operator-arithmetic-face "cadetblue")
    (set-face-foreground 'font-lock-operator-relational-face "rosybrown3")
    (set-face-foreground 'font-lock-operator-bitwise-face "rosybrown3")
    (set-face-foreground 'font-lock-operator-logical-face "grey")
    (set-face-foreground 'font-lock-operator-assignment-face "DarkOliveGreen")
    (set-face-foreground 'font-lock-operator-misc-face "cyan2")
    (set-face-foreground 'font-lock-operator-others-face "lavenderblush3")
    (set-face-foreground 'font-lock-print-keywords-face "indianred4")
    (set-face-foreground 'font-lock-char-face "yellow")
    (set-face-foreground 'font-lock-semicolon-face "DarkGoldenrod")
    (set-face-foreground 'font-lock-loop-keywords-face "cyan2")
    (set-face-foreground 'font-lock-if-keyword-face "cyan2")
    (set-face-foreground 'font-lock-const-keyword-face "cadetBlue")
    
    ;;Issue for operators <= >= |= to make it work i needed to add
    ;;one whitespace before these 3 operators.
    (font-lock-add-keywords 'c++-mode
			    '(("<<=\\|>>=" 0 'font-lock-operator-assignment-face)
			      (">>\\|<<" 0 'font-lock-operator-bitwise-face) 
			      ("->" 0 'font-lock-operator-others-face) 
			      ("!=\\|==\\|>\\|<\\| >=\\| <=" 0 'font-lock-operator-relational-face) 
			      ("=\\|+=\\|-=\\|*=\\|/=\\|&=\\|\\^=\\|\\ |=" 0 'font-lock-operator-assignment-face)
			      ("&&\\|!\\|||" 0 'font-lock-operator-logical-face) 
			      ("}\\|]\\|)\\|{\\|(\\|\\[" 0 'font-lock-operator-bracket-face)
			      (",\\|\\.\\|//\\|\\\\" 0 'font-lock-operator-others-face) 
			      ("/\\|*\\|%\\|-\\|\\+" 0 'font-lock-operator-arithmetic-face)
			      ("\|\\|&\\|~\\|\\^" 0 'font-lock-operator-bitwise-face) 
			      ("\?\\|:\\|sizeof" 0 'font-lock-operator-misc-face) 
			      ("\\<\\(printf\\|cout\\|endl\\)\\>" 0 'font-lock-print-keywords-face)
			      ("\\<\\(for\\|foreach\\|while\\|do\\)\\>" 0 'font-lock-loop-keywords-face) 
			      ("\\<\\(if\\|else\\)\\>" 0 'font-lock-if-keyword-face) 
			      ("const" 0 'font-lock-const-keyword-face)
			      ("'" 0 'font-lock-char-face) 
			      (";" 0 'font-lock-semicolon-face)))))


(defun split-window-at-start-up ()
  (split-window-horizontally))

(defun maximize-window-at-startup ()
  (add-to-list 'default-frame-alist '(fullscreen . maximized)))

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

;;C++ Style
(defconst my-cpp-style 
  '((c-electric-pound-behavior . nil)
    (c-tab-always-indent . t)
    (c-comment-only-line-offset . 0)
    (c-hanging-braces-alist . ((class-open)
                               (class-close)
                               (defun-open)
                               (defun-close)
                               (inline-open)
                               (inline-close)
                               (brace-list-open)
                               (brace-list-close)
                               (brace-list-intro)
                               (brace-list-entry)
                               (block-open)
                               (block-close)
                               (substatement-open)
                               (statement-case-open)))
    (c-hanging-colons-alist . ((inher-intro)
                               (case-label)
                               (label)
                               (access-label)
                               (access-key)
                               (member-init-intro)))
    (c-cleanup-list . (scope-operator
                       list-close-comma
                       defun-close-semi))
    (c-offsets-alist . ((arglist-close . 0)
                        (label . -4)
                        (access-label . -4)
                        (substatement-open . 0)
                        (statement-case-intro . 4)
                        (case-label . 4)
                        (block-open . 0)
                        (inline-open . 0)
                        (topmost-intro-cont . 0)
                        (knr-argdecl-intro . -4)
                        (brace-list-open . 0)
                        (brace-list-intro . 4)))
    (c-echo-syntactic-information-p . t))
  )

;;C++ Hook
(defun my-cpp-hook ()
  (c-add-style "MyCpp" my-cpp-style t)
  (c-set-style "MyCpp"))

(add-hook 'c-mode-common-hook 'my-cpp-hook)

(defun my-startup-hook ()
  (interactive)
  (my-config))

;;My Config
(defun my-config ())
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

  ;;Fullscreen on startup
  (maximize-window-at-startup)

  ;;Split screen in 2 horizontally frames at start up
  (split-window-at-start-up)

  ;;Changing cursor style
  (set-cursor-style)

  ;;Contains all font settings.
  (set-font-style)

  ;;NOTE, Emacs considers .h files to be C, not C++.
  (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
  )  

;-----------------------------custom-----------------------------
;;Untabify before saving
(add-hook 'write-file-hooks 
          (lambda () (if (not indent-tabs-mode)
                         (untabify (point-min) (point-max)))
            nil ))

(add-hook 'window-setup-hook 'my-startup-hook t)
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
