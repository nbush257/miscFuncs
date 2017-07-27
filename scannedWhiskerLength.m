function [l_mm,l_pix] = scannedWhiskerLength(im_file_name,varargin)
%% function l_mm = scannedWhiskerLength(im_file_name,[dpi])
% This function takes an image file and computes the whisker arclength in
% pixels and mm.
%%
close all
l_mm = [];
l_pix = [];
%%

I = imread(im_file_name);
info = imfinfo(im_file_name);
if info.XResolution==info.YResolution
    dpi = info.XResolution;
else
    warning('X resolution and Y resolution are inconsistent')
end

imshow(I);
title('place rectangle around whisker, then press enter')
r = imrect();
box = round(r.getPosition);
pause
I_crop = I(box(2):box(2)+box(4),box(1):box(1)+box(3));
level = graythresh(I_crop);

BW = imbinarize(I_crop,level);
BW  = imcomplement(BW);
CC = bwconncomp(BW);

numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
BW2 = BW;
BW2(:) = 0;
BW2(CC.PixelIdxList{idx}) = 1;
BW3 = bwmorph(BW2,'skel',Inf);

CC2 = bwconncomp(BW3);
%
x = floor(CC2.PixelIdxList{1}/CC2.ImageSize(1));
y = mod(CC2.PixelIdxList{1},CC2.ImageSize(1));
%% clean image
imshow(I_crop)
hold on
plot(x,y)
%fix base
zoom on
title('zoom to base and press enter')
pause
title('click to the right of the are to remove')
[x_rm,~] = ginput(1);
title('click on the basepoint')
repl = ginput(1);
rm_idx = x<x_rm;
x = x(~rm_idx);
y = y(~rm_idx);

x = [repl(1);x];
y = [repl(2);y];

rm(1)
plot(x,y)
%% fix tip
figure
imshow(I_crop)
hold on
plot(x,y)
zoom on
title('zoom to the tip, then press enter')
pause
title('click on the tip')
repl = ginput(1);
rm_idx = x>repl(1);
x = x(~rm_idx);
y = y(~rm_idx);

x = [x;repl(1)];
y = [y;repl(2)];

rm(1)
plot(x,y)

l_pix = arclength(x,y); % in pixels
if length(varargin)==1
    dpi = varargin{1};
end
if ~exist('dpi','var')
    dpi = 0;
end

l_in = l_pix/dpi;
l_mm = l_in*25.4;

