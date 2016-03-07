function extract_training_data(training_data_path, opt)
% extract_training_data(training_data_path, opt)
% extract training data from 50 songs in the dataset
% if training_data_path points to an existing mat file, 
% return its contents
% otherwise, compute and sample/stack stft frames for 
% vocal, nonvocal and mix signals 

    vocal_frames = [];
    nonvocal_frames = [];
    mix_frames = [];

    if exist(training_data_path, 'file')
        training_data = load(training_data_path);
        vocal_frames = training_data.vocal_frames;
        nonvocal_frames = training_data.nonvocal_frames;
        mix_frames = training_data.mix_frames;
        disp('loaded training data from disk');
    else
        for track_id = 1:50
            disp(track_id)
            track_data = get_analysis(opt.dataset, track_id, opt.FFT_SIZE, opt.HOP_SIZE);
            vocal_mag = abs(track_data.target_stft);
            vocal_frames = [vocal_frames sample_frames(vocal_mag, opt.L, opt.H)];
            nonvocal_mag = abs(track_data.nontarget_stft);
            nonvocal_frames = [nonvocal_frames sample_frames(nonvocal_mag, opt.L, opt.H )];
            mix_frames = [mix_frames abs(sample_frames(track_data.mix_stft, opt.L, opt.H))];
        end
        save(training_data_path,'vocal_frames','nonvocal_frames','mix_frames','-V7.3');
    end
end
