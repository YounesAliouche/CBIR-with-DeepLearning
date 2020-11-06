%                   __  __ ____    ____ _____ ___ ____ 
%                  |  \/  |___ \  / ___|_   _|_ _/ ___|
%                  | |\/| | __) | \___ \ | |  | | |    
%                  | |  | |/ __/   ___) || |  | | |___ 
%                  |_|  |_|_____| |____/ |_| |___\____|


imds = imageDatastore(handles.folder_name, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames'); 
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.7);
TrainedVgg19 = vgg19;
% analyzeNetwork(TrainedVgg19):
TrainedVgg19.Layers(1);
inputSize = TrainedVgg19.Layers(1).InputSize;
if isa(TrainedVgg19,'SeriesNetwork') 
  lgraph = layerGraph(TrainedVgg19.Layers); 
else
  lgraph = layerGraph(TrainedVgg19);
end 
[learnableLayer,classLayer] = findLayersToReplace(lgraph);



numClasses = numel(categories(imdsTrain.Labels));
if isa(learnableLayer,'nnet.cnn.layer.FullyConnectedLayer')
    newLearnableLayer = fullyConnectedLayer(numClasses, ...
        'Name','fc8', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
    
elseif isa(learnableLayer,'nnet.cnn.layer.Convolution2DLayer')
    newLearnableLayer = convolution2dLayer(1,numClasses, ...
        'Name','fc8', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
end

lgraph = replaceLayer(lgraph,learnableLayer.Name,newLearnableLayer);
newClassLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,classLayer.Name,newClassLayer);


figure('Units','normalized','Position',[0.3 0.3 0.4 0.4]);
plot(lgraph)
ylim([0,10])
layers = lgraph.Layers;
connections = lgraph.Connections;

layers(1:10) = freezeWeights(layers(1:10));
lgraph = createLgraphUsingConnections(layers,connections);

pixelRange = [-30 30];
scaleRange = [0.9 1.1];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange, ...
    'RandXScale',scaleRange, ...
    'RandYScale',scaleRange);
augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain, ...
    'DataAugmentation',imageAugmenter);

augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);

options = trainingOptions('sgdm', ...
    'MiniBatchSize',10, ...
    'MaxEpochs',6, ...
    'InitialLearnRate',3e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',3, ...
    'Verbose',false, ...
    'Plots','training-progress');
TrainedVgg19 = trainNetwork(augimdsTrain,lgraph,options);
% [YPred,probs] = classify(TrainedVgg19,augimdsValidation);
% accuracy = mean(YPred == imdsValidation.Labels)
% 
% idx = randperm(numel(imdsValidation.Files),4);
% figure
% for i = 1:4
%     subplot(2,2,i)
%     I = readimage(imdsValidation,idx(i));
%     imshow(I)
%     label = YPred(idx(i));
%     title(string(label) + ", " + num2str(100*max(probs(idx(i),:)),3) + "%");
% end
save TrainedVgg19;

% save TrainedVgg19;
msgbox('opération terminée avec succes');
