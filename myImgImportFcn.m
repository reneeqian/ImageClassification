function img = myImgImportFcn(filename,inputSize)
img = imread(filename);
if size(img,3)~=3
    img = repmat(img,[1,1,3]);
end
img = imresize(img,inputSize);
end