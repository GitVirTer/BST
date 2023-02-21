%% Information
% Author: Guoyang Liu
% Email: gyangliu@hku.hk
% Date: 2023.2.22
% Function: Excution time comparison

%% Main
clear;
ThisToolRootPath = pwd;
addpath(genpath(ThisToolRootPath));

%% Settings
rng('default')
s = rng;

nChannels = 10000;
randSignals = rand(1,256, nChannels);
Fs = 256;

sqzSize = 8;                    % Squeeze size (pooling size) along time axis
outputMode = 'psd';             % Output method ('amplitude', 'psd', 'phase', 'amplitude+phase', 'psd+phase')
selFreqRange = [1,50];          % Frequency range (Hz)
freqPrecision = 1;              % Frequency domain resolution
gaussianFactor = 0.5;           % p-value of generalized S-transform to ajust the Gaussian window shape

for iRepeat = 1:10
    %% Vanilla ST
    tic_vst = tic;
    stMap_vanilla_single = zeros(50, 32, nChannels);
    for i = 1:size(randSignals,3)
        curSignal = randSignals(:,:,i);
        stMap_vanilla_single(:,:,i) = FeatureExtract_STransSingle(curSignal,Fs,selFreqRange,freqPrecision,gaussianFactor,sqzSize, outputMode);
    
    end
    t_vst(iRepeat) = toc(tic_vst);
    disp(['Vanilla ST consumes: ' num2str(t_vst(iRepeat)) 's']);
    
    %% Mex ST
    tic_mst = tic;
    stMap_mex_single = zeros(50, 32, nChannels);
    for i = 1:size(randSignals,3)
        curSignal = randSignals(:,:,i);
        stMap_mex_single(:,:,i) = FeatureExtract_STransSingleMex(curSignal,Fs,selFreqRange,freqPrecision,gaussianFactor,sqzSize, outputMode);
    
    end
    t_mst(iRepeat) = toc(tic_mst);
    disp(['Mex ST consumes: ' num2str(t_mst(iRepeat)) 's']);
    
    %% Vectorized ST
    tic_gst = tic;
    stMap_Vec = FeatureExtract_STransGPU(randSignals,Fs,selFreqRange,freqPrecision,gaussianFactor,sqzSize, outputMode);
    t_vecst(iRepeat) = toc(tic_gst);
    disp(['Vectorized ST consumes: ' num2str(t_vecst(iRepeat)) 's']);
    
    %% GPU ST
    if canUseGPU
        randSignals_gpu = gpuArray(randSignals);
        tic_gst = tic;
        stMap_GPU = FeatureExtract_STransGPU(randSignals_gpu,Fs,selFreqRange,freqPrecision,gaussianFactor,sqzSize, outputMode);
        t_gst(iRepeat) = toc(tic_gst);
        stMap_GPU = gather(stMap_GPU);
        disp(['GPU ST consumes: ' num2str(t_gst(iRepeat)) 's']);
    end
    
    %% Validation
    error_GPU_V = sum(abs(stMap_Vec-stMap_vanilla_single), 'all');
    error_GPU_M = sum(abs(stMap_Vec-stMap_mex_single), 'all');
    error_V_M = sum(abs(stMap_vanilla_single-stMap_mex_single), 'all');

end

t_vst_mean = mean(t_vst);
t_vst_std = std(t_vst);
t_mst_mean = mean(t_mst);
t_mst_std = std(t_mst);
t_vecst_mean = mean(t_vecst);
t_vecst_std = std(t_vecst);
t_gst_mean = mean(t_gst);
t_gst_std = std(t_gst);


