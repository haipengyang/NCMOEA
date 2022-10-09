function [clu_assignment] = decode( g)
% Efficient decoding of the locus-based adjcency representation.
N = length(g);
current_cluster = 1;
cluster_assignment = zeros(1,N);
for i = 1:N
    cluster_assignment(i) = -1;
end

for i = 1:N
    ctr = 1;
    if (cluster_assignment(i) == -1)
        previous = zeros(1,N);
        cluster_assignment(i) = current_cluster;
        neighbour = g(i);
        previous(ctr) = i;
        ctr = ctr + 1;
        while (cluster_assignment(neighbour) == -1)
            previous(ctr) = neighbour;
            cluster_assignment(neighbour) = current_cluster;
            neighbour = g(neighbour);
            ctr = ctr + 1;
        end
        if (cluster_assignment(neighbour) ~= current_cluster)
            ctr = ctr - 1;
            while (ctr >= 1)
                cluster_assignment(previous(ctr)) = cluster_assignment(neighbour);
                ctr = ctr - 1;
            end
        else
            current_cluster = current_cluster + 1;
        end  
    end
end

clu_assignment = cluster_assignment;
% clu_assignment1=zeros(1,numVar);
% for i=1:N
%     for j=1:length(Node1(i).e)
%         clu_assignment1(Node1(i).e(j))=clu_assignment(i);
%     end
% end

