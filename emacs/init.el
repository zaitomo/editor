(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)
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
(require 'haskell-mode)
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
(add-to-list 'load-path "~/.cabal/bin/ghc-mod")

(setq haskell-program-name "/usr/bin/ghci")

(autoload 'ghc-init "ghc" nil t)

(add-hook 'haskell-mode-hook (lambda () (flymake-mode)))
(add-hook 'haskell-mode-hook '(lambda ()
								(ghc-init)
								(local-set-key "\C-j" (lambda () (interactive)(insert " -> ")))
								(local-set-key "\M-j" (lambda () (interactive)(insert " => ")))
								(local-set-key "\C-l" (lambda ()(interactive)(insert " <- ")))
								))

(defadvice inferior-haskell-load-file (after change-focus-after-load)
  "Change focus to GHCi window after C-c C-l command"
  (other-window 1))
(ad-activate 'inferior-haskell-load-file)

(custom-set-variables
 '(haskell-indent-offset 4)
 '(haskell-indent-spaces 4)
 )

;; auto-complete
(require 'auto-complete)
(require 'auto-complete-config)

(require 'ac-haskell-process)
(add-hook 'interactive-haskell-mode-hook 'ac-haskell-process-setup)
(add-hook 'haskell-interactive-mode-hook 'ac-haskell-process-setup)
(eval-after-load "auto-complete" '(add-to-list 'ac-modes 'haskell-interactive-mode))
(put 'downcase-region 'disabled nil)
