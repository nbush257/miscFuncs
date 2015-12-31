function shadeVector(C)
%% function shadeVector(C)
% This function takes a binary vector and shades X values where the binary vector is true. 
% Designed to be used to take a contact binary and shade during contact
% periods. 

ax = gca;
C(isnan(C)) = 0;
if ~islogical(C)
    C = logical(C);
end

C(1) = 0;
C(end) = 0;
cStart = find(diff(C)==1)+1;
cEnd = find(diff(C)==-1);
ho
for ii = 1:length(cStart)
    fill([cStart(ii) cStart(ii) cEnd(ii) cEnd(ii)],[ax.YLim(1) ax.YLim(2) ax.YLim(2) ax.YLim(1)],'k','facealpha',.5,'edgecolor','none')
end