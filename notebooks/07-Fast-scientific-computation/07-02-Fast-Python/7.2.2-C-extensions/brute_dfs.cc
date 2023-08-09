#include <vector>
#include <unordered_map>
#include <numeric>


void recurse(
    int node,
    std::unordered_map < int, std::vector < int > > & adj_list,
    std::unordered_map < int, bool > & visited) {

    visited[node] = 1;
    for (auto & val: adj_list[node]) {
        if (visited.find(val) == visited.end()) {
            recurse(val, adj_list, visited);
        }
    }
}

int dfs(std::unordered_map < int, std::vector < int > > & adj_list) {

    int res = 0, prev = 0;
    std::unordered_map < int, bool > visited;

    for (auto & [key, value]: adj_list) {
        if (visited.find(key) == visited.end()) {
            recurse(key, adj_list, visited);
        }

        int len = visited.size() - prev;
        res = std::max(len, res);
        prev = visited.size();
    }

    return res;
}

void create_graph(std::unordered_map < int, std::vector < int > > &adj_list, std::vector<int> &nums) {
    for (int i = 0; i < nums.size(); i++) {
        for (int j = i + 1; j < nums.size(); j++) {

            if (std::gcd(nums[i], nums[j]) > 1) {
                adj_list[nums[i]].push_back(nums[j]);
                adj_list[nums[j]].push_back(nums[i]);
            }
        }
    }
}

int _largest_component_size(int *array, int length) {
    // Conversion from C-style array to C++ vector to integrate into codebase
    std::vector<int> nums(array, array + length);
    std::unordered_map < int, std::vector < int > > adj_list;
    create_graph(adj_list, nums);

    return dfs(adj_list);
}

// A second function that avoids overheads of copying data assuming all integers in interval
int _largest_component_size_all_integers(int length) {
    std::vector<int> nums(length);
    std::iota(nums.begin(), nums.end(), 1);
    std::unordered_map < int, std::vector < int > > adj_list;
    create_graph(adj_list, nums);
    
    return dfs(adj_list);
}

// Tells the compile to use C-linkage for the next scope.
extern "C" {

    int largest_component_size(int *array, int length) {
        return _largest_component_size(array, length);
    }

    int largest_component_size_all_integers(int length) {
        return _largest_component_size_all_integers(length);
    }
}
