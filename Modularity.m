function Q = Modularity(solution,AdjacentMatrix)

degree=single(sum(AdjacentMatrix,2));
edge_num=sum(degree)/2;
solution=single(solution);
m=max(solution);
Q=0;
for i=1:m
    if length(find(solution==i))>0
    Community_AdjMatrix=logical(AdjacentMatrix(find(solution==i),find(solution==i)));
    Degree_Matrix=single(degree(find(solution==i)))*single(degree(find(solution==i))')/(2*edge_num);
        Q=Q+sum(sum(Community_AdjMatrix-Degree_Matrix,1));
    end
end
clear Community_AdjMatrix Degree_Matrix;
Q=Q/(2*edge_num);

end
