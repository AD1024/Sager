#include <queue>
#include <vector>
#include <climits>
#include <cstring>
#include <iostream>
#include "utils.h"
using namespace std;

using vw = pair<int, int>;

#define fi first
#define se second

void spfa_adjlist(int s, vector<vector<vw>>& g) {
    vector<int> dist(g.size(), 0x3f3f3f3f);
    vector<bool> vis(g.size(), false);
    queue<int> q;
    dist[s] = 0;
    q.push(s);
    long long score = 0;
    while(q.size()) {
        score += 1;
        // if (score % 10000000 == 0) {
        //     cout << "Score has reached " << score << endl;
        // }
        int front = q.front();
        q.pop();
        vis[front] = false;
        for (auto &e : g[front]) {
            score += 1;
            // if (score % 10000000 == 0) {
            //     cout << "Score has reached " << score << endl;
            // }
            if (dist[e.fi] > dist[front] + e.se) {
                dist[e.fi] = dist[front] + e.se;
                if (!vis[e.fi]) {
                    q.push(e.fi);
                    vis[e.fi] = true;
                }
            }
        }
    }
    cout << "Score: " << score << endl;
    cout << "Answer: " << dist[dist.size() - 1] << endl;
}

void adjList_addEdge(vector<vector<vw>>& g, int u, int v, int w) {
    g[u].push_back(make_pair(v, w));
}

int main() {
    int n, m;
    int S;
    scanf("%d%d", &n, &m);
    vector<vector<vw>> g(n);
    for (int i = 0, u, v, w; i < m; ++i) {
        scanf("%d%d%d", &u, &v, &w);
        adjList_addEdge(g, u, v, w);
    }
    spfa_adjlist(0, g);
    return 0;
}