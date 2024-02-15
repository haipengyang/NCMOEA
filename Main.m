function [bestResult, avgResult, stddiff, avgTime] = Main(AdjMatrix, DataLabel, NetEmb, SavePath)

%----------------------------------------
RunTime = 15;
MaxGeneration = 100;
PopSize = 100;
pc = 0.9;
iv = 10;
%-----------------------------------------

NumVar = size(AdjMatrix, 1);
degree = sum(AdjMatrix);

maxQAllTimes = [];
corrNMIAllTimes = [];
maxNMIAllTimes = [];
corrQAllTimes = [];
timeAllTimes = [];

if ~isdir(SavePath)
    mkdir(SavePath);
end

for rt = 1:RunTime
    tic;
    SimMatrix = Tosim_matrix(AdjMatrix, 1);
    NumVar = size(AdjMatrix, 1);
    degree = sum(AdjMatrix);
    cen = Centrality(AdjMatrix, degree);
    
    EmbDist = squareform(pdist(NetEmb));
    [~, pnode1] = max(cen);

    classlabel = zeros(1, NumVar);
    [~, farnode1] = max(EmbDist(pnode1, :));
    idx1 = kmeans(NetEmb, 2, 'Start', NetEmb([pnode1, farnode1], :));
    classlabel(idx1==idx1(pnode1)) = 1;
    classlabel(classlabel==0) = 2;

    condCenterFlag = false(1, NumVar);
    condCenter = find(classlabel == 1);
    condCenterFlag(condCenter) = true;
    changeFlag = false(1, NumVar);
    changeFlag(classlabel == 2) = true;
    
    population = Initialization(AdjMatrix, SimMatrix, condCenterFlag, PopSize);
    functionValue = Evalution(population, AdjMatrix, degree);
    frontValue = F_NDSort(functionValue, 'all');
    crowdDistance = F_distance(functionValue, frontValue);
    
    centerCounter = zeros(1, length(condCenter));
    sumCounter = 0;
    pseudoCenter = [];
    
    for gen = 1:MaxGeneration
        matingPool = F_mating(population, frontValue, crowdDistance);
        pcc = 0.5 * (1-gen/MaxGeneration);

        offspring = GeneticOperator(matingPool, AdjMatrix, SimMatrix, condCenterFlag, condCenter, pseudoCenter, changeFlag, pc, pcc);
        funcOffspring = Evalution(offspring, AdjMatrix, degree);
        population = [population; offspring];
        functionValue = [functionValue; funcOffspring];
        [population, functionValue, frontValue, crowdDistance, ~] = ...
            EnvironmentalSelection(population, functionValue, PopSize);
        
        if mod(gen, iv) == 0
            for indiIndex = find(frontValue==1)
                population(indiIndex, :) = LocalSearch(population(indiIndex, :), AdjMatrix, degree);
                functionValue(indiIndex, :) = Evalution(population(indiIndex,:), AdjMatrix, degree);
            end
        end
    end
    
    finalPopulation = population;
    finalFunctionValue = functionValue;
    [finalFrontValue, finalMaxFront] = F_NDSort(finalFunctionValue, 'all');
    finalPopulation = finalPopulation(finalFrontValue==1, :);
    finalFunctionValue = finalFunctionValue(finalFrontValue==1, :);
    
    timeOneTime = roundn(toc, -2);
    
    timeAllTimes = [timeAllTimes timeOneTime];
    
    fprintf('%d Time Complete, Use %f s.\n', rt, single(timeOneTime));
    
    PFSize = size(finalPopulation, 1);
    Q = zeros(PFSize, 1);
    NMI = zeros(PFSize, 1);
    for indiIndex = 1:PFSize
        Q(indiIndex) = Modularity(MixDecode(finalPopulation(indiIndex,:)), AdjMatrix);
        NMI(indiIndex) = nmi(MixDecode(finalPopulation(indiIndex,:)), DataLabel);
    end
    [maxQ, maxQIndex] = max(Q);
    corrNMI = NMI(maxQIndex);
    [maxNMI, maxNMIIndex] = max(NMI);
    corrQ = Q(maxNMIIndex);
    maxQAllTimes = [maxQAllTimes, maxQ];
    corrNMIAllTimes = [corrNMIAllTimes, corrNMI];
    maxNMIAllTimes = [maxNMIAllTimes, maxNMI];
    corrQAllTimes = [corrQAllTimes, corrQ];
%     save('current.mat');

    Qsavefile = sprintf('%s/Qmetrics.txt', SavePath);
    savedata1(Qsavefile, [maxQAllTimes', corrNMIAllTimes', timeAllTimes']);
    QSolsavefile = sprintf('%s/Qsolu_%d.txt', SavePath, rt);
    savedata1(QSolsavefile, finalPopulation(maxQIndex, :));
    
    NMIsavefile = sprintf('%s/NMImetrics.txt', SavePath);
    savedata1(NMIsavefile, [corrQAllTimes', maxNMIAllTimes', timeAllTimes']);
    NMISolsavefile = sprintf('%s/NMIsolu_%d.txt', SavePath, rt);
    savedata1(NMISolsavefile, finalPopulation(maxNMIIndex, :));
    
    PFsavefile = sprintf('%s/PF_%d.txt', SavePath, rt);
    savedata1(PFsavefile, finalPopulation);
end
[bestQ, bestQIndex] = max(maxQAllTimes);
NMI_bestQ = corrNMIAllTimes(bestQIndex);
[bestNMI, bestNMIIndex] = max(maxNMIAllTimes);
Q_bestNMI = corrQAllTimes(bestNMIIndex);
bestResult = [bestQ, NMI_bestQ; Q_bestNMI, bestNMI];
avgResult = [mean(maxQAllTimes), mean(corrNMIAllTimes); mean(corrQAllTimes), mean(maxNMIAllTimes)];
stddiff = [std(maxQAllTimes), std(corrNMIAllTimes); std(corrQAllTimes), std(maxNMIAllTimes)];
avgTime = mean(timeAllTimes);
end
