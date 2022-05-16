clearvars;
close all;

%Select the size mode for image processing

% 'same_as_input':Make the output image as large as the input image after two line Gaussian enhancements 
%(achieved by zooming in and filling the input image, see padval for the filling method)

% 'same_as_out': Resize the input image to match the enhanced result.
%The edge part of the enhanced image is also the result of the actual input image enhancement.。
imgSize='same_as_input';
padval='symmetric' ;   

%Line Gaussian core parameter(standard deviation) setting
sigma=5;

%picture set folder according to the actual situation
imagePath = 'Images';

%Select a picture (fits format)

[imgIn, ~] = findimage(imagePath,false,true);


if isempty(imgIn)
    return
end

if strcmpi(imgSize,'same_as_input')
    I=padarray(imgIn,[2*3*sigma,2*3*sigma],padval);    
else
    I=imgIn;
end


pre=preProcess(I,'negative',true,'sigma',1,'debug',false,'medfilt',false);

numLines=180;
[En,Di1]=threadEnhancer(pre,sigma,numLines,'debug',false);
[post,ahisteq]=postProcess(En);
[En2,Di2]=threadEnhancer(post,sigma,numLines,'debug',false);

if strcmpi(imgSize,'same_as_out')
    imgIn=imgIn(2*3*sigma+1:end-2*3*sigma+1,2*3*sigma+1:end-2*3*sigma+1);
end

%Show input image
show(imgIn,'Input Image');
%Show enhanced image
show(En2,'Line Enhanced Image');
%Show direction image
showDirectionImage(Di2,turbo);

