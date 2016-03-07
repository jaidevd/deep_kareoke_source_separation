function network = train_neural_net(training_data, neural_net_path, opt)
    addpath('dk_dl_toolbox/NN')
    addpath('dk_dl_toolbox/util')

    if exist(neural_net_path, 'file')
        mat_data = load(neural_net_path);
        network = mat_data.network;
        disp('loaded network from disk');
    else
        ideal_binary_mask = training_data.vocal_frames > training_data.nonvocal_frames;
        training_input = training_data.mix_frames' ./ max(max(training_data.mix_frames));
        training_output = ideal_binary_mask';

        training_input = training_input(1:15000,:); % As in paper, crop to exactly 15k training examples
        training_output = training_output(1:15000,:);

        nn_opts.batchsize = 100; 
        nn_opts.plot = 0;
        rand('state',0);
        layer_size = size(training_input,2)
        network = nnsetup([layer_size layer_size layer_size]);         
        network.activation_function = 'sigm';    %  Sigmoid activation function
        network.output              = 'sigm';    % Sigmoid output layer
        network.learningRate        = 0.1;       %  low learning rate
        network.sparsityTarget      = 0;         % No sparsity 
        nn_opts.numepochs              = 1;         % SINGLE FULL SWEEP SGD AT A TIME

        for i = 1:opt.N_ITER % We do this in stages so we can save it at each time step (i.e., to scratch)
            [network, L_ERROR] = nntrain(network, training_input, training_output, nn_opts);
        end

        save(neural_net_path,'network','-V7.3');

    end
end

