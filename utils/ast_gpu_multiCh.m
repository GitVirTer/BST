
function [st,t,f] = ast_gpu_multiCh(timeseries,minfreq,maxfreq,samplingrate,freqsamplingrate,p)

% This is the S transform wrapper that holds default values for the function.
TRUE = 1;
FALSE = 0;
factor = 1;

% Change to column vector
timeseries_new = reshape(timeseries, [size(timeseries,2),size(timeseries,3)]);

% calculate the sampled time and frequency values from the two sampling rates
t = (0:size(timeseries_new,1)-1)*samplingrate;
spe_nelements =ceil((maxfreq - minfreq+1)/freqsamplingrate);
f = (minfreq + [0:spe_nelements-1]*freqsamplingrate)/(samplingrate*size(timeseries_new,1));

% The actual S Transform function is here:
st = strans(timeseries_new,minfreq,maxfreq,samplingrate,freqsamplingrate,factor,p);


end

function st = strans(timeseries,minfreq,maxfreq,samplingrate,freqsamplingrate,factor,p)

% Compute the length of the data.
n = size(timeseries,1);
original = timeseries;
tempNum = timeseries(1,1,1,1);
nCh = size(timeseries,2);
% dataClass = class(timeseries);
% If vector is real, do the analytic signal

% Compute FFT's
vector_fft=fft(timeseries);
vector_fft=cat(1,vector_fft,vector_fft);


% Preallocate the STOutput matrix
st = repmat(tempNum, [ceil((maxfreq - minfreq+1)/freqsamplingrate), n, size(timeseries, 2)])+1i;
% Compute the mean
% Compute S-transform value for 1 ... ceil(n/2+1)-1 frequency points
if minfreq == 0
    st(1,:,:) = mean(timeseries)*(1&[1:1:n]);
else
    st(1,:,:) = ifft(vector_fft(round(minfreq+1:minfreq+n), :).*g_window(n,round(minfreq),factor,p,tempNum,nCh));
end

% Start loop to increment the frequency point
for i=freqsamplingrate:freqsamplingrate:(maxfreq-minfreq)
    st(round(i/freqsamplingrate)+1,:,:)=ifft(vector_fft(round(minfreq+i)+1:round(minfreq+i)+n, :).*g_window(n,round(minfreq+i),factor,p,tempNum,nCh));
end   

end

%------------------------------------------------------------------------
function gauss=g_window(length,freq,factor,p,tempNum,nCh)

%
vector = repmat(tempNum, [2,length]);
% vector = zeros(2,length);
vector(1,:)=0:length-1;
vector(2,:)=-length:-1;
vector=vector.^2;
vector=vector*(-factor*2*pi^2/(freq/p)^2);
% Compute the Gaussion window
gauss = repmat(sum(exp(vector))', [1 nCh]);

end

