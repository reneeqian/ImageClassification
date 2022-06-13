[imgSet_balanced] = splitEachLabel(imgSet,min(labelCount.Count));
[trainSets,valSets,testSets] = splitEachLabel(imgSet_balanced,0.5, 0.3, 0.2,'randomized');
trainLabelCount = countEachLabel(trainSets);
valLabelCount = countEachLabel(valSets);
testLabelCount = countEachLabel(testSets);

net = resnet18;
lgraph = layerGraph(net);

newinputlayer = imageInputLayer(lgraph.Layers(1).InputSize,'Normalization','none','Name','Data');
lgraph = replaceLayer(lgraph,lgraph.Layers(1).Name,newinputlayer);

numclasses = numel(unique(imgSet.Labels));
newfullyconnectedlayer = fullyConnectedLayer(numclasses,'Name','myFullyConnectedLayer');
lgraph = replaceLayer(lgraph,lgraph.Layers(end-2).Name,newfullyconnectedlayer);

newclassificationlayer = classificationLayer('Name','myClassificationLayer');
lgraph = replaceLayer(lgraph,lgraph.Layers(end).Name,newclassificationlayer);

inputSize = net.Layers(1).InputSize(1:2);
readfcn = @(x) myImgImportFcn(x,inputSize);
imgSet.ReadFcn = readfcn;
trainSets.ReadFcn = readfcn;
testSets.ReadFcn = readfcn;
valSets.ReadFcn = readfcn;

augmenter = imageDataAugmenter('RandXReflection',true,...
    'RandXTranslation', [-10 10],...
    'RandYTranslation',[-10 10],...
    'RandRotation',[0 180]);
augimds = augmentedImageDatastore(lgraph.Layers(1).InputSize,trainSets,'DataAugmentation',augmenter);

options = trainingOptions('sgdm',...
    'InitialLearnRate',  0.001, ...
    'ValidationData',valSets,...
    'ValidationPatience',5,...
    'Plots', 'training-progress',...
    'ExecutionEnvironment','parallel');