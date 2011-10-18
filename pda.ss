#lang planet neil/sicp

; Basic stack. By design, pushing nil has no effect.
(define (stack-push item stack)
  (if (null? item) stack (cons item stack)))
(define (stack-pop stack)
  (if (null? stack) '() (cdr stack)))
(define (stack-peek stack)
  (if (null? stack) '() (car stack)))

; A pushdown automaton is:
;  start-state       -- the start state
;  accept-state      -- a list of accept states
;  transitions       -- maps from a (state, input, stack) pair to a (state, stack) pair
(define (make-pda start-state accept-states transitions)
  (list start-state accept-states transitions))

; Convenience functions
(define (get-start-state pda) (car pda))
(define (get-accept-states pda) (cadr pda))
(define (get-transitions pda) (caddr pda))

; Takes a pda, a state, an input, and the top element on the stack and returns the next state
(define (apply-transition state input stack-top pda)
  (let ((result (assoc (list state input stack-top) (get-transitions pda))))
    (if result 
        (cadr result)
        nil)))

; Returns #t if state is an accept state of pda and #f otherwise.
(define (accept-state? state pda)
  (if (member state (get-accept-states pda)) '#t '#f))

;refactor -- bah
(define (get-next-action next)
  (if (list? (cadr next))
      (caadr next)
      (cadr next)))
(define (get-next-arg next)
  (if (list? (cadr next))
      (cadadr next)))

; Run pda from current-state until input is exhausted
(define (run-pda-inner input stack current-state pda)
  (if (null? input) (accept-state? current-state pda)
      (let ((next (apply-transition current-state (car input) (stack-peek stack) pda)))
        (if (null? next)
            '#f ; bad input, stop and reject
            (let ((next-state (car next))
                  (next-action (get-next-action next)) ; push, pop or noop
                  (next-item (get-next-arg next))) ; next item to push (or nil if pop or noop)
              (let ((updated-stack (cond
                                     ((equal? next-action 'push)
                                      (stack-push next-item stack))
                                     ((equal? next-action 'pop)
                                      (stack-pop stack))
                                     ((equal? next-action 'noop)
                                      stack))))
                (run-pda-inner (cdr input) updated-stack next-state pda)))))))
                         
; Run pda on input
(define (run-pda input pda)
  (run-pda-inner input '() (get-start-state pda) pda))


; E.g., a pda that accepts strings with an equal number of a's and b's
(define transitions
  '(((equal  a ()) (more-a (push $)))
    ((equal  b ()) (more-b (push $)))
    ((more-a a $)   (more-a (push a)))
    ((more-a a a)   (more-a (push a)))
    ((more-a b a)   (more-a pop))
    ((more-a b $)   (equal  pop))
    ((more-b b $)   (more-b (push b)))
    ((more-b b b)   (more-b (push b)))
    ((more-b a b)   (more-b pop))
    ((more-b a $)   (equal  pop))))
(define pda
  (make-pda 'equal '(equal) transitions))

;(run-pda '(a a b a b b b a) pda)