function mix = mix_stems(stems)
% mix = mix_stems(stems) normalize and mix signals 
% corresponding to stems of the target mixture, 
% at controlled (equal) levels
    [nstems, nsamples] = size(stems);
    mix = zeros(1,nsamples);
    for i = 1:nstems
       stem = stems(i,:); 
       stem = stem ./ max(abs(stem));
       stem = stem ./ nstems;
       mix = mix + stem; 
    end    
end