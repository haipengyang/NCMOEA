function cen = Centrality(AdjMatrix, degree)
num = length(degree);
cen = zeros(1, num);
for v = 1:num
    cen(v) = degree(v) + sum(degree(AdjMatrix(v, :)));
    neighbors = find(AdjMatrix(v, :));
    for n = neighbors
        nei_neighbors = AdjMatrix(n, :);
        cen(v) = cen(v) + sum(degree(nei_neighbors));
    end
end