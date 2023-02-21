%% Author Information
% Author: GY Liu
% Email: virter1995@outlook.com
% Date: 2019-11-28
% Function: Plot CWT and ST
% Others:

%% Main function
function [NewData,t,f] = FeatureExtract_WaveletSingle(data, Fs, ScaleRange, freqSamp, wavename,sqzSize, outputMode)
t = (0:length(data)-1)/Fs;
% wavename='cmor3-3';
totalscal=freqSamp*Fs/2;
wcf=centfrq(wavename);
cparam=2*wcf*totalscal;
a=totalscal:-1:1;
scal=cparam./a;
[cfs,f] = cwt(data, scal(end-freqSamp*ScaleRange(2):end-freqSamp*ScaleRange(1)), wavename, 1/Fs);

switch outputMode
    case 'amplitude'
        cfs = abs(cfs);
    case 'psd'     
        cfs = abs(cfs).^2;
    case 'phase'
        cfs = angle(cfs);
    case 'amplitude+phase'
        cfs = rescale(abs(cfs)) .* angle(cfs);
    case 'psd+phase'
        cfs = rescale(abs(cfs).^2) .* angle(cfs);
    otherwise

end

wv_psd = cfs;

div = sqzSize;
SegN = numel(data)/div;
wv_psd_us = [];
for nSeg = 1:SegN
    tmpData = mean(wv_psd(:,(nSeg-1)*div+1 : nSeg*div)');
    wv_psd_us = [wv_psd_us tmpData'];
end

NewData = wv_psd_us;


end

