% FINDIMAGE - invokes image dialog box for interactive image loading
%
% Usage:  [im, filename] = findimage(disp, c)
%
% Arguments: 
%           disp - optional flag 1/0 that results in image being displayed
%              c - optional flag 1/0 that results in imcrop being invoked 
% Returns:
%             im - image
%       filename - filename of image
%
% See Also: FINDIMAGES

% Peter Kovesi  
% School of Computer Science & Software Engineering
% The University of Western Australia
% http://www.csse.uwa.edu.au/~pk
%
% March 2010

function [im, filename] = findimage(path,disp, c)

    if ~exist('disp','var'),  disp = 0;  end
    if ~exist('c','var'),     c = 0;     end
    if ~exist('path','var'),  path = './';  end
    
    [filename, user_canceled] = imgetfile('InitialPath',path);
    if user_canceled
        im = [];
        filename = [];
        return;
    end
    [~,~,ext] = fileparts(filename);
    if strcmpi(ext,'.fits')
        im=fitsread(filename);
    else
        im = readImg(filename); 
    end
    
    
    
    if c
        fprintf('Crop a section of the image\n')        
        figure(99), clf, [~,rect] = imcrop(imnorm(im)); delete(99)
        im=imcrop(im,rect);
    end
    
    if disp
        show(im,99)
    end
    
     
     