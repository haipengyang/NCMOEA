function functionValue = Evalution(population, AdjMatrix, degree)
N = size(population, 1);
functionValue = zeros(N, 2);
for i = 1:N
    functionValue(i, :) = fun_c(AdjMatrix, MixDecode(population(i, :)), degree);
end
end