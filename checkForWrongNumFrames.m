function checkForWrongNumFrames()

d = dir('*Front_calib.avi');
for d_num = 1:length(d)
    tag = d(d_num).name(1:27);
    d_front = dir([tag 'Front_calib.avi']);
    d_top = dir([tag 'Top_calib.avi']);
    
    tV = VideoReader(d_top(1).name);
    fV = VideoReader(d_front(1).name);
    
    if tV.numberOfFrames-fV.numberOfFrames==1
        fprintf('Top is longer than the Front...Fixing\n')
        removeFirstFrame(d_top(1).name);
    elseif tV.numberOfFrames-fV.numberOfFrames==-1
        fprintf('Front is longer than Top...Fixing\n')
        removeFirstFrame(d_front(1).name);
    elseif tV.numberOfFrames ~= fV.numberOfFrames
        warning('Major frame number discrepancy in %s. Skipping\n',tag)
    else
        fprintf('%s is consistent\n',tag)
    end
end
end






%% remove first frame from avi
function removeFirstFrame(v_name)
% v_name = 'rat2017_13_MAR13_VG_D3_t06_Top_calib.avi';
V = VideoReader(v_name);
w = VideoWriter([v_name(1:end-4) '_cut.avi'],'Grayscale AVI');
w.open();
for ii = 2:V.numberOfFrames
    I =read(V,ii);
    writeVideo(w,I);
end
w.close();
end

