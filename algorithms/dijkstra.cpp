#include <iostream>
#include <cstdio>
#include <queue>
#include <cstring>
#include "utils.h"
using namespace std;

using Pi = Edge;

void dijkstra(int s, Graph& g) {
    vector<bool> vis(g.size(), false);
    vector<int> dist(g.size(), 0x3f3f3f3f);
    auto compare = [](Pi lhs, Pi rhs) {
        return lhs.se > rhs.se;
    };
    priority_queue<Pi, vector<Pi>, decltype(compare)> q(compare);
    long long score = 0;
    dist[s] = 0;
    q.push(mp(s, 0));
    while(!q.empty()) {
        while (!q.empty() && vis[q.top().fi]) {
            q.pop();
            score += 1;
        }
        if (!q.empty()) {
            Pi k = q.top(); q.pop();
            vis[k.fi] = true;
            score += 1;
            for (Edge& e : g[k.fi]) {
                score += 1;
                if (dist[e.fi] > dist[k.fi] + e.se) {
                    dist[e.fi] = dist[k.fi] + e.se;
                    q.push(mp(e.fi, dist[e.fi]));
                }
            } 
        }
    }
    cout << "Score: " << score << endl;
    cout << dist[dist.size() - 1] << endl;
}

int main() {
    Graph g = readGraph();
    dijkstra(0, g);
    return 0;
}