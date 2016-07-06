% auto calibrate

function [I,points] = autoExtractCorners(vFNameTop,vFNameFront,numPts,varargin)
%% function[I,points] = autoExtractCorners(vFNameTop,vFNameFront,numPts,[firstFrame],[lastFrame])
% 
saving = 1;

vTop = seqIo(vFNameTop,'r');

vFront = seqIo(vFNameFront,'r');
info = vTop.getinfo();


if length(varargin) < 2 
    firstFrame = 2;
    lastFrame = info.numFrames;
elseif length(varargin)>2
    error('improper varargin. Too Many input Args')
else
    firstFrame = varargin{1};
    lastFrame = varargin{2};
end

points = struct;
count = 0;
plotting = 1;
plots = figure;
I = struct;
map = hsv(numPts);
for i = firstFrame:50:lastFrame%info.numFrames  
    vTop.seek(i-1);
    Itop = vTop.getframe();
    vFront.seek(i-2);
    Ifront = vFront.getframe();
    tempTop =  detectCheckerboardPoints(Itop);
    tempFront = detectCheckerboardPoints(Ifront);
    if size(tempTop,1)~=numPts | size(tempFront,1)~=numPts
        continue
    end
    count = count+1;
    points(count).frame = i;
    points(count).top = detectCheckerboardPoints(Itop);
    points(count).front = detectCheckerboardPoints(Ifront);
    I(count).top = Itop;
    I(count).front = Ifront;
    if saving
        imwrite(Itop,['top' num2str(count) '.tif']);
        imwrite(Ifront,['front' num2str(count) '.tif']);
    end
    if plotting
        subplot(121)
        image(Itop)
        colormap('gray')
        hold on
        for j = 1:size(points(count).top,1)
            
            if mod(j,2)
                plot(points(count).top(j,1),points(count).top(j,2),'o','MarkerEdgeColor',map(j,:));
                
            else
                plot(points(count).top(j,1),points(count).top(j,2),'*','MarkerEdgeColor',map(j,:));
            end
        end
        
        subplot(122)
        image(Ifront)
        colormap('gray')
        hold on
        
        for j = 1:size(points(count).front,1)
            if mod(j,2)
                plot(points(count).front(j,1),points(count).front(j,2),'o','MarkerEdgeColor',map(j,:));
            else
                plot(points(count).front(j,1),points(count).front(j,2),'*','MarkerEdgeColor',map(j,:));
            end
        end
        
    end
    
    pause(.01)
    cla
end
close all force;

