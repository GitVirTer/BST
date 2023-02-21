function [NewData,t,f] = FeatureExtract_STransGPU(data,sample_freq,freqRange,freqSamp,pp1,sqzSize, outputMode)
tempNum = data(1,1,1,1);
nCh = size(data,3);
nSample = size(data,4);

synData = reshape(data, [size(data,1) size(data,2) nCh*nSample]);

freqSamplingRate = size(data,2)/sample_freq;
minFreq = freqRange(1)*freqSamplingRate;
maxFreq = freqRange(2)*freqSamplingRate;
if logical(round(freqSamplingRate/freqSamp))
    freqInterval = round(freqSamplingRate/freqSamp);
else
    freqInterval = 1;
end

div = sqzSize;


[data_st,t,f] = ast_gpu_multiCh(synData,minFreq,maxFreq,1/sample_freq,freqInterval,pp1);

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

SegN = size(synData,2)/div;
st_psd_us = repmat(tempNum, [size(data_st,1) SegN nCh*nSample]);
for nSeg = 1:SegN
    st_psd_us(:, nSeg, :) = permute(mean(permute(data_st_psd(:,(nSeg-1)*div+1 : nSeg*div,:), [2 1 3])), [2 1 3]);
end

NewData = repmat(tempNum, [size(data_st,1) SegN nCh nSample]);
for iCh = 1:nCh
    NewData(:,:,iCh,:) = st_psd_us(:,:,iCh:nCh:end);
end

