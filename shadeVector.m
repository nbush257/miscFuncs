function shadeVector(C)
%% function shadeVector(C)
% =======================
% This function takes a binary vector and shades X values where the binary vector is true. 
% Designed to be used to take a contact binary and shade during contact
% periods. 
% ======================
% NEB 2016_06

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
if ~isvector(C)% if the input is already converted from a binary vector to onsets, then skip conversion
    
    % Check input to make sure that the first column is starts and second
    % column is ends
    if size(C,2)~=2
        C = C';
    end
    if size(C,2)~=2
        error('neither dimension if the input matrix has dimension 2')
    end
       
    cStart = C(:,1);
    cEnd = C(:,2);
    if ~all(cStart<cEnd)
        error('some contacts end before they begin')
    end
           
    % shade the figure    
    for ii = 1:length(cStart)
        fill([cStart(ii) cStart(ii) cEnd(ii) cEnd(ii)],[ax.YLim(1) ax.YLim(2) ax.YLim(2) ax.YLim(1)],'k','facealpha',.2,'edgecolor','none')
    end
else %% if the input is a vector, convert to diffs then shade
    
    C(isnan(C)) = 0;
    if ~islogical(C)
        C = logical(C);
    end
    if iscolumn(C);C = C';end % convert to row vector
    
    C = [0 C 0];
    cStart = find(diff(C)==1);
    cEnd = find(diff(C)==-1)-1;
    
    for ii = 1:length(cStart)
        fill([cStart(ii) cStart(ii) cEnd(ii) cEnd(ii)],[ax.YLim(1) ax.YLim(2) ax.YLim(2) ax.YLim(1)],'k','facealpha',.2,'edgecolor','none')
    end
end