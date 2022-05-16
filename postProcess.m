function [imOut,ahisteq] = postProcess(imgIn,gamma)
%postProcess,including CLAHE and top-hat&bot-hat combination transformation

debug=false;

if ~exist('gamma','var')
    gamma=3;
end
imgIn=im2double(imgIn);
% gma=imadjust(imgIn,[],[],gamma1);

ahisteq = adapthisteq(imgIn,'clipLimit',0.10,'Distribution','rayleigh','NBins' ,1024,'NumTiles',round(size(imgIn)/5));
se = strel('square',2);
tben = imsubtract(imadd(ahisteq,imtophat(ahisteq,se)),imbothat(ahisteq,se));

imOut=mat2gray(tben);
gma2=imadjust(imOut,[],[],gamma);
if debug
    
    show(ahisteq,'adaptive histgram equation');
    show(imOut,'tophat and bottomhat'); 
    show(gma2),title('tophat, bottomhat,gamma');
end

