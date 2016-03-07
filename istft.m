function x = istft( X, N, H, win)
% x = istft( X, N, H, win)
% Inverse short-time fourier transform of complex
% frequency-domain signal X with N-point fft, hop 
% size H and window win
    W = length(win);
    X = real( ifft( [X; conj(X(end-1:-1:2, :))]));
    x = zeros((size(X, 2)-1) * H + W, 1);
    wsum = zeros((size(X, 2) - 1) * H + W, 1) +  eps; 
    for i = 1:size(X,2)
        x( (i-1) * H + (1:W)) = X(1:W, i) + x((i-1) * H +(1:W) );
        wsum((i-1) * H + (1:W)) = wsum((i-1) * H + (1:W)) + win;
    end
    wsum(end) = wsum(end - 1);
    x = x ./ wsum;
    x = x(W-H:end);  
end
