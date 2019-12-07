# TO-DO (TO-CONSIDER) list

## symmetry breaking

- [X] Require lexigraphical order of adj matrix ([paper](https://www.ijcai.org/Proceedings/13/Papers/083.pdf), [longer version](https://link.springer.com/content/pdf/10.1007%2Fs10601-018-9294-5.pdf))
  - <del>Then one need do the same algorithm $n$ times to find if it makes cost some specific number</del>
  - Use only one SPFA to search the space
  - There is another $O(n^2)$ version of the constraints...
- [X] reduce choice over edge weight
  - two considerations: a) prune the search space (not so much weights to consider); b) avoid overflow of $\textit{dist}$.
  - zero-extending a shorter bitvector will make the solver slow, but putting no restriction will make dist overflow.

## various algorithms

- [X] adj-list spfa
- [X] spfa with inq-array (so the maximum push-q operation <= $\textit{size}^2$)
- [X] make cost function edge-aware
  - works only for adj-list, not adj-matrix

## mic

- [X] **Use incremental solving**
- [X] bug of graph-solve+ (size-limit, length of queue?)


# algorithm hacking

- [X] add spfa-lll.rkt and spfa-slf-lll.rkt
- [X] find some gadgets that time out spfa-slf (>= 40xN)
