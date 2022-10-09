function [Population, FunctionValue, FrontValue, CrowdDistance, MaxFront] =...
    EnvironmentalSelection(Population, FunctionValue, N)
[FrontValue, MaxFront] = F_NDSort(FunctionValue, 'half');
% [FrontValue, MaxFront] = F_NDSort(FunctionValue, 'half');
CrowdDistance         = F_distance(FunctionValue,FrontValue);            
%
Next        = zeros(1,N);
while numel(FrontValue, FrontValue<MaxFront)>N
    MaxFront = MaxFront - 1;
end
NoN         = numel(FrontValue,FrontValue<MaxFront);
Next(1:NoN) = find(FrontValue<MaxFront);
Last          = find(FrontValue==MaxFront);
[~,Rank]      = sort(CrowdDistance(Last),'descend');
Next(NoN+1:N) = Last(Rank(1:N-NoN));
Population    = Population(Next,:);
FunctionValue = FunctionValue(Next,:);
FrontValue    = FrontValue(Next);
CrowdDistance = CrowdDistance(Next);           
[~,MaxFront] = F_NDSort(FunctionValue,'all');
end