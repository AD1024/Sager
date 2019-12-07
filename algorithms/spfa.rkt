#lang rosette

(require "../helper.rkt")

(provide (all-defined-out))


(define (spfa-with-no-vis g s
                          [limit (expt (vector-length g) 3)]
                          [debug #f])
  (define size (vector-length g))
  (define (count-row row)
    (foldr (λ (x v) (if (eq? x bv0) v (+ 1 v))) 0 (vector->list row)))
  (define edge-count (vector-map count-row g))
  (define dist (for/vector ([x size])
                 (if (eq? x s) bv0 (max-bv SZ))))
  (define q (make-q limit))
  (vector-set! dist s bv0)
  (push-q! q s)
  (let run-spfa ([cost 0]
                 [depth limit]
                 [log-list '()])
    (assert (>= depth 0))
    (define front (pop-q! q))
    (when debug (printf "front: ~a\n" front))
    (if front
        (let ([edges (vector-ref g front)])
          (for ([v size])
            (define w (vector-ref edges v))
            (unless (bveq w bv0)
              (define new-dist (bvadd (vector-ref dist front) w))
              (when (bvugt (vector-ref dist v) new-dist)
                (when debug (printf "in-q: ~a\n" v))
                (vector-set! dist v new-dist)
                (push-q! q v))))
          (run-spfa  (+ 1 (vector-ref edge-count front) cost)
                     (sub1 depth)
                     (if debug
                         (cons front log-list)
                         log-list)))
        (if debug (cons cost log-list) cost))))