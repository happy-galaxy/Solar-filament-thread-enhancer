function  gaussPatch=lineGaussianPatch(numLines,sigma)

width=2*3*sigma+1;
% lineGauss=gausswin(width,3);
% lineGauss=zeros(1,width);
n=1:width;
n=n-(3*sigma+1);
lineGauss=exp(-(n.^2)./(2*(sigma^2)));
lineGauss=lineGauss/(sqrt(2*pi)*sigma);
gaussPatch=zeros(numLines,width);
for i=1:numLines
    gaussPatch(i,:)=lineGauss;
end

