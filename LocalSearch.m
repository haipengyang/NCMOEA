function best = LocalSearch(solution, AdjMatrix, degree)
best = solution;
V = size(AdjMatrix, 2);
vertexList = 1:V;
vertexList = vertexList(randperm(length(vertexList)));
for n = 1:V
    if solution(vertexList(n)) ~= -1
        vertex = vertexList(n);
        vNeighbors = [find(AdjMatrix(vertex, :)==1), vertex];
        changeLabel = setdiff(unique(best(vNeighbors)), -1);
        temp = best;
        maxDeltaQ = 0;
        maxLabel = best(vertex);
        for c = 1:length(changeLabel)
            temp(vertex) = changeLabel(c);
            if temp(vertex)==best(vertex)
                deltaQ = 0;
            else
                deltaQ = DeltaModularity(AdjMatrix, degree, vertex, MixDecode(best), MixDecode(temp));
                if deltaQ > maxDeltaQ
                    maxDeltaQ = deltaQ;
                    maxLabel = changeLabel(c);
                end
            end
        end
        if maxDeltaQ > 0
            best(vertex) = maxLabel;
        end
    end
end
end
