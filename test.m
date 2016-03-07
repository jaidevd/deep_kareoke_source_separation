addpath('jsonlab');
% Compute training data, train and sweep alpha 
% for the nmf method.
% Note that for these parameters (particularly L) 
% you need a machine with loads of memory. 
% Do not try these in your laptop or desktop. Make some numbers.
% You have been warned.

%% 0 Configure parameters
options.L = 20; % number of stacked frames
options.H = 60; % Training data resample hop
options.K = 1500; % number of NMF basis
options.P = 1; % exponent for ratio mask (NMF)
options.N_BINS = 1025; %number of FFT bins
options.FFT_SIZE = 2 * (options.N_BINS-1); % STFT FFT size
options.HOP_SIZE = 512; % STFT hop size
options.N_ITER = 100; % number of iterations
options.dataset = loadjson('medleydb_deepkaraoke.json');
% this json file points to files in the medleydb database
% obtain it from http://medleydb.weebly.com/
% then configure the "base_path" of the dataset in the json file


% Training and model files will be created the first time 
% and re-used subsequntly. Delete or move to re-create.
training_data_path = 'path/to/training_file.mat';
model_path = 'path/to/model_file.mat';
results_path = 'path/to/results/';

%% 1 Extract training data (common for both methods)
extract_training_data(training_data_path, options);
training_data = load(training_data_path);

%% 2 Train model (dnn or nmf)
train_neural_net(training_data, model_path, options);
%train_nmf(training_data, model_path, options);

%% 3 Seep alpha parameter (1 for dnn, 2 for nmf)
sweep_alpha(2,model_path, results_path, options);

% After all result files have been created, 
% set results_dir in plot_results and run
