function [frame,samp] = cameraTrigger_proc(triggerAnalog)
%% function a = cameraTrigger_proc(triggerAnalog)
% this function takes the analog signal that datawave reads from the
% trigger and converts it into a binary. Then it spits out vectors that
% tell you what samples occured during what frames.
% assumes a 5V TTL
%%
t1 = triggerAnalog>1000; 
samp = find(diff(t1)==1);% index is frame number, value is sample number where that exposure started.
frame = zeros(size(triggerAnalog));
for ii = 1:length(samp)-1
    frame(samp(ii):samp(ii+1)) = ii;
end
frame(samp(ii+1)+1:end) = ii+1;

