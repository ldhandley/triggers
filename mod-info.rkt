#lang codespells

(provide mod-name pak-folder main.rkt)

(require racket/runtime-path)

(define
  mod-name
  "Triggers")

(define-runtime-path
  pak-folder
  "BuildUnreal/WindowsNoEditor/Triggers/Content/Paks/")

(define-runtime-path
  main.rkt
  "main.rkt")

(setup-mod mod-name pak-folder)
