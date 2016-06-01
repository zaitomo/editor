(set-language-environment "Japanese")
(setq default-input-method "Japanese-mozc")
(prefer-coding-system 'utf-8)
(setq-default c-basic-offset 4 tab-width 4) ;;タブ幅4
;;(indent-tabs-mode nil) ;;インデントをタブでするかスペースでするか
;; 改行後インデント
(global-set-key "\C-m" 'newline-and-indent)
;; 自動で色を付ける設定
(global-font-lock-mode t)
(set-frame-font "ricty-13.5")

;;Ctrl+Tabでタブorウィンドウの切り替え
(defun other-window-or-split (val)
  (interactive)
  (when (one-window-p)
;    (split-window-horizontally) ;split horizontally
    (split-window-vertically) ;split vertically
  )
  (other-window val))

(global-set-key (kbd "<C-tab>") (lambda () (interactive) (other-window-or-split 1)))
(global-set-key (kbd "<C-S-tab>") (lambda () (interactive) (other-window-or-split -1)))

;; キーバインド
(define-key global-map "\C-h" 'delete-backward-char) ; 削除

(define-key global-map "\C-c:" 'uncomment-region)    ; コメント解除
(define-key global-map "\C-z" 'undo) ;c-zでundo

;;スタートアップ非表示
(setq inhibit-startup-screen t)
;;バックアップファイル作らない
(setq make-backup-files nil)
;; 対応する括弧を光らせる
(show-paren-mode 1)
;; バックアップファイルを作らない
(setq backup-inhibited t)
;; カーソルの位置が何文字目かを表示する
(column-number-mode t)
;; カーソルの位置が何行目かを表示する
(line-number-mode t)
;; タイトルバーにファイル名を表示する
(setq frame-title-format (format "emacs@%s : %%f" (system-name)))
;; 画像ファイルを表示する
(auto-image-file-mode t)
;;行番号表示
(global-linum-mode t)

;; Haskell.
(add-to-list 'load-path "~/.emacs.d/elisp/haskell-mode-2.8.0")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/haskell-mode/")
(load "haskell-mode-autoloads.el")
(autoload 'haskell-mode "haskell-mode" nil t)
(autoload 'haskell-cabal "haskell-cabal" nil t)
(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.lhs$" . literate-haskell-mode))
(add-to-list 'auto-mode-alist '("\\.cabal\\'" . haskell-cabal-mode))
(add-to-list 'interpreter-mode-alist '("runghc" . haskell-mode))     ;#!/usr/bin/env runghc 用       
(add-to-list 'interpreter-mode-alist '("runhaskell" . haskell-mode)) ;#!/usr/bin/env runhaskell 用

(add-to-list 'exec-path "~/.cabal/bin")  ; これをしてないと*Message*に"ghc-mod not found"と出て動かない
(add-to-list 'load-path "~/.emacs.d/elisp/ghc-mod")

(autoload 'ghc-init "ghc" nil t)

(add-hook 'haskell-mode-hook
          '(lambda ()
            (ghc-init)
            (flymake-mode)
			))

;; key-comboの設定用関数
(defun my-haskell-key-combo ()
  (key-combo-define-local (kbd "-") '("-" " -> " "--"))
  ;; (key-combo-define-local (kbd "<=") '("<="))
  (key-combo-define-local (kbd "<") '("<" " <- " " <= " " =<< " "<<" "<"))
  (key-combo-define-local (kbd ">") '(">" " >= " " >>= " ">"))
  (key-combo-define-local (kbd "=") '("=" " = " " == " "=="))
  (key-combo-define-local (kbd ":") '(":" " :: " "::"))
  )

;; 後でまとめてadd-hookするための関数
(defun my-haskell-add-hook ()
  (turn-on-haskell-indentation)
  (font-lock-mode)
  (imenu-add-menubar-index)
  (turn-on-haskell-doc-mode)
  (my-haskell-key-combo)
  )

;(setq haskell-program-name "/usr/bin/ghci")                                                         
;(add-hook 'haskell-mode-hook 'inf-haskell-mode) ;; enable                                           
(defadvice inferior-haskell-load-file (after change-focus-after-load)
  "Change focus to GHCi window after C-c C-l command"
  (other-window 1))
(ad-activate 'inferior-haskell-load-file)
(custom-set-variables
 '(haskell-mode-hook 'my-haskell-add-hook)
 '(haskell-indent-after-keywords (quote (("where" 4 0) ("of" 4) ("do" 4) ("mdo" 4) ("rec" 4) ("in" 4 0) ("{" 4) "if" "then" "else" "let")))
 '(haskell-indent-offset 4)
 '(haskell-indent-spaces 4)
 )
