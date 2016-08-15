;-----------------------------Key-bindings-----------------------------
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
(define-key c-mode-base-map (kbd "C-c m")
  'create-main-file)

;;Create TYPES FILE
(define-key c-mode-base-map (kbd "C-c t")
  'create-types-files)

;;Insert FUNCTION COMMENT
(define-key c-mode-base-map (kbd "C-c f")
  'insert-function-comment)

;;Insert BLOCK COMMENT
(define-key c-mode-base-map (kbd "C-c b")   
  'insert-block-comment)    

;;Create CLASS
(define-key c-mode-base-map (kbd "C-c c")
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


;-----------------------------Functions-----------------------------
(defun alignmnet ()
  "Align on a single equals sign (with a space either side)."
  (interactive)
  (align-regexp
   (region-beginning) (region-end)
   "\\(\\s-*\\) = " 1 0 nil))

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

;; (defun set-c-cpp-style ()
;;   "Set font style in c and cpp mode"
;;   (interactive)

  ;; (defface font-lock-operator-bracket-face
  ;;   '((((class color) (background light))
  ;;      :background backgroundColor ))
  ;;   "Basic face for highlighting bracket operator {} [] ()"
  ;;   :group 'basic-faces)

  ;; (defface font-lock-operator-arithmetic-face
  ;;   '((((class color) (background light))
  ;;      :background backgroundColor))
  ;;   "Basic face for highlighting arithmetic operators + - / * % "
  ;;   :group 'basic-faces)

  ;; (defface font-lock-operator-relational-face
  ;;     '((((class color) (background light))
  ;;        :background backgroundColor))
  ;;     "Basic face for highlighting relational operators != ==  < > <= >= "
  ;;     :group 'basic-faces)

  ;; (defface font-lock-operator-bitwise-face
  ;;   '((((class color) (background light))
  ;;      :background backgroundColor))
  ;;   "Basic face for highlighting bitwise operators & | ^ ~ << >>"
  ;;   :group 'basic-faces)

  ;; (defface font-lock-operator-logical-face
  ;;   '((((class color) (background light))
  ;;      :background backgroundColor))
  ;;   "Basic face for highlighting logical operators && || !"
  ;;   :group 'basic-faces)

  ;; (defface font-lock-operator-assignment-face
  ;;   '((((class color) (min-colors 88) (background light))
  ;;      :background backgroundColor))
  ;;   "Basic face for highlighting assignment operators = += -= *= /= &= <<= >>= ^= |= "
  ;;   :group 'basic-faces)

  ;; (defface font-lock-operator-misc-face
  ;;   '((((class color) (background light))
  ;;      :background backgroundColor))
  ;;   "Basic face for highlighting sizeof() ? :  sizeof"
  ;;   :group 'basic-faces)

  ;; (defface font-lock-operator-others-face
  ;;   '((((class color) (background light))
  ;;      :background backgroundColor))
  ;;   "Basic face for highlighting double font/backslash // \ . , -> "
  ;;   :group 'basic-faces)

  ;; (defface font-lock-print-keywords-face
  ;;   '((((class color)(background light))
  ;;      :background backgroundColor))
  ;;   "Basic face for highlighting print keywords."
  ;;   :group 'basic-faces)

  ;; (defface font-lock-char-face
  ;;   '((((class color)(background light))
  ;;      :background backgroundColor))
  ;;   "Basic face for highlighting '."
  ;;   :group 'basic-faces)

  ;; (defface font-lock-semicolon-face
  ;;   '((((class color)(background light))
  ;;      :background backgroundColor))
  ;;   "Basic face for highlighting semicolon"
  ;;   :group 'basic-faces)
  
  ;; (defface font-lock-loop-keywords-face
  ;;   '((((class color)(background light))
  ;;      :background backgroundColor))
  ;;   "Basic face for highlighting loop keywords"
  ;;   :group 'basic-faces)
  
  ;; (defface font-lock-if-keyword-face
  ;;   '((((class color)(background light))
  ;;      :background backgroundColor))
  ;;   "Basic face for highlighting if keyword"
  ;;   :group 'basic-faces)    

  ;; (defface font-lock-const-keyword-face
  ;;   '((((class color)(background light))
  ;;      :background backgroundColor))
  ;;   "Basic face for highlighting const keyword"
  ;;   :group 'basic-faces)  
  
  ;; (set-face-foreground 'font-lock-operator-bracket-face "darkseagreen4")
  ;; (set-face-foreground 'font-lock-operator-arithmetic-face "cadetblue")
  ;; (set-face-foreground 'font-lock-operator-relational-face "rosybrown3")
  ;; (set-face-foreground 'font-lock-operator-bitwise-face "rosybrown3")
  ;; (set-face-foreground 'font-lock-operator-logical-face "grey")
  ;; (set-face-foreground 'font-lock-operator-assignment-face "DarkOliveGreen")
  ;; (set-face-foreground 'font-lock-operator-misc-face "cyan2")
  ;; (set-face-foreground 'font-lock-operator-others-face "lavenderblush3")
  ;; (set-face-foreground 'font-lock-print-keywords-face "indianred4")
  ;; (set-face-foreground 'font-lock-char-face "yellow")
  ;; (set-face-foreground 'font-lock-semicolon-face "DarkGoldenrod")
  ;; (set-face-foreground 'font-lock-loop-keywords-face "cyan2")
  ;; (set-face-foreground 'font-lock-if-keyword-face "cyan2")
  ;; (set-face-foreground 'font-lock-const-keyword-face "cadetBlue")

  ;; ;;Issue for operators <= >= |= to make it work i needed to add
  ;; ;;one whitespace before these 3 operators.
  ;; (font-lock-add-keywords '(c++-mode c-mode)
  ;;                       '(("<<=\\|>>=" 0 'font-lock-operator-assignment-face)
  ;;                         (">>\\|<<" 0 'font-lock-operator-bitwise-face) 
  ;;                         ("->" 0 'font-lock-operator-others-face) 
  ;;                         ("!=\\|==\\|>\\|<\\| >=\\| <=" 0 'font-lock-operator-relational-face) 
  ;;                         ("=\\|+=\\|-=\\|*=\\|/=\\|&=\\|\\^=\\|\\ |=" 0 'font-lock-operator-assignment-face)
  ;;                         ("&&\\|!\\|||" 0 'font-lock-operator-logical-face) 
  ;;                         ("}\\|]\\|)\\|{\\|(\\|\\[" 0 'font-lock-operator-bracket-face)
  ;;                         (",\\|\\.\\|//\\|\\\\" 0 'font-lock-operator-others-face) 
  ;;                         ("/\\|*\\|%\\|-\\|\\+" 0 'font-lock-operator-arithmetic-face)
  ;;                         ("\|\\|&\\|~\\|\\^" 0 'font-lock-operator-bitwise-face) 
  ;;                         ("\?\\|:\\|sizeof" 0 'font-lock-operator-misc-face) 
  ;;                         ("\\<\\(printf\\|cout\\|endl\\)\\>" 0 'font-lock-print-keywords-face)
  ;;                         ("\\<\\(for\\|foreach\\|while\\|do\\)\\>" 0 'font-lock-loop-keywords-face) 
  ;;                         ("\\<\\(if\\|else\\)\\>" 0 'font-lock-if-keyword-face) 
  ;;                         ("const" 0 'font-lock-const-keyword-face)
  ;;                         ("'" 0 'font-lock-char-face)
  ;;                         ("\\<\\(assert\\|ASSERT\\|DGB_ASSERT\\|DEBUG_ASSERT\\)\\>" 0 'font-lock-assert-keywords-face)
  ;;                         ("\\<\\(malloc\\|MALLOC\\|DGB_MALLOC\\|new\\|NEW\\|DGB_NEW\\|delete\\|DELETE\\|DBG_DELETE\\|free\\|FREE\\|DBG_FREE\\)\\>" 0 'font-lock-allocation-keywords-face)
  ;;                         (";" 0 'font-lock-semicolon-face)
  ;;                         )))

