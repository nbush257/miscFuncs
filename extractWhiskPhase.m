function [phase,amplitude] = extractWhiskPhase(theta,sr)
%% function [phase,amplitude] = extractWhiskPhase(theta,sr)
% Uses the hilbert transform to calculate whisking phase as introdecud by
% (Hill 2011, Neuron)
% Uses 6-60Hz bandpass filtering.
% If there are nans it interpolates over 50 ms. 

%% deal with nans in the angle trace
warning('May need a geree to radian conversion')
if any(isnan(theta))
    interpolateWindwow = sr*.05; % interpolate over nan gaps that are less than 50 ms
    theta= InterpolateOverNans(theta,interpolateWindwow);
    
    % If there are nan gaps larger than 50 ms, split those into separate
    % entities.
    if any(isnan(theta))
        disp('Splitting the trace up into several cells based on nan gaps')
        nan_logical = ~isnan(theta);% find where not nan regions are
        nan_logical(1) = 0;nan_logical(end) = 0; % This is a workaround
        nanStart = find(diff(nan_logical)==1)+1;
        nanEnd = find(diff(nan_logical)==-1);
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

for ii = 1:length(theta2)
    
    H = hilbert(theta2{ii});
    if isrow(real(H))
        H = H';
    end
    H = [real(H) imag(H)];
    [phase{ii},amplitude{ii}] = cart2pol(H(:,1),H(:,2));
end

% put the phase and amplitudes back into the original time
phaseOut = nan(length(theta),1);
amplitudeOut = nan(length(theta,1));
for ii = 1:length(nanStart)
    phaseOut(nanStart(ii):nanEnd(ii)) = phase{ii};
    amplitudeOut(nanStart(ii):nanEnd(ii)) = amplitude{ii};
end
    

            