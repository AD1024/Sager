#lang rosette

(provide (all-defined-out))

(define (solver-for-spfa-adj-matrix algo graph limit)
  (let ([symbolic-cost (algo graph 0 limit)])
    (λ (cost)
      (solve (assert (eq? symbolic-cost cost))))))

(define (solver-for-spfa-adj-matrix-sorted algo graph limit)
  (let ([symbolic-costs (for/list
                            ([start-idx (vector-length graph)])
                          (algo graph start-idx limit))])
    (λ (cost)
      (solve (assert (ormap (curry eq? cost) symbolic-costs))))))
