#lang rosette

(require "../helper.rkt")

(provide (all-defined-out))

;; this is a spfa algorithm with a vis array to ensure that
;; every element will be in queue for at most one time at any time
;; This algorithm applies SLF (small label first) optimization
;; which can make the algorithm terminates as early as possible
(define (spfa-slf g s
                  [limit (expt (vector-length g) 2)]
                  [debug #f])
  (define bv0 (make-bv 0 SZ))
  (define (count-row row)
    (foldr (λ (x v) (if (eq? x bv0) v (+ 1 v))) 0 (vector->list row)))
  (define size (vector-length g))
  (define edge-count (vector-map count-row g))
  (define dist (for/vector ([x size])
                 (if (eq? x s) bv0 (max-bv SZ))))
  (define q (make-q limit #t))
  (define vis (make-vector size #f))
  (vector-set! dist s bv0)
  (push-q! q s)
  (vector-set! vis s #t)
  (let run-spfa ([cost 0]
                 [depth limit]
                 [log-list '()])
    (assert (>= depth 0))
    (define front (pop-q! q))
    (when debug
      (printf "front: ~a\n" front))
    (if front
        (let ([edges (vector-ref g front)])
          (vector-set! vis front #f)
          (iter edges 
                (λ (v-w)
                  (define v (car v-w))
                  (define w (cdr v-w))
                  (define new-dist (bvadd (vector-ref dist front) w))
                  (when (bvugt (vector-ref dist v) new-dist)
                    (vector-set! dist v new-dist)
                    (unless (vector-ref vis v)
                      (vector-set! vis v #t)
                      (when debug (printf "in-q: ~a\n" v))
                      (define head-element (front-q q))
                      (if (and head-element (bvult new-dist (vector-ref dist head-element)))
                          (push-q-front! q v)
                          (push-q! q v)
                          )))))
          (run-spfa  (+ 1 (vector-ref edge-count front) cost)
                     (sub1 depth)
                     (if debug
                         (cons front log-list)
                         log-list)))
        (if debug (cons cost (reverse log-list)) cost))))