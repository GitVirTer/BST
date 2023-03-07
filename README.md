# BST: A tool for batch processing of S-transform v1.0

This paper presents a batch processing implementation of S-transform named BST to boost the efficiency of algorithms that frequently compute S-transform. The proposed BST supports GPU acceleration and CPU vectorization acceleration based on MATLAB, which can achieve approximately 12x and 5x acceleration compared to vanilla S-transform, respectively. Besides, the designed BST can also be embedded into deep neural network and combined with online augmentation strategy to enhance the model performance. Additionally, a horizontal squeeze operation is supported for BST that can realize dimensionality reduction.

## Citation

Please cite the tool using this website repository and the manuscript:

-	Guoyang Liu, Weidong Zhou, and Minxing Geng. "Automatic Seizure Detection Based on S-Transform and Deep Convolutional Neural Network." International journal of neural systems 30, no. 04 (2020): 1950024. https://doi.org/10.1142/S0129065719500242 
-	Guoyang Liu, Xiao Han, Lan Tian, Weidong Zhou, and Hui Liu. "ECG Quality Assessment Based on Hand-Crafted Statistics and Deep-Learned S-Transform Spectrogram Features." Computer Methods and Programs in Biomedicine 208 (2021): 106269. https://doi.org/10.1016/j.cmpb.2021.106269 
-	Minxing Geng, Weidong Zhou, Guoyang Liu, Chaosong Li, and Yanli Zhang. "Epileptic Seizure Detection Based on Stockwell Transform and Bidirectional Long Short-Term Memory." IEEE Transactions on Neural Systems and Rehabilitation Engineering 28, no. 3 (2020): 573-80. https://doi.org/10.1109/TNSRE.2020.2966290 

## Operating Environments and Dependencies

System:
- Windows 7 and later

Software:
- MATLAB R2019b and later releases

## Adjustable Hyperparameters

- sqzSize = 8;                    % Squeeze size (pooling size) along time axis
- outputMode = 'phase';           % Output method ('amplitude', 'psd', 'phase', 'amplitude+phase', 'psd+phase')
- selFreqRange = [1,50];          % Frequency range (Hz)
- freqPrecision = 1;              % Frequency domain resolution
- waveletName = 'db4';            % Wavelet name
- gaussianFactor = 0.5;           % p-value of generalized S-transform to ajust the Gaussian window shape

## Author

Guoyang Liu: gyangliu@hku.hk

