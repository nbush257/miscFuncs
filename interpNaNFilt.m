function xOut = interpNaNFilt (x,sr,lp)
if isrow(x);x = x';end
xOut = NaN(size(x));
cpt = ~isnan(x); % first find where it is not a NaN
ccomp = [0; cpt; 0]; % add these for easier diffing (and force first frame to be a start)
difc = diff(ccomp);
whstart = find(difc == 1);  % mark where all whisks START
whend = find(difc == -1) - 1; % mark where all whisks END
nwhisks = length(whstart); % how many whisks are there
for ii = 2:nwhisks
    if whstart(ii)-whend(ii-1)<30 
        x(whend(ii-1)+1:whstart(ii)-1) = interp1([whend(ii-1) whstart(ii)],[x(whend(ii-1)) x(whstart(ii))],whend(ii-1)+1:whstart(ii)-1);
    end
end
for ii = 1:nwhisks
    inds = whstart(ii):whend(ii);
    if length(inds)<=6
        continue
    end
    xOut(inds) = bwfilt(x(inds),sr,0,lp);% this was filtered at 85 Hz for data taken at 1000 Hz
end