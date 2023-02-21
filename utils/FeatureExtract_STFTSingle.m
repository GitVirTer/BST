%% Author Information
% Author: GY Liu
% Email: virter1995@outlook.com
% Date: 2019-11-28
% Function: Plot CWT and ST
% Others:

%% Main function
function [NewData,t,f] = FeatureExtract_STFTSingle(data,sample_freq,freqRange,opt, outputMode)

[s,f,t] = spectrogram(data,opt.window,opt.noverlap,freqRange(1):freqRange(2),sample_freq);
% [~,f,t,ps] = spectrogram(data,opt.window,opt.noverlap,freqRange(1):freqRange(2),sample_freq,'reassigned'); %,'power'


switch outputMode
    case 'amplitude'
        data_stft_psd = abs(s);
    case 'psd'     
        data_stft_psd = abs(s).^2;
    case 'phase'
        data_stft_psd = angle(s);
    case 'amplitude+phase'
        data_stft_psd = rescale(abs(s)) .* angle(s);
    case 'psd+phase'
        data_stft_psd = rescale(abs(s).^2) .* angle(s);
    otherwise

end
NewData = data_stft_psd;




