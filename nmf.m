function [W, H] = nmf(V, K, iterations, W, H, update_W, update_H)
% [W, H] = nmf(V, K, iterations, W, H, update_W, update_H)
% Non-negative matrix factorization using multiplicative updates 
% to minimize KL-divergence. V is the spectrogram or non-negative matrix, 
% K the number of basis, W and H can be passed as initial values
% (otherwise they are randomly initialized).
% update_W and update_H control wether W and/or H are updated at each 
% iteration or fixed at the initial value

    F = size(V,1);
    T = size(V,2);

    rand('seed', 0)

    if isempty(W)
        W = rand(F, K);
    end

    if isempty(H)
        H = rand(K, T);
    end

    ONES = ones(F,T);
    for i=1:iterations
        disp(i);
        if (update_H)
            H = H .* (W' * ( V./(W * H + eps))) ./ (W' * ONES);
        end
        if (update_W)
            W = W .* ((V ./ (W * H + eps)) * H') ./ (ONES * H');
        end
        sumW = sum(W);
        W = W * diag(1 ./ sumW);
        H = diag(sumW) * H;
    end
end