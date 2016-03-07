function [Wv, Wnv] = train_nmf(training_data, model_path, options)
    if exist(model_path, 'file')
        mat_data = load(model_path);
        Wv = mat_data.Wv;
        Wnv = mat_data.Wnv;
        disp('loaded model from disk');
    else
        vocal_frames = training_data.vocal_frames(:, sum(training_data.vocal_frames,1) > 0 );
        nonvocal_frames = training_data.nonvocal_frames(:, sum(training_data.nonvocal_frames,1) > 0 );
        [Wv,Hv] = nmf(vocal_frames, K, options.N_ITER, [], [], 1, 1);
        [Wnv,Hnv] = nmf(training_data.nonvocal_frames, options.K, options.N_ITER, [], [], 1, 1);
        %Wa = [Wv Wnv];
        save(model_path,'Wv', 'Wnv','-V7.3');

    end
end

