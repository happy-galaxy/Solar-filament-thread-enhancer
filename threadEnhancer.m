function [enhancedImg,directionImg]=threadEnhancer(I,varargin)
%threadEnhancer  Enhancement of filamentary structures(solar filament threads) in image
%   [enhancedImg,directionImg]=threadEnhancer(I)Image enhancement with line Gaussian filter with default parameters 
% 	[enhancedImg,directionImg]=threadEnhancer(I,sigma,nLines)
% 	The input image I is enhanced using a line Gaussian filter with a standard deviation of sigma 
%   (default value is 5) and the number of lines sampled is nLines (evenly divided by 180 degrees, default value is 60, i.e., sampled once at 3 degrees)
%   [enhancedImg,directionImg]=threadEnhancer(___,'debug',ture|false)
%   Whether to display debug information
%

p=parseInputs(I,varargin{:});
sigma=p.Results.sigma;
numLines=p.Results.nLines;
debug=p.Results.debug;

[enhancedImg,directionImg] = lineGaussCov(I,sigma,numLines);
% [enhancedImg,directionImg] = lineGaussCov2(I,sigma,numLines);
enhancedImg=imnorm(enhancedImg);
if debug
    figure,montage({I,enhancedImg,imnorm(directionImg)});
end

    function p=parseInputs(img,varargin)
        defaultDebug=false;
        p = inputParser;
        addRequired(p,'img',@(x)validateattributes(x,{'numeric'},{'nonempty'}))
        addOptional(p,'sigma',5,@(x) validateattributes(x,{'numeric'},{'nonnegative'}));
        addOptional(p,'nLines',60,@(x) isnumeric(x)&&isscalar(x) &&x>0&&x<360);
        addParameter(p,'debug',defaultDebug,@(x) islogical(x));
        parse(p,img,varargin{:});
    end

end


% figure,montage({I,G,enhancedImg,imnorm(directionImg)});