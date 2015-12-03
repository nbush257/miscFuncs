%cd /home/auto/Desktop/Graff_Files/
VidNames={'topManual'}



% I wrote this to operate on many videos at once using the parallel
% computing toolbox.
for vidnum=1
    Vid=VideoReader([VidNames{1,vidnum} '.avi']);
    
    Vid_out=VideoWriter([VidNames{1,vidnum} '_deflicker']);
    Vid_out.FrameRate=Vid.FrameRate;
    open(Vid_out);
    
    %This code works in batches of 100 frames at a time.  Basically how it
    %works is it takes 100 frames and makes it into a 3D matrix.  x and y are
    %the x and y positions.  z is time.  I then notch filter the the pixel
    %values through time to take out the flicker frequency.  This method works
    %however sometimes it results in ringing in the images.
    
    % Do the initial 100 frames.
    frame=read(Vid,[1,50]);
    bg=frame(:,:,1,1);
    
    % this is where the notch filtering happens.  I filter out the 3, 6,
    % and 12 hz signals  + or - .2 hz.
    framefft=uint8(notchfft3D(squeeze(frame(:,:,1,:)),Vid.FrameRate,[2.8 5.8 11.8],[3.2 6.2 15]));
    for j=1:73
        writeVideo(Vid_out,framefft(:,:,j));
    end
    
    % Then do the rest.  100 frame chunks but overlapping by 25 frames on
    % either end.
    for i=50:51:Vid.NumberOfFrames-50;
        
        frame=read(Vid,[i,i+50]);
        
        % this is where the rest of the notch filtering happens.  I filter out the 3, 6,
        % and 12 hz signals  + or - .2 hz.
        framefft=uint8(notchfft3D(squeeze(frame(:,:,1,:)),Vid.FrameRate,[2.8 5.8 11.8],[3.2 6.2 15]));
        
        
        for j=25:75
            writeVideo(Vid_out,framefft(:,:,j));
        end
        
        display(['Video ' num2str(vidnum) ' ' num2str(100*(i+100)/(Vid.NumberOfFrames-100)) '%']);
    end
    
    close(Vid_out);
end
