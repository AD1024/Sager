#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <deque>
#include <vector>
#include <fstream>
using namespace std;

using Edge = pair<int, int>;
using Edges = vector<Edge>;
using Graph = vector<Edges>;

#define mp(x, y) make_pair(x, y)
#define fi first
#define se second

inline void addEdge(Graph& g, int u, int v, int w) {
    g[u].push_back(mp(v, w));
}

inline void printVec(vector<int>& dist) {
    for (auto i : dist) {
        cout << i << " ";
    }
    cout << endl;
}

inline Graph readGraph() {
    int n, m;
    scanf("%d%d", &n, &m);
    Graph g(n);
    for (int i = 0, u, v, w; i < m; ++i) {
        scanf("%d%d%d", &u, &v, &w);
        addEdge(g, u, v, w);
    }
    return g;
}