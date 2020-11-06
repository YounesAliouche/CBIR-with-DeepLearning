%                   __  __ ____    ____ _____ ___ ____ 
%                  |  \/  |___ \  / ___|_   _|_ _/ ___|
%                  | |\/| | __) | \___ \ | |  | | |    
%                  | |  | |/ __/   ___) || |  | | |___ 
%                  |_|  |_|_____| |____/ |_| |___\____|

imds = imageDatastore(handles.folder_name, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.9);
numTrainImages = numel(imdsTrain.Labels);
% idx = randperm(numTrainImages,16);
% figure
% for i = 1:16
%     subplot(4,4,i)
%     I = readimage(imdsTrain,idx(i));
%     imshow(I)
% end
net = alexnet;
% analyzeNetwork(net);
inputSize = net.Layers(1).InputSize
layersTransfer = net.Layers(1:end-3);
numClasses = numel(categories(imdsTrain.Labels));
layers = [
    layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];
pixelRange = [-30 30];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange);
augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain, ...
    'DataAugmentation',imageAugmenter);

augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);
options = trainingOptions('sgdm', ...
    'MiniBatchSize',10, ...
    'MaxEpochs',6, ...
    'InitialLearnRate',1e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',3, ...
    'Verbose',false, ...
    'Plots','training-progress');


netTransfer = trainNetwork(augimdsTrain,layers,options);
% [YPred,scores] = classify(netTransfer,augimdsValidation);
% idx = randperm(numel(imdsValidation.Files),4);
% figure
% for i = 1:4
%     subplot(2,2,i)%     I = readimage(imdsValidation,idx(i));
%     imshow(I)
%     label = YPred(idx(i));
%     title(string(label));
% end
% YValidation = imdsValidation.Labels;
% accuracy = mean(YPred == YValidation)
TrainedAlexNet = netTransfer;
% 
save ('TrainedAlexNet.mat');
        
msgbox('op�ration termin�e avec succes');

