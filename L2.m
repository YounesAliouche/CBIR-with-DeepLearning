%                   __  __ ____    ____ _____ ___ ____ 
%                  |  \/  |___ \  / ___|_   _|_ _/ ___|
%                  | |\/| | __) | \___ \ | |  | | |    
%                  | |  | |/ __/   ___) || |  | | |___ 
%                  |_|  |_|_____| |____/ |_| |___\____|

function L2(numOfReturnedImages, queryImageFeatureVector, dataset, metric)
% input:
%   numOfReturnedImages : num of images returned by query
%   queryImageFeatureVector: query image in the form of a feature vector
%   dataset: the whole dataset of images transformed in a matrix of
%   features
%
% output:
%   plot: plot images returned by query

% extract image fname from queryImage and dataset
query_img_name = queryImageFeatureVector(:, end);
dataset_img_names = dataset(:, end);

queryImageFeatureVector(:, end) = [];
dataset(:, end) = [];

euclidean = zeros(size(dataset, 1), 1);

if (metric == 1)
    % compute euclidean distance
    for k = 1:size(dataset, 1)
        euclidean(k) = sqrt( sum( power( dataset(k, :) - queryImageFeatureVector, 2 ) ) );
    end
elseif (metric == 3)
    % compute standardized euclidean distance
    weights = nanvar(dataset, [], 1);
    weights = 1./weights;
    for q = 1:size(dataset, 2)
        euclidean = euclidean + weights(q) .* (dataset(:, q) - queryImageFeatureVector(1, q)).^2;
    end
    euclidean = sqrt(euclidean);
elseif (metric == 4) % compute mahalanobis distance
    weights = nancov(dataset);
    [T, flag] = chol(weights);
    if (flag ~= 0)
        errordlg('The matrix is not positive semidefinite. Please choose another similarity metric!');
        return;
    end
    weights = T \ eye(size(dataset, 2)); %inv(T)
    del = bsxfun(@minus, dataset, queryImageFeatureVector(1, :));
    dsq = sum((del/T) .^ 2, 2);
    dsq = sqrt(dsq);
    euclidean = dsq;
elseif (metric == 5)
    euclidean = pdist2(dataset, queryImageFeatureVector, 'cityblock');
elseif (metric == 6)
    euclidean = pdist2(dataset, queryImageFeatureVector, 'minkowski');
elseif (metric == 7)
    euclidean = pdist2(dataset, queryImageFeatureVector, 'chebychev');
elseif (metric == 8)
    euclidean = pdist2(dataset, queryImageFeatureVector, 'cosine');
elseif (metric == 9)
    euclidean = pdist2(dataset, queryImageFeatureVector, 'correlation');
elseif (metric == 10)
    euclidean = pdist2(dataset, queryImageFeatureVector, 'spearman');
elseif (metric == 11)
    % compute normalized euclidean distance
    for k = 1:size(dataset, 1)
        euclidean(k) = sqrt( sum( power( dataset(k, :) - queryImageFeatureVector, 2 ) ./ std(queryImageFeatureVector) ) );
    end
end

% add image fnames to euclidean
euclidean = [euclidean dataset_img_names];

% sort them according to smallest distance
[sortEuclidDist indxs] = sortrows(euclidean);
sortedEuclidImgs = sortEuclidDist(:, 2);

% clear axes
arrayfun(@cla, findall(0, 'type', 'axes'));

% display query image
str_name = int2str(query_img_name);
query_img = imread( strcat('images\', str_name, '.jpg') );
subplot(3, 7, 1);
imshow(query_img, []);
title('l’image de requête', 'Color', [1 0 0]);
[rowsA colsA numberOfColorChannelsA] = size(query_img);







% dispaly images returned by query
A = zeros(1);
Accuracy=0;
Sensitivity=0;
Fmeasure=0;
 Precision=0;
 MCC=0;
Dice=0;
 Jaccard=0;
 Specitivity=0;
for m = 1:numOfReturnedImages
    img_name = sortedEuclidImgs(m);
    img_name = int2str(img_name);
    str_img_name = strcat('images\', img_name, '.jpg');
    returned_img = imread(str_img_name);
    subplot(3, 7, m+1);
    imshow(returned_img, []);
    title(img_name, 'Color', [1 0 0]);
    returned_img = imresize(returned_img, [rowsA colsA]);

    
    
    
    
   c = EvaluateImageSegmentationScores(query_img, returned_img);
%  c=Evaluate(query_img ,returned_img );

 Accuracy= Accuracy + c(1,1);
 Sensitivity=Sensitivity + c(1,2);
 Fmeasure=Fmeasure + c(1,3);
 Precision=Precision + c(1,4);
 MCC=MCC + c(1,5);
 Dice=Dice + c(1,6);
 Jaccard=Jaccard + c(1,7);
 Specitivity=Specitivity + c(1,8);
for n = 1:8
  A(m,n)=c(1,n) ;    
end

end
Accuracy= Accuracy /numOfReturnedImages;
 Sensitivity=Sensitivity/ numOfReturnedImages;
 Fmeasure=Fmeasure /numOfReturnedImages;
 Precision=Precision/ numOfReturnedImages;
 MCC=MCC /numOfReturnedImages;
 Dice=Dice /numOfReturnedImages;
 Jaccard=Jaccard/ numOfReturnedImages;
 Specitivity=Specitivity/numOfReturnedImages;
 C = zeros(1);

C(1,1)=Accuracy;
C(1,2)=Sensitivity;
C(1,3)=Fmeasure;
C(1,4)=Precision;
C(1,5)=MCC;
C(1,6)=Dice;
C(1,7)=Jaccard;
C(1,8)=Specitivity;

Tt = array2table(A);
Tt.Properties.VariableNames(1:8) = {'Accuracy', 'Sensitivity', 'Fmeasure', 'Precision', 'MCC', 'Dice', 'Jaccard', 'Specitivity'}
writetable(Tt,'result.csv')

TtMoy = array2table(C);
TtMoy.Properties.VariableNames(1:8) = {'Accuracy', 'Sensitivity', 'Fmeasure', 'Precision', 'MCC', 'Dice', 'Jaccard', 'Specitivity'}
writetable(TtMoy,'RsMoy.csv')
end