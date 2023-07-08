#lang racket/base

(provide lsp-editor%)

(require framework
         racket/class)

(define lsp-editor%
  (class object%
    (define core (new racket:text%))

    (define/private (set-core! new-core)
      (set! core new-core))

    ;; insert str at start
    (define/public (insert str start)
      (send core insert str start))

    ;; replace text at (range start end) with str
    (define/public (replace str start end)
      (send core insert str start end))

    (define/public (delete start end)
      (send core delete start end))

    ;; remove all content
    (define/public (erase)
      (send core erase))

    (define/public (load-file path)
      (send core load-file path))

    ;; return current content in editor as string
    (define/public (get-text [start 0] [end 'eof])
      (send core get-text start end))

    ;; return the number of characters in editor
    ;; also the end of file position
    (define/public (end-pos)
      (send core last-position))

    (define/public (line/char->pos line char)
      (+ char (send core paragraph-start-position line)))

    (define/public (pos->line/char pos)
      (define line (send core position-paragraph pos))
      (define line-begin (send core paragraph-start-position line))
      (define char (- pos line-begin))
      (list line char))

    (define/public (line-start-pos line)
      (send core paragraph-start-position line))

    (define/public (line-end-pos line)
      (send core paragraph-end-position line))

    ;; pos at which line?
    (define/public (at-line pos)
      (send core position-paragraph pos))

    (define/public (copy)
      (define new-editor (new lsp-editor%))
      (send new-editor set-core! (send core copy-self))
      new-editor)

    (define/public (get-char pos)
      (send core get-character pos))

    (define/public (get-line line)
      (send core get-text (send this line-start-pos line) (send this line-end-pos line)))

    (define/public (compute-racket-amount-to-indent pos)
      (send core compute-racket-amount-to-indent pos))

    (super-new)))