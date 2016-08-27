
;;-----------------------------Common style-----------------------------   
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
(set-face-attribute 'font-lock-doc-face nil :italic t :foreground "olive drab")
(set-face-attribute 'font-lock-function-name-face nil :bold t :foreground "DarkSeaGreen4")
(set-face-attribute 'font-lock-keyword-face nil :foreground "DarkGoldenrod")
(set-face-attribute 'font-lock-string-face nil :foreground "yellow3")
(set-face-attribute 'font-lock-type-face nil :foreground "lightgoldenrod3")
(set-face-attribute 'font-lock-variable-name-face nil :foreground "khaki4")
(set-face-attribute 'font-lock-warning-face nil :foreground "firebrick")
(set-face-attribute 'font-lock-negation-char-face nil :foreground "pink1")


;;-----------------------------Faces-----------------------------       
(defface font-lock-operator-assignment-face
  `((((type graphic) (class color))
     (:background "gray15" :foreground "DarkOliveGreen")))
  "Basic face for highlighting the region."
  :group 'basic-faces)

(defface font-lock-operator-bitwise-face
  `((((type graphic) (class color))
     (:background "gray15" :foreground "DeepSkyBlue")))
  "Basic face for highlighting the region."
  :group 'basic-faces)

(defface font-lock-operator-others-face
  `((((type graphic) (class color))
     (:background "gray15" :foreground "LavenderBlush3")))
  "Basic face for highlighting the region."
  :group 'basic-faces)

(defface font-lock-operator-relational-face
  `((((type graphic) (class color))
     (:background "gray15" :foreground "RosyBrown3")))
  "Basic face for highlighting the region."
  :group 'basic-faces)

(defface font-lock-operator-logical-face
  `((((type graphic) (class color))
     (:background "gray15" :foreground "grey")))
  "Basic face for highlighting the region."
  :group 'basic-faces)

(defface font-lock-operator-bracket-face
  `((((type graphic) (class color))
     (:background "gray15" :foreground "DarkSeaGreen4" :bold t)))
  "Basic face for highlighting the region."
  :group 'basic-faces)

(defface font-lock-operator-arithmetic-face
  `((((type graphic) (class color))
     (:background "gray15" :foreground "CadetBlue")))
  "Basic face for highlighting the region."
  :group 'basic-faces)

(defface font-lock-operator-bitwise-face
  `((((type graphic) (class color))
     (:background "gray15" :foreground "RosyBrown3")))
  "Basic face for highlighting the region."
  :group 'basic-faces)

(defface font-lock-operator-misc-face
  `((((type graphic) (class color))
     (:background "gray15" :foreground "cyan2")))
  "Basic face for highlighting the region."
  :group 'basic-faces)

(defface font-lock-print-keywords-face
  `((((type graphic) (class color))
     (:background "gray15" :foreground "IndianRed4" :bold t)))
  "Basic face for highlighting the region."
  :group 'basic-faces)

(defface font-lock-loop-keywords-face
  `((((type graphic) (class color))
     (:background "gray15" :foreground "cyan2")))
  "Basic face for highlighting the region."
  :group 'basic-faces)

(defface font-lock-if-keywords-face
  `((((type graphic) (class color))
     (:background "gray15" :foreground "cyan2")))
  "Basic face for highlighting the region."
  :group 'basic-faces)

(defface font-lock-const-keywords-face
  `((((type graphic) (class color))
     (:background "gray15" :foreground "CadetBlue")))
  "Basic face for highlighting the region."
  :group 'basic-faces)

(defface font-lock-operator-char-face
  `((((type graphic) (class color))
     (:background "gray15" :foreground "yellow")))
  "Basic face for highlighting the region."
  :group 'basic-faces)

(defface font-lock-assert-keywords-face
  `((((type graphic) (class color))
     (:background "gray15" :foreground "IndianRed4" :bold t)))
  "Basic face for highlighting the region."
  :group 'basic-faces)

(defface font-lock-allocation-keywords-face
  `((((type graphic) (class color))
     (:background "gray15" :foreground "DeepSkyBlue4" :bold t)))
  "Basic face for highlighting the region."
  :group 'basic-faces)

(defface font-lock-semicolon-face
  `((((type graphic) (class color))
     (:background "gray15" :foreground "DarkGoldenrod4")))
  "Basic face for highlighting the region."
  :group 'basic-faces)

(defface font-lock-var-keywords-face
  `((((type graphic) (class color))
     (:background "gray15" :foreground "CadetBlue")))
  "Basic face for highlighting the region."
  :group 'basic-faces)

(defface font-lock-include-keywords-face
  `((((type graphic) (class color))
     (:background "gray15" :foreground "seashell1")))
  "Basic face for highlighting the region."
  :group 'basic-faces)

(defface font-lock-macro-keywords-face
  `((((type graphic) (class color))
     (:background "gray15" :foreground "DarkViolet" :bold t)))
  "Basic face for highlighting the region."
  :group 'basic-faces)


;;-----------------------------Add emacs keywords-----------------------------   
;;Issue for operators <= >= |= to make it work i needed to add
;;one whitespace before these 3 operators.
(font-lock-add-keywords 'emacs-lisp-mode
                        '(("!=\\|==\\|>\\|<\\| >=\\| <=" 0 'font-lock-operator-relational-face) 
                          ("\\<\\(load-file\\|load-library\\)\\>" 0 'font-lock-include-keywords-face)
                          ("=\\|+=\\|-=\\|*=\\|/=\\|&=\\|\\^=\\|\\ |=" 0 'font-lock-operator-assignment-face)
                          ("&&\\|!\\|||" 0 'font-lock-operator-logical-face) 
                          ("}\\|]\\|)\\|{\\|(\\|\\[" 0 'font-lock-operator-bracket-face)
                          (",\\|\\.\\|//\\|\\\\" 0 'font-lock-operator-others-face) 
                          ("/\\|*\\|%\\|-\\|\\+" 0 'font-lock-operator-arithmetic-face)
                          ("\|\\|&\\|~\\|\\^" 0 'font-lock-operator-bitwise-face) 
                          ("\\<\\(message\\)\\>" 0 'font-lock-print-keywords-face)
                          ("\\<\\(for\\|foreach\\|while\\|do\\)\\>" 0 'font-lock-loop-keywords-face) 
                          ("\\<\\(if\\|when\\)\\>" 0 'font-lock-if-keywords-face) 
                          ("\\<\\(and\\)\\>" 0 'font-lock-operator-logical-face)
                          ("\\<\\(let\\|setq\\|defvar\\)\\>" 0 'font-lock-var-keywords-face)                          
                          ("'" 0 'font-lock-operator-char-face)))

;;-----------------------------Add c keywords-----------------------------   
;;Issue for operators <= >= |= to make it work i needed to add
;;one whitespace before these 3 operators.
(font-lock-add-keywords 'c-mode
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
                          ("\\<\\(if\\|else\\)\\>" 0 'font-lock-if-keywords-face) 
                          ("\\<\\(const\\)\\>" 0 'font-lock-const-keywords-face)
                          ("'" 0 'font-lock-operator-char-face)
                          ("\\<\\(assert\\|ASSERT\\|DGB_ASSERT\\|DEBUG_ASSERT\\)\\>" 0 'font-lock-assert-keywords-face)
                          ("\\<\\(malloc\\|MALLOC\\|DGB_MALLOC\\|free\\|FREE\\|DBG_FREE\\)\\>" 0 'font-lock-allocation-keywords-face)
                          ;;("\\<\\(include\\|define\\|undef\\|ifndef\\|ifdef\\|else\\|elif\\|endif\\|error\\|pragma\\|if\\)\\>" 0 'font-lock-macro-keywords-face)  
                          (";" 0 'font-lock-semicolon-face)))

;;-----------------------------Add c++ keywords-----------------------------   
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
                          ("\\<\\(if\\|else\\)\\>" 0 'font-lock-if-keywords-face) 
                          ("\\<\\(const\\)\\>" 0 'font-lock-const-keywords-face)
                          ("'" 0 'font-lock-operator-char-face)
                          ("\\<\\(assert\\|ASSERT\\|DGB_ASSERT\\|DEBUG_ASSERT\\)\\>" 0 'font-lock-assert-keywords-face)
                          ("\\<\\(malloc\\|MALLOC\\|DGB_MALLOC\\|new\\|NEW\\|DGB_NEW\\|delete\\|DELETE\\|DBG_DELETE\\|free\\|FREE\\|DBG_FREE\\)\\>" 0 'font-lock-allocation-keywords-face)
                          ;;("#" 0 'font-lock-macro-keywords-face) ;;Testing
                          ;;("include\\>" 0 'font-lock-macro-keywords-face) ;;Testing
                          ;;("\\<\\(include\\|define\\|undef\\|ifndef\\|ifdef\\|else\\|elif\\|endif\\|error\\|pragma\\|if\\)\\>" 0 'font-lock-macro-keywords-face)
                          (";" 0 'font-lock-semicolon-face)))


(defconst cpp-style
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
                        ;(statement-block-intro . c-lineup-arglist-intro-after-paren)
                        (case-label . 4)
                        (block-open . 0)
                        (inline-open . 0)
                        (topmost-intro-cont . 0)
                        (knr-argdecl-intro . -4)
                        (brace-list-open . 0)
                        (brace-list-intro . 4)))
    (c-echo-syntactic-information-p . t)))

(defun cpp-style ()
(c-add-style "cpp" cpp-style t)
(c-set-style "cpp"))
