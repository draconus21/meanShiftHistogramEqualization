clear
profile on

X = 3;
img_name = 'DSC_0412.jpg';  %enter image file name here
in_img = double(imread(img_name))/255;
in_img = rgb2hsv(in_img);
copy = in_img;
bandwidth = 0.1;
in_imgcpy = in_img;

if(size(in_img,3) == 3)
    in_img = in_img(:, :, X);
    in_img = in_img*255;
    in_img = log10(in_img);
    %in_img = log10((in_img(:,:,X)*255));
else
    in_img = in_img;
end;
copy(:, :, 3) = histeq(in_img);
copy = hsv2rgb(copy);
idx = zeros(3,size(in_img,1)*size(in_img,2))/2;
hr = 2;
hs = 1;

idx(1,:) = repmat((1:size(in_img,1)),1,size(in_img,2))/size(in_img,1)/hr;     %indexOfRow
for ii = 1:size(in_img,1)
    idx(2,(1:size(in_img,2))+(ii-1)*size(in_img,1)) = ii;   % index of column
end;
idx(2,:) = idx(2,:)/size(in_img,2)/hr;
idx(3,:) = (reshape(in_img,[size(in_img,1)*size(in_img,2),1])')/hs;

nPtsPerClust = 250;
nClust  = 4;
totalNumPts = nPtsPerClust*nClust;

clustMed = [];
x = idx;

tic
[clustCent,point2cluster,clustMembsCell] = MeanShiftCluster(x,bandwidth);
toc

y = 0*x(1,:); 

numClust = length(clustMembsCell);
for k = 1:numClust
    myMembers = clustMembsCell{k};
    myClustCen = clustCent(:,k);
    y(myMembers) = myClustCen(3);
end

out_img = reshape(y',[size(in_img,1), size(in_img,2)]);

imshow(out_img);
imwrite(out_img, 'DSC_0412 seg1.jpg');

ll1 = (imread(img_name));
ll1 = (rgb2hsv(ll1));
X = 3;
if size(ll1, 3) == 3
    ll = (ll1(:, :, X));
else 
    ll = (ll1);
end

ll = reshape(ll,  [1, size(ll1, 1)*size(ll1,2)]);
ll2 = ll;
for i = 1:numClust
   myMembers = clustMembsCell{i};
   d = ll;
   d = d(myMembers);
   d = equalize(d, size(ll, 2)); 
   ll(myMembers) = d;
end
ll = reshape(ll, [size(ll1, 1), size(ll1, 2)]);

ll1(:, :, X) = ll;
ll1 = hsv2rgb(ll1);
imshow(ll1);
imwrite(ll1, 'imageHDR.jpg');
