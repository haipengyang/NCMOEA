function deltaQ = DeltaModularity(AdjMatrix, degree, changedNode, vectorBefore, vectorAfter)
v = changedNode;
m = sum(degree)/2;
communityBefore = vectorBefore==vectorBefore(v);
communityAfter = vectorBefore==vectorAfter(v);
ki = sum(degree(communityBefore));
kj = sum(degree(communityAfter));
kvi = sum(AdjMatrix(v, communityBefore));
kvj = sum(AdjMatrix(v, communityAfter));
kv = degree(v);
deltaQ = (kvj - kvi - (kv * (kj - ki + kv)) / (2 * m)) / m;
end
