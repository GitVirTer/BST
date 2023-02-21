%% Author Information
% Author: GY Liu
% Email: virter1995@outlook.com
% Date: 2019-11-28
% Function: Plot CWT and ST
% Others:

%% Main function
function [NewData,t,f] = FeatureExtract_STransSingleMex(data,sample_freq,freqRange,freqSamp,pp1,sqzSize, outputMode)

freqSamplingRate = length(data)/sample_freq;
minFreq = freqRange(1)*freqSamplingRate;
maxFreq = freqRange(2)*freqSamplingRate;

if logical(round(freqSamplingRate/freqSamp))
    freqInterval = round(freqSamplingRate/freqSamp);
else
    freqInterval = 1;
end
[data_st,t,f] = ast_mex(data,minFreq,maxFreq,1/sample_freq,freqInterval,pp1);
% f = f/freqSamplingRate;
[~,time]= size(data_st);

switch outputMode
    case 'amplitude'
        data_st_psd = abs(data_st);
    case 'psd'     
        data_st_psd = abs(data_st).^2;
    case 'phase'
        data_st_psd = angle(data_st);
    case 'amplitude+phase'
        data_st_psd = rescale(abs(data_st)) .* angle(data_st);
    case 'psd+phase'
        data_st_psd = rescale(abs(data_st).^2) .* angle(data_st);
    otherwise

end

div = sqzSize;
SegN = numel(data)/div;
st_psd_us = [];
for nSeg = 1:SegN
    tmpData = mean(data_st_psd(:,(nSeg-1)*div+1 : nSeg*div)');
    st_psd_us = [st_psd_us tmpData'];
end

% st_psd_us = st_psd_us./max(max(st_psd_us));

NewData = st_psd_us;

