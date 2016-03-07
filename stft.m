function X = stft( x, N, H, win)
% X = stft(x, N, H, win)
% Short-time fourier transform of time domain signal x 
% with N-point fft, hop size H and window win
    W = length(win);
    buf = buffer(x, W, W - H);
    buf = buf.*repmat(win, 1, size(buf,2));
    buf = [buf; zeros(N-length(win), size(buf,2))];
    X = fft(buf, N);
    X = X(1:end / 2 + 1, :);
end