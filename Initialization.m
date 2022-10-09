function population = Initialization(AdjMatrix, SimMatrix, condCenterFlag, popsize)
numVar = size(AdjMatrix, 1);
N2 = popsize/2;
V = numVar;
f = zeros(N2, V);
for n = 1 : N2
    elem = zeros(1, V);
    for i = 1 : V
        neighbors = find(AdjMatrix(i,:)==1);
        choose = unidrnd(length(neighbors));
        if isempty(neighbors)
            disp('Neighbors empty ERROR!');
        end
        elem(i) = neighbors(choose);
    end
    f(n, 1:V) = decode(elem);
end
population = zeros(N2, V);

% Half of the individuals
for n = 1 : N2
    solution = f(n, :);
    maxc = max(solution);
    for c = 1 : maxc
        centersFlag = condCenterFlag & (solution == c);
        centers = find(centersFlag);
        if ~isempty(centers)
            choose = centers(unidrnd(length(centers)));
            population(n, solution==c) = choose;
            population(n, choose) = -1;
        else
            population(n, solution==c) = 0;
        end
    end
end
for n = 1 : N2
    if sum(population(n, :)==0) > 0
        population(n, population(n,:)==0) = AssignNodes(population(n,:)==0, population(n,:)==-1, SimMatrix);
    end
end

% The other half of the individuals
condCenter = find(condCenterFlag);
maxCenterNum = length(condCenter);
choosenNum = randi([2, floor(sqrt(numVar))], 1, N2);
for i = 1 : N2
    randIndex = randperm(maxCenterNum, choosenNum(i));
    population(N2+i, condCenter(randIndex)) = -1;
    centerFlag = population(N2+i, :)==-1;
    population(N2+i, ~centerFlag) = AssignNodes(~centerFlag, centerFlag, SimMatrix);
end
