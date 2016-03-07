function [Y] = average_frames(X, L)
% average_frames(X, L) average predictions for stacked 
% spectral frames (i.e. belonging to the same time instant)
    nrows = size(X,1)/L; 
    for i = 1:size(X,2)
        Y(:,i)=mean(reshape(X(:,i), nrows,L),2);
    end
end
