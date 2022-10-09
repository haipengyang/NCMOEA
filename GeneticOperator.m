function offspring = GeneticOperator(parents, AdjMatrix, SimMatrix, condCenterFlag, condCenter, pseudoCenter, changeFlag, pc, pcc)
% Crossover
parentCenter = parents(:, condCenterFlag);
offspring = parents;
[N, D] = size(offspring);

[N, Dcenter] = size(parentCenter);
offspringCenter = parentCenter;
parentCenter(parentCenter>0) = 0;
offspringCenter(offspringCenter>0) = 0;
for i = 1 : 2 : N
    if rand < pc
        k = rand(1, Dcenter) < pcc;
        offspringCenter(i,:)   = parentCenter(i,:);
        offspringCenter(i+1,:) = parentCenter(i+1,:);
        offspringCenterOld1 = offspringCenter(i, :);
        offspringCenterOld2 = offspringCenter(i+1, :);
        offspringCenter(i,k)   = parentCenter(i+1,k);
        offspringCenter(i+1,k) = parentCenter(i,k);

        crossFlag1 = offspringCenter(i, :) ~= offspringCenterOld1;
        offspring(i, condCenter(crossFlag1)) = offspringCenter(i, crossFlag1);
        crossFlag2 = offspringCenter(i+1, :) ~= offspringCenterOld2;
        offspring(i+1, condCenter(crossFlag2)) = offspringCenter(i+1, crossFlag2);
        
%         offspring(i, offspring(i, :)~=-1 & condCenterFlag) = 0;
%         offspring(i+1, offspring(i+1, :)~=-1 & condCenterFlag) = 0;

        checkflag = offspringCenter(i, :) - parentCenter(i, :);
        newCenter = condCenter(checkflag==-1);
        for nc = newCenter
            offspring(i, parents(i+1, :)==nc & offspring(i, :)~=-1) = nc;
        end
        checkflag = offspringCenter(i+1, :) - parentCenter(i+1, :);
        newCenter = condCenter(checkflag==-1);
        for nc = newCenter
            offspring(i+1, parents(i, :)==nc & offspring(i+1, :)~=-1) = nc;
        end
    end
end

% Mutation
pm = 1/D;
k = rand(N, Dcenter);
temp = k<=pm;
offspringCenterMut = offspringCenter;
offspringCenterMut(temp) = (-1) - offspringCenterMut(temp);
for i = 1 : N
    if any(offspringCenter(i, :)==-1)
        mutFlag = offspringCenterMut(i, :) ~= offspringCenter(i, :);
        offspring(i, condCenter(mutFlag)) = offspringCenterMut(i, mutFlag);
    else
        offspring(i, condCenter) = offspringCenterMut(i, :);
    end
    checkflag = offspringCenterMut(i, :) - offspringCenter(i, :);
    newCenter = condCenter(checkflag==-1);
    nflag = offspring(i,:)~=-1;
    for nc = newCenter
        neighborflag = AdjMatrix(nc, :);
        offspring(i, neighborflag & nflag) = nc;
    end
end

[N, D] = size(offspring);
temp = rand(N, D);
pm1 = repmat(1/D, N, D);
mutflag = temp <= pm1;
for i = 1:N
    mutnodes = find(offspring(i,:)~=-1 & mutflag(i, :));
    for n = mutnodes
        neighbors = find(AdjMatrix(n, :));
        choose = neighbors(unidrnd(length(neighbors)));
        if offspring(i, n) ~= offspring(i, choose)
            if offspring(i, choose) == -1
                offspring(i, n) = choose;
            else
                offspring(i, n) = offspring(i, choose);
            end
        end
    end
end

pseudoFlag = false(1, D);
pseudoFlag(pseudoCenter) = true;
for i = 1:N
    offspring(i, offspring(i, :)==-1 & pseudoFlag) = 0;
    if sum(offspring(i, :)==-1) < 2
        randIndex = randperm(length(condCenter), 2);
        offspring(i, condCenter(randIndex)) = -1;
		offspring(i, offspring(i, :)~=-1) = 0;
    end
    centerNodes = find(offspring(i, :)==-1);
    labels = unique(offspring(i, :));
    diff = setdiff(labels, [-1, centerNodes]);
    for il = diff
        offspring(i, offspring(i, :)==il) = 0;
    end
    offspring(i, offspring(i, :)==0) = AssignNodes(offspring(i, :)==0, offspring(i, :)==-1, SimMatrix);
end

