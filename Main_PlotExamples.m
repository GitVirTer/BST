%% Information
% Author: Guoyang Liu
% Email: gyangliu@hku.hk
% Date: 2023.2.22
% Function: Plot CWT and ST and STFT

%% Main
clear;
ThisToolRootPath = pwd;
addpath(genpath(ThisToolRootPath));

%%%%%%%%%%%%%%%%%%%%%%%%%% Synthesized Signals %%%%%%%%%%%%%%%%%%%%%%%%%%
fs = 256;
f1=10;
f2=20;
f3=25;
f4=15;
simulationTime = 4;
t=1/fs:1/fs:simulationTime;
sig1=sin(2*pi*f1*t)+sin(2*pi*f2*t);
sig2=sin(2*pi*f3*t)+sin(2*pi*f4*t);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%% Epileptic EEG Signals %%%%%%%%%%%%%%%%%%%%%%%%%%
load testData.mat seizureData normalData;
sig1 = seizureData;
sig2 = normalData;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Fs = 256;

sqzSize = 8;                    % Squeeze size (pooling size) along time axis
outputMode = 'psd';             % Output method ('amplitude', 'psd', 'phase', 'amplitude+phase', 'psd+phase')
selFreqRange = [1,50];          % Frequency range (Hz)
freqPrecision = 1;              % Frequency domain resolution
% waveletName = 'cmor1-1';
waveletName = 'db4';            % Wavelet name
gaussianFactor = 0.5;           % p-value of generalized S-transform to ajust the Gaussian window shape

% data = data_seizure;

nRow = 7;
nCol = 2;
N_Fig = nRow*nCol;

%% Plot
figure;

% Plot Normal
data = sig2;

subplot(nRow,nCol,1)
t = (0:length(data)-1)/Fs;
plot(t,data);
xlim([t(1) t(end)]);
% xlabel('Time(s)');
xticklabels([]);
ylabel('Amplitude');
title('Normal');

subplot(nRow,nCol,[3 5])
[NewData,t,f] = FeatureExtract_WaveletSingle(data,Fs,selFreqRange,freqPrecision,waveletName,sqzSize, outputMode);
imagesc(t,(f),(NewData));
set(gca,'YDir','normal')
% xlabel('Time(s)');
ylabel('Frequency(Hz)');
title(['Wavelet Transform (' waveletName ')']);
xticklabels([]);

subplot(nRow,nCol,[7 9])
[NewData,t,f] = FeatureExtract_STransSingle(data,Fs,selFreqRange,freqPrecision,gaussianFactor,sqzSize, outputMode);
% [NewData,t,f] = FeatureExtract_STransGPU(data,Fs,selFreqRange,freqPrecision,gaussianFactor,sqzSize, outputMode);
imagesc(t,(f),(NewData));
set(gca,'YDir','normal')
% xlabel('Time(s)');
ylabel('Frequency(Hz)');
title('Stockwell Transform');
xticklabels([]);

subplot(nRow,nCol,[11 13])
opt.window = Fs;
opt.noverlap = Fs-sqzSize+2;
[NewData,t,f] = FeatureExtract_STFTSingle(data,Fs,selFreqRange,opt, outputMode);
imagesc(t,(f),(NewData));
set(gca,'YDir','normal')
xlabel('Time(s)');
ylabel('Frequency(Hz)');
title('Short Time Fourier Transform');

% Plot Seizure
data = sig1;

subplot(nRow,nCol,2)
t = (0:length(data)-1)/Fs;
plot(t,data);
xlim([t(1) t(end)]);
% xlabel('Time(s)');
ylabel('Amplitude');
title('Seizure');
xticklabels([]);

subplot(nRow,nCol,[4 6])
[NewData,t,f] = FeatureExtract_WaveletSingle(data,Fs,selFreqRange,freqPrecision,waveletName,sqzSize, outputMode);
imagesc(t,(f),(NewData));
set(gca,'YDir','normal')
% xlabel('Time(s)');
ylabel('Frequency(Hz)');
title(['Wavelet Transform (' waveletName ')']);
xticklabels([]);

subplot(nRow,nCol,[8 10])
[NewData,t,f] = FeatureExtract_STransSingle(data,Fs,selFreqRange,freqPrecision,gaussianFactor,sqzSize, outputMode);
% [NewData,t,f] = FeatureExtract_STransGPU(data,Fs,selFreqRange,freqPrecision,gaussianFactor,sqzSize, outputMode);
imagesc(t,(f),(NewData));
set(gca,'YDir','normal')
% xlabel('Time(s)');
ylabel('Frequency(Hz)');
title('Stockwell Transform');
xticklabels([]);

subplot(nRow,nCol,[12 14])
opt.window = Fs;
opt.noverlap = Fs-sqzSize+2;
[NewData,t,f] = FeatureExtract_STFTSingle(data,Fs,selFreqRange,opt, outputMode);
imagesc(t,(f),(NewData));
set(gca,'YDir','normal')
xlabel('Time(s)');
ylabel('Frequency(Hz)');
title('Short Time Fourier Transform');



