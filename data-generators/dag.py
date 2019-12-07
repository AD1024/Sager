import random
import os

os.chdir(os.path.dirname(__file__))
if not os.path.exists('../data'):
    os.mkdir('../data')

for N, M, W in [(10000, 50000, 100), (100000, 500000, 1000)]:
    fa = [0] * N
    dep = [0] * N
    with open(f'data/test-dag-hack-{N}', 'w') as fp:
        fp.write(f'{N} {M}\n')
        store = []
        for i in range(1, N):
            store.append(f'{i - 1} {i} {random.randint(1, 3)}\n')
        M = M - N + 1
        for i in range(0, M):
            a, b = (random.randint(0, N - 1), random.randint(0, N - 1))
            while a >= b:
                a, b = (random.randint(0, N - 1), random.randint(0, N - 1))
            store.append(f'{a} {b} {random.randint(5,N*10)}\n')
        random.shuffle(store)
        for datum in store:
            fp.write(datum)
