function Y = sample_frames(X, L, H)
% Y = sample_frames(X, L, H)
% sample spectral frames with hop size H and stack L frames
        n_hops = round((size(X,2) - L) / H);
        Y = [];
        for hop = 0:n_hops-1
               hop_start = (hop * H) + 1;
               chunk =  X(:, hop_start:hop_start + L - 1);
               Y = [Y chunk(:)];
        end
end
