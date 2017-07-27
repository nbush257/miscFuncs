function pix_per_mm = checkerboard_pixel_measure(corners,pattern_size,square_size)
%% function checkerboard_pixel_measure(corners,paternsize,squaresize)
% Use this function to take the corner points of an extracted checkerboard
% to get a measure of the pixel to meter conversion.
% ================================================================
% INPUTS:   corners     -    an [Nx2] matrix of corners in pixel space
%           patternsize -    a list [nrows, ncols] indicating number of
%                            internal rows and columns in the pattern
%           squaresize  -    the size of the squares in mm;
% OUTPUTS:  pix_per_mm  -    the mean inter-corner distance in mm
% ================================================================
% NEB 20170712
%% Input checking
plotTGL = false; % in case you want to debug/check
assert(size(corners,2)==2,'corners is not an Nx2 matrix')
assert(prod(pattern_size)==size(corners,1),'pattern size does not match number of corners input');
%% 
num_pts = prod(pattern_size);
D = [];

%% get distances between rows
for ii = 1:pattern_size(1)-1
    idx = [ii:pattern_size(1):num_pts];
    row1 = corners(idx,:);
    row2 = corners(idx+1,:);
    
    if plotTGL
        cla
        plot(corners(:,1),corners(:,2),'o')
        hold on
        plot(row1(:,1),row1(:,2),'g*')
        plot(row2(:,1),row2(:,2),'r*')
        pause
    end
    
    for jj = 1:size(row1,1)
        D = [D pdist([row1(jj,:);row2(jj,:)])];
    end
end
%% get distances between columns
for ii = 1:pattern_size(2)-1
    idx = [(ii-1)*pattern_size(1)+1:(ii)*pattern_size(1)];
    col1 = corners(idx,:);
    col2 = corners(idx+pattern_size(1),:);
    
    if plotTGL
        cla
        plot(corners(:,1),corners(:,2),'o')
        hold on
        plot(col1(:,1),col1(:,2),'g*')        
        plot(col2(:,1),col2(:,2),'r*')
        pause
    end
    
    for jj = 1:size(col1,1)
        D = [D pdist([col1(jj,:);col2(jj,:)])];
    end
end
%% output
pix_per_mm = median(D)/square_size;

