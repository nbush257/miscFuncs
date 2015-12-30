function [phaseOut,amplitudeOut] = extractWhiskPhase(theta,sr)
%% function [phase,amplitude] = extractWhiskPhase(theta,sr)
% Uses the hilbert transform to calculate whisking phase as introdecud by
% (Hill 2011, Neuron)
% Uses 6-60Hz bandpass filtering.
% If there are nans it interpolates over 50 ms.

%% deal with nans in the angle trace

nanStart = 1;
nanEnd = length(theta);
if any(isnan(theta))
    interpolateWindwow = sr*.05; % interpolate over nan gaps that are less than 50 ms
    theta= InterpolateOverNans(theta,interpolateWindwow);
    
    % If there are nan gaps larger than 50 ms, split those into separate
    % entities.
    if any(isnan(theta))
        nan_logical = ~isnan(theta);% find where not nan regions are
        nan_logical = [0 nan_logical  0]; % This allows the find(diff()) to include the first and last indices
        nanStart = find(diff(nan_logical)==1);
        nanEnd = find(diff(nan_logical)==-1)-1;
        % Put each continuous stretch of non-nans into a cell
        for ii = 1:length(nanStart)
            theta2{ii} = theta(nanStart(ii):nanEnd(ii));
        end
        
    end
else
    theta2{1} = theta;
end


%% filter theta from 6 to 60 hz

for ii = 1:length(theta2)
    theta2{ii} = bwfilt(theta2{ii},sr,6,60);
end
%% Apply Hilbert transform and convert into polar coordinates
for ii = 1:length(theta2)
    
    H = hilbert(theta2{ii});
    if isrow(real(H))
        H = H';
    end
    H = [real(H) imag(H)];
    [phase{ii},amplitude{ii}] = cart2pol(H(:,1),H(:,2));
end

%% put the phase and amplitudes back into the original time
% init the vectors as nan the size of the original theta
phaseOut = nan(size(theta));
amplitudeOut = nan(size(theta));

% loop over the cells and put the phase and amp values in the right place.
for ii = 1:length(nanStart)
    phaseOut(nanStart(ii):nanEnd(ii)) = phase{ii};
    amplitudeOut(nanStart(ii):nanEnd(ii)) = amplitude{ii};
end


