#About

Deterministic finite automata (DFAs) and pushdown automata (PDAs) in Scheme.

## Example

The following pushdown automaton recognizes inputs with an equal number of `a`s and `b`s.

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

  ; Run the pda on the input "aababbba"
  (run-pda '(a a b a b b b a) pda) ; outputs #t

The format of the transitions map is a list of lists (of lists of lists...). Each entry has as its first item a list of the form `(state input-item stack-item)`. The second item is another list of the form `(state operation)`, where `operation` is either `pop` (pop the stack), `noop` (do nothing), or a list of the form `(push item)`, where `item` is whatever you want to push onto the stack.

For example:

  ((start 2 +) (continue (push 2)))

means that when in state `start`, if the current input is `2` and the top item on the stack is `+`, push `2` onto the stack and goto the `continue` state.

##License

Copyright (c) 2011, Nicholas Bergson-Shilcock. All rights reserved.

SaveMyTweets is released under the GPLv3. See the included LICENSE file or http://www.gnu.org/licenses
