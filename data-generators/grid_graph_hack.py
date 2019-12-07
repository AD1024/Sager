from random import randint as rand
import random
import math
import os

def addEdge(fp, u, v, w):
    fp.write(f'{u} {v} {w}\n')

os.chdir(os.path.dirname(__file__))
if not os.path.exists('../data'):
    os.mkdir('../data')
if __name__ == '__main__':
    N = 100000
    row = 100
    col = N // row
    M = row * (col - 1) + col * (row - 1) + (N - 3)
    getW = lambda: rand(1, 100)
    with open('../data/test-grid-spfa-lll-{}'.format(N), 'w') as fp:
        # fp.write(f'{N} {M}\n')
        half = N // 2
        skip = N + 3 if N % 2 == 0 else N // 2 + 1
        edges = []
        for i in range(0, half - 1):
            (x, y) = (i, i + 1)
            edges.append((x + (x >= skip), y + (y >= skip), getW()))
            (x, y) = (i + half - 1, i + half)
            edges.append((x + (x >= skip), y + (y >= skip), getW()))
        for i in range(0, half):
            (x, y) = (i, i + half)
            edges.append((x + (x >= skip), y + (y >= skip), getW()))
        
        for i in range(10):
            (x, y) = (rand(0, N), rand(0, N))
            edges.append((x, y, getW()))
        fp.write(f'{N} {len(edges) * 2}\n')
        random.shuffle(edges)
        for tup in edges:
            fp.write('{} {} {}\n'.format(*tup))
            tup = (tup[1], tup[0], tup[2])
            fp.write('{} {} {}\n'.format(*tup))

        # for i in range(2, N):
        #     if i == row:
        #         continue
        #     addEdge(fp, 0, i, rand(100000, 105000))