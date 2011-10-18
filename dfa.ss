#lang planet neil/sicp

; A state machine is:
;  start-state       -- the start state
;  accept-state      -- a list of accept states
;  transitions       -- maps from a (state, input) pair to a state
(define (make-dfa start-state accept-states transitions)
  (list start-state accept-states transitions))

; Convenience functions
(define (get-start-state dfa) (car dfa))
(define (get-accept-states dfa) (cadr dfa))
(define (get-transitions dfa) (caddr dfa))

; Takes a dfa, a state, and an input, and returns the next state
(define (apply-transition state input dfa)
  (let ((result (assoc (list state input) (get-transitions dfa))))
    (if result (cadr result))))

; Returns #t if state is an accept state of dfa and #f otherwise.
(define (accept-state? state dfa)
  (if (member state (get-accept-states dfa)) '#t '#f))

; Run dfa from current-state until input is exhausted
(define (run-dfa-inner input current-state dfa)
  (if (null? input) (accept-state? current-state dfa)
      (run-dfa-inner (cdr input)
                     (apply-transition current-state (car input) dfa)
                     dfa)))

; Run dfa on input
(define (run-dfa input dfa)
  (run-dfa-inner input (get-start-state dfa) dfa))


; E.g.,
;(define transitions
;  '(((even-num 0) even-num)
;    ((even-num 1) odd-num)
;    ((odd-num 0) even-num)
;    ((odd-num 1) odd-num)))
;(define odd-binary-num-dfa
;  (make-dfa 'even-num '(odd-num) transitions))

; Outputs #t because 10011 = 19 is odd
;(run-dfa '(1 0 0 1 1) odd-binary-num-dfa)