#lang rosette

(require "helper.rkt")

(provide (all-defined-out))

(define (elim model)
  (if (unsat? model) #f model))

(define (find-model solver l r (debug #f))
  (displayln "Start...")
  (and (<= l r)
       (printf "finding model for [~a, ~a]\n" l r)
       (let* ([mid (quotient (+ l r) 2)])
         (define model (solver mid))
         (printf "model for [~a, ~a] is ~aSAT\n" l r (if (unsat? model) "UN" ""))
         (if (= l r)
             (elim model)
             (if (unsat? model)
                 (find-model solver l (- mid 1))
                 (or (find-model solver mid r) model))))))

;; this uses a binary search in its algorithm
(define (solve-graph generator algo size model-solver (size-limit (* size size)))
  (define graph (generator size))
  (define partial-model-solver (model-solver algo graph size-limit))
  (define (find-model l r)
    (printf "finding for [~a, ~a]\n" l r)
    (and (<= l r)
         (let* ([mid (quotient (+ l r) 2)]
                [model (time (partial-model-solver mid))])
           (printf "model for [~a, ~a] is ~asatisfiable\n" l r (if (unsat? model) "un" ""))
           (if (= l r)
               (elim model)
               (if (unsat? model)
                   (find-model l (- mid 1))
                   (or (find-model (+ mid 1) r) model))))))
  (define model (find-model 1 size-limit))
  (vector-map (curry vector-map (λ (x) (if (expression? x) bv1 x))) (evaluate graph model)))

;; this uses the strategy of evaluating the algorithm everytime to get a tighter
;; bound on the size limit
(define (solve-graph+ generator algo size model-solver (size-limit (* size size)))
  (define graph #f)
  (define (elim model) (if (unsat? model) #f model))
  (define (find-model l r)
    (printf "finding for [~a, ~a]\n" l r)
    (and (<= l r)
         (let* ([mid (quotient (+ l r) 2)]
                [graph+ (generator size)]
                [model (time ((model-solver algo graph+ (+ mid 1)) mid))])
           (when (sat? model) (set! graph graph+))
           (printf "model for [~a, ~a] is ~asatisfiable\n" l r (if (unsat? model) "un" ""))
           (if (= l r)
               (elim model)
               (if (unsat? model)
                   (find-model l (- mid 1))
                   (or (find-model (+ mid 1) r) model))))))
  (define model (find-model 1 size-limit))
  (vector-map (curry vector-map (λ (x) (if (expression? x) bv1 x))) (evaluate graph model)))

;; this uses the strategy of incremental solving
(define (solve-graph++ generator algo size (size-limit (* size size)))
  (define graph (generator size))
  (define (elim model) (if (unsat? model) #f model))
  (define-symbolic* symbolic-cost integer?)
  ;(define symbolic-cost (algo graph 0 size-limit))
  (define inc (solve+))
  (inc (= symbolic-cost (algo graph 0 size-limit)))
  (define (find-model cost)
    (printf "finding for cost ~a\n" cost)
    (and (<= cost size-limit)
         (let* ([model (time (inc (>= symbolic-cost cost)))])
           (printf "model for cost ~a is ~asatisfiable\n" cost (if (unsat? model) "un" ""))
           (if (sat? model)
               (or (find-model (+ cost 1)) model) #f))))
  (define model (find-model 1))
  (vector-map (curry vector-map (λ (x) (if (expression? x) bv1 x))) (evaluate graph model)))
 
