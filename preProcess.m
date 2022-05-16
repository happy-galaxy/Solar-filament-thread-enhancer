function [imgOut] = preProcess(I,varargin)
% preProcess,including image flipping, median filtering, background illumination unevenness correction and image normalization
% [imgOut] = preProcess(I)  
% [imgOut] = preProcess(I,factor,sigma),
% factor:Laplace sharpening factor, default value is 5
% sigma: Gaussian blur, standard deviation default value is 1
% [imgOut] = preProcess(___,'name', value)
% name£ºvalue
% medfilt£ºtrue|flase Whether to perform median filtering, default false
% illuminationCorrection£ºtrue|flase Whether to correct for uneven background lighting, default true
% negative£ºtrue|flase Whether to flip the image pixel intensities, default false
% diffusefilt£ºtrue|flase Whether to perform diffusion filtering, default false
% debug£ºtrue|flase Whether to show debug information, default false

p=parseInputs(I,varargin{:});
factor=p.Results.factor;
sigma=p.Results.sigma;
iluCrct=p.Results.illuminationCorrection;
negative=p.Results.negative;
medfilt=p.Results.medfilt;
dif=p.Results.diffusefilt;
debug=p.Results.debug;

I=mat2gray(I);
if negative
    Neg=imcomplement(I);
else
    Neg=I;
end
if medfilt
    med=medfilt2(Neg);
else
    med=Neg;
end
if iluCrct
    [norm,background]= normBackground(med);
else
    norm=imnorm(med);
end


lapls= laplacianEnhance(norm,factor);

imgauss = mat2gray(imgaussfilt(lapls,sigma,'FilterDomain','spatial'));

if dif
    [gradientThreshold,numberOfIterations] = imdiffuseest(imgauss);
    imgOut = imdiffusefilt(imgauss,'GradientThreshold',gradientThreshold,'NumberOfIterations',numberOfIterations);
else
    imgOut=imgauss;
end

if debug
    show(I);
    if negative
        show(Neg);
    end
    if medfilt
        show(med);
    end
    if iluCrct
        show(norm);
        show(background);
    end
    if dif
        show(imgauss);
    end
    show(lapls);
    show(imgOut);
end
        


    function p=parseInputs(img,varargin)        
        p = inputParser;
        addRequired(p,'img',@(x)validateattributes(x,{'numeric'},{'nonempty'}))
        addOptional(p,'factor',5,@(x) validateattributes(x,{'numeric'},{'nonnegative'}));
        addOptional(p,'sigma',1,@(x) validateattributes(x,{'numeric'},{'nonnegative'}));
        addParameter(p,'medfilt',false,@(x) islogical(x));
        addParameter(p,'illuminationCorrection',true,@(x) islogical(x));
        addParameter(p,'negative',false,@(x) islogical(x));
        addParameter(p,'diffusefilt',false,@(x) islogical(x));
        addParameter(p,'debug',false,@(x) islogical(x));
        parse(p,img,varargin{:});
    end
end

