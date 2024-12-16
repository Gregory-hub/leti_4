function [SE] = find_spectral_entropy(X1)
    F = fft(X1);
    S = abs(F).^2;
    P = S ./ sum(S);
    SE = -sum(P .* log2(P));
end
