function [enhancedImg,directionImg] = lineGaussCov(I,sigma,nLines) 
%Sampling and convolution
assert ( isscalar (sigma ))
assert ( isscalar (nLines ))


% The length of the sample line is 3*sigma*2+1, i.e., 
% halfW is half of the sample line length minus 1
halfW=3*sigma;
[X,Y,thetas]=sampleLines(nLines,halfW);
gaussPatch=lineGaussianPatch(nLines,sigma);
[h,w]=size(I);
enhancedImg=zeros(h-2*halfW,w-2*halfW);
directionImg=zeros(size(enhancedImg));

yen=1;
for y=1+halfW:h-halfW
    xen=1;
    for x=1+halfW:w-halfW        
        imgWin=I(y-halfW:y+halfW,x-halfW:x+halfW);
%         m=mean2(imgWin);
        patch = interp2(imgWin,X,Y);
        covPatch=patch.*gaussPatch;
        sumCov=sum(covPatch,2);
        [intensity,idx]=max(sumCov);
        enhancedImg(yen,xen)=intensity;
        directionImg(yen,xen)=thetas(idx);
        xen=xen+1;
    end
    yen=yen+1;
end

end

