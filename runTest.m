%Real_Network
clear; clc;format compact;

networkfile1 = {'karate'};
bestResult = [];
avgResult = [];

for iii = [1]
    name = networkfile1{iii};
    networkfile = sprintf('RealWorldTest/%s.edgelist',name);
    real_path = sprintf('RealWorldTest/real_label_%s.txt',name);
    embfile = sprintf('RealWorldTest/%s_16.emb', name);
    M = load(networkfile);
    numVar = max(max(M));
    AdjMatrix = Adjreverse(M,numVar,0);
    degree = sum(AdjMatrix);
    NetEmb = EmbRead(embfile);
    emptyIndex = find(degree==0);
    AdjMatrix(emptyIndex,:) = [];
    AdjMatrix(:,emptyIndex) = [];
    numVar = size(AdjMatrix, 1);
    degree = sum(AdjMatrix);
    Datalabel=load(real_path);
    disp(name);
    SavePath = sprintf('result/%s', name);
    [b, a, s, at] = Main(AdjMatrix, Datalabel, NetEmb, SavePath);
    saveFilename = sprintf('result_%s.txt', name);
    savedata1(saveFilename, [b; a; s; 0 at]);
    bestResult = [bestResult; b];
    avgResult = [avgResult; a];
end