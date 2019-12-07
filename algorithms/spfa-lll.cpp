#include "utils.h"
using namespace std;

void spfa(int s, Graph& g) {
    long long score = 0;
    long long cnt, sum;
    cnt = sum = 0;
    vector<int> dist(g.size(), 0x3f3f3f3f);
    vector<bool> vis(g.size(), false);
    dist[s] = 0;
    deque<int> q;
    q.push_front(s);
    cnt = 1;
    while(not q.empty()) {
        score += 1;
        int k = q.front();
        // while (1ll * dist[k] * cnt > sum) {
        //     q.push_back(k);
        //     k = q.front();
        // }
        q.pop_front();
        cnt -= 1;
        sum -= dist[k];
        vis[k] = false;
        for (Edge& e : g[k]) {
            score += 1;
            int v = e.fi;
            int w = e.se;
            if (dist[v] > dist[k] + w) {
                int previous = dist[v];
                dist[v] = dist[k] + w;
                if (not vis[v]) {
                    vis[v] = true;
                    if (sum > 1ll * cnt * dist[k]) {
                        q.push_front(v);
                    } else {
                        q.push_back(v);
                    }
                    cnt += 1;
                    sum += dist[v];
                } else {
                    sum -= previous;
                    sum += dist[v];
                }
            }
        }
    }
    cout << "Score: " << score << endl;
    cout << "Answer: " << dist[dist.size() - 1] << endl;
}

int main() {
    Graph g = readGraph();
    spfa(0, g);
    return 0;
}