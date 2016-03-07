% Plot bss-eval results of alpha sweep 

n_songs = 13
n_alpha = 11
n_sources = 2

SIR = zeros(n_songs, n_alpha, n_sources);
SAR = zeros(n_songs, n_alpha, n_sources);
SDR = zeros(n_songs, n_alpha, n_sources);

results_dir = '/path/to/results/';
results = dir(strcat(results_dir,'*.mat')); % one mat file per song

for i = 1:n_songs
     p = strcat(results_dir, results(i).name)
     eval_measures = load(p);
     SIR(i,:,:) = eval_measures.gSIR;
     SAR(i,:,:) = eval_measures.gSAR;
     SDR(i,:,:) = eval_measures.gSDR;
end

mSIR = mean(SIR,1);
mSAR = mean(SAR,1);
mSDR = mean(SDR,1);


figure;
plot(mSIR(1,:,1),'r');
hold on
plot(mSAR(1,:,1),'b');
plot(mSDR(1,:,1),'g');
legend('SIR', 'SAR', 'SDR');
title('vocal');
print('vocal','-dpng')

figure;
plot(mSIR(1,:,2),'r');
hold on
plot(mSAR(1,:,2),'b');
plot(mSDR(1,:,2),'g');
legend('SIR', 'SAR', 'SDR');
title('nonvocal');
print('nonvocal','-dpng')
