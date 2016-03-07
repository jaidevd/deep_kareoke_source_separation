function sweep_alpha(method, model_path, results_path, opt)
% sweep_alpha(method, model_path, results_path, opt)
% Compute and apply binary mask for each value of the alpha 
% parameter in 100 steps from 0 to 1. Load model (nmf or dnn) 
% from model_path, store results in results_path
    addpath('bss_eval');
    model_data = load(model_path);

    % comment out if you do not have the parallel toolbox
    delete(gcp);
    pool = parpool();    
    parfor test_track = 50:63
        disp(test_track);
        gSDR=[]; gSIR=[]; gSAR=[];
        track_data = get_analysis(opt.dataset, test_track, opt.FFT_SIZE, opt.HOP_SIZE);  
        original_length = length(track_data.target_mix);
        original_sources = [track_data.target_mix' track_data.nontarget_mix'];
        switch method
            case 1
                test_input = sample_frames(abs(track_data.target_stft), opt.L, 1)';
                test_input = test_input ./ max(max(test_input));
                test_network = load(model_path); % trick for parfor
                test_network = test_network.network;
                test_network.testing = 1; % feed-forward only
                result = nnff(test_network, test_input, zeros(size(test_input,1), test_network.size(end)));
                v = result.a{3}'; % final layer activations
                mask = average_frames(v, opt.L);
                mask = mask - min(min(mask));
                mask = mask ./ max(max(mask));
            case 2
                nmf_model = load(model_path); % trick for parfor
                Wa = [nmf_model.Wv, nmf_model.Wnv];
                [W, H] = nmf( sample_frames(abs(track_data.target_stft), opt.L, 1), size(Wa, 2), opt.N_ITER, Wa, [], 0, 1);
                H(isnan(H)) = eps;
                H(H==0) = eps;
                Hv = H(1:opt.K, :);
                Hnv = H(opt.K+1:end, :);
                Vv = nmf_model.Wv * Hv;
                Vnv = nmf_model.Wnv * Hnv;
                V = Vv + Vnv;
                mask = Vv .^ opt.P ./ ((Vv .^ opt.P) + (Vnv .^ opt.P));
                mask = average_frames(mask, opt.L);
        end
        n_frames = size(mask,2);
        alpha_test = 1;
        for alpha = 0.01:0.1:0.99
                disp(alpha);
                binary_mask_vocal = mask > alpha;
                binary_mask_nonvocal = mask < (1 - alpha);    
                vocal_estimate_stft = track_data.mix_stft(:,1:n_frames) .* binary_mask_vocal
                nonvocal_estimate_stft = track_data.mix_stft(:,1:n_frames) .* binary_mask_nonvocal;
                vocal_estimate = istft(vocal_estimate_stft, opt.FFT_SIZE, opt.HOP_SIZE, hann(opt.FFT_SIZE));
                nnonvocal_estimate = istft(nonvocal_estimate_stft, opt.FFT_SIZE, opt.HOP_SIZE, hann(opt.FFT_SIZE));
                
                min_length = min(length(track_data.target_mix), length(vocal_estimate));
                if(sum(vocal_estimate_stft(:))) == 0
                        disp('zero vocal est');
                        vocal_estimate = zeros(min_length, 1) + eps;
                end

                if(sum(nonvocal_estimate_stft(:))) == 0
                        nnonvocal_estimate = zeros(min_length, 1) + eps;
                        disp('zero nonvocal est');
                end
                estimates = [vocal_estimate(1:min_length) nnonvocal_estimate(1:min_length)];
                original_sources = [track_data.target_mix(1:min_length)' track_data.nontarget_mix(1:min_length)'];
                [SDR,SIR,SAR,perm] = bss_eval_sources(estimates',original_sources')
                if ( isnan(SDR(1)) || isnan(SDR(2)) )
                    disp(test_track);
                    error('nan SDR');
                end
                gSDR(alpha_test+1,:) = SDR;
                gSIR(alpha_test+1,:) = SIR;
                gSAR(alpha_test+1,:) = SAR;
                alpha_test = alpha_test + 1
        end
        [p,n,e] = fileparts(opt.dataset.mixes{test_track}.mix_path);
        filename = strcat(results_path, n);
        savefunc = @(gSDR,gSIR,gSAR) save(filename,'gSDR','gSIR','gSAR'); % workaround for parfor
        savefunc(gSDR,gSIR,gSAR);
    end
    delete(pool);
end
