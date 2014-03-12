function eqImg = equalize(img, T)

if nargin < 1
    error('no input image specified')
end
img = round((img*255));
eqImg = double(zeros(size(img, 1), size(img, 2)));
plot(img);
lLimit = min(min(img));
rLimit = max(max(img));
range = rLimit - lLimit;

NoP = size(img, 1) * size(img, 2);

alpha = 1.5*NoP/T;  %new alpha value

freq = zeros(256, 1);
probf = zeros(256, 1);
probc = zeros(256, 1);
cum = zeros(256, 1);
output = zeros(256, 1);

for i = 1:size(img, 1)
    for j = 1:size(img, 2)
        value = img(i, j);
        freq(value+1) = freq(value+1) + 1;
        probf(value+1) = freq(value+1)/NoP;
        
    end
end

sum = 0;
bins = min(round(range*(1+alpha)), 256);
ex = round((bins - range)/2);
if(lLimit-ex >= 0 && rLimit+ex <= 255)
    lLimit = lLimit-ex;
elseif (rLimit+ex >255)
    lLimit = lLimit - 2*ex;
end
    
for i = 1:size(probf)   
    sum = sum+freq(i);
    cum(i) = sum;
    probc(i) = cum(i)/NoP;
    output(i) = lLimit + round(probc(i) * bins);
end

for i=1:size(img, 1)
    for j = 1:size(img, 2)
        eqImg(i, j) = output(img(i, j)+1);
    end
end
%eqImg = 10.^eqImg;
eqImg = eqImg/255;
