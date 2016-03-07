function analysis = get_analysis (dataset, index, FFT_SIZE, HOP_SIZE)
% analysis = get_analysis (dataset, index, FFT_SIZE, HOP_SIZE)
% compute stft and mixtures of target (vocal) and nontarget (nonvocal) stems
% as well as ideal binary mask
    
    [target_stems, other_stems] = load_stems(dataset, index);
    analysis.target_mix = mix_stems(target_stems);            
    analysis.nontarget_mix = mix_stems(other_stems);    
    analysis.mix = 0.5 * analysis.target_mix + 0.5 * analysis.nontarget_mix;
    
    analysis.target_stft = stft(analysis.target_mix, FFT_SIZE, HOP_SIZE, hanning(FFT_SIZE));
    analysis.nontarget_stft = stft(analysis.nontarget_mix, FFT_SIZE, HOP_SIZE, hanning(FFT_SIZE));
    analysis.mix_stft = stft(analysis.mix, FFT_SIZE, HOP_SIZE, hanning(FFT_SIZE));
    analysis.mask = abs(analysis.target_stft) > abs(analysis.nontarget_stft);
end
