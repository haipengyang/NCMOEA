function labels = AssignNodes(nonCenterFlag, centerFlag, SimMatrix)
[~, loc] = max(SimMatrix(nonCenterFlag, centerFlag), [], 2);
centerNodes = find(centerFlag);
labels = centerNodes(loc);
end