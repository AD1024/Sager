#lang rosette
(provide adj-matrix adj-matrix-sorted adj-matrix-sb*)
(require "helper.rkt")

(define (adj-matrix n)
  (define mtx (for/vector ([i n])
                (for/vector ([j n])
                  (if (or (= i j) (= j 0))
                      (make-bv 0 SZ)
                      (begin
                        (define-symbolic* v (bitvector 3))
                        (zero-extend v (bitvector SZ))
                        )))))
  mtx)

(define (adj-matrix-sorted n)
  (define mtx (for/vector ([i n])
                (for/vector ([j n])
                  (if (or (= i j) (= j 0))
                      (make-bv 0 SZ)
                      (begin
                        (define-symbolic* v (bitvector 3))
                        (zero-extend v (bitvector SZ))
                        )))))
  (define (row-≤ a b [idx 0])
    (let ([ax (vector-ref a idx)]
          [bx (vector-ref b idx)])
      (or (bvule ax bx)
          (and (bveq ax bx)
               (or (= idx n) (row-≤ a b (+ idx 1)))))))
  (for ([i (- n 1)])
    (let ([ai (vector-ref mtx i)]
          [ai+1 (vector-ref mtx (+ i 1))])
      (assert (row-≤ ai ai+1))))
  mtx)

(define (adj-matrix-sb* n)
  (define mtx (for/vector ([i n])
                (for/vector ([j n])
                  (if (or (= i j) (= j 0))
                      (make-bv 0 SZ)
                      (begin
                        (define-symbolic* v (bitvector 3))
                        (zero-extend v (bitvector SZ))
                        )))))
  (define (mono-≤ xs ys i j (idx 0))
    (let ([x (vector-ref xs idx)]
          [y (vector-ref ys idx)])
      (cond
        [(or (= idx i)
             (= idx j)) (mono-≤ xs ys i j (+ idx 1))]
        [(= (- n 1) idx) (bvule x y)]
        [else (or (bvule x y)
                  (and (bveq x y) (mono-≤ xs ys i j (+ idx 1))))])))
  (for ([j n])
    (for ([i j])
      (unless (= (- j i) 2)
        (assert (mono-≤ (vector-ref mtx i) (vector-ref mtx j) i j)))))
  mtx)
