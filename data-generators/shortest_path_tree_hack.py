import random
import os

os.chdir(os.path.dirname(__file__))
if not os.path.exists('../data'):
    os.mkdir('../data')
for N, M, W in [(10000, 30000, 100), (100000, 300000, 1000)]:
    fa = [0] * N
    dep = [0] * N
    with open(f'../data/test-spt-hack-{N}', 'w') as fp:
        fp.write(f'{N} {M}\n')
        store = []
        for i in range(1, N):
            fa[i] = random.randint(max(i - 5, 0), i - 1)
            w = random.randint(1, W)
            dep[i] = dep[fa[i]] + w
            store.append(f'{fa[i]} {i} {w}\n')
        M = M - N + 1
        for i in range(0, M):
            a, b = (random.randint(0, N - 1), random.randint(0, N - 1))
            while a == b:
                a, b = (random.randint(0, N - 1), random.randint(0, N - 1))
            store.append(f'{a} {b} {random.randint(dep[b] - dep[a], dep[b] - dep[a] + 5)}\n')
        random.shuffle(store)
        for datum in store:
            fp.write(datum)
