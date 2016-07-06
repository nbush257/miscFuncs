%import ddf file This requires all NProbe analysis labels to be TTX, where
%0<X<10. It also requires the analog channel labels to be: 'channel X'
clearvars -except mapping mappingDisp templateWaveforms

neuralynx={'TT1',{'channel 24','channel 26','channel 28','channel 31'};
    'TT2',{'channel 16','channel 18','channel 20','channel 22'};
    'TT3',{'channel 8','channel 10','channel 12','channel 14'};
    'TT4',{'channel 0','channel 2','channel 4','channel 6'};
    'TT5',{'channel 25','channel 27','channel 29'};
    'TT6',{'channel 17','channel 19','channel 21','channel 23'};
    'TT7',{'channel 9','channel 11','channel 13','channel 15'};
    'TT8',{'channel 1','channel 3','channel 5','channel 7'};
    };

manualArtRemoved = {'TT3',{'channel 0','channel 1','channel 2', 'channel 3'}};

% Alter this line to set your dll path
result = ns_SetLibrary('C:\DataWave\DWShared\nsDWFile64.dll');

[fName,pName] = uigetfile('*.ddf');


[result,handle] = ns_OpenFile([pName fName]);
[result,fileInfo] = ns_GetFileInfo(handle);
entityCount = fileInfo.EntityCount;
[result, entityInfo] = ns_GetEntityInfo(handle, [1:entityCount]);
% get digital input DIGITAL INPUT LABEL MUST BE 'Digital Input (1)'!!!!!
eventIdx = find(strcmp({entityInfo.EntityLabel},'Digital Input (1)'));
if ~isempty(eventIdx)
    for i=1:length(eventIdx)
        [result,eventInfo] = ns_GetEventInfo(handle,eventIdx);
        [result, eventTS{i}, eventData{i}, eventDataSize{i}] = ns_GetEventData(handle,eventIdx(i),1:entityInfo(eventIdx).ItemCount);
    end
    
    %save only the times where digital in == 1 and does that in samples, not
    %time.
    digTimes = eventTS{1};
    digVal = eventData{1};
    frameCapTimes = digTimes(digVal==1);
    frameCapSamps = zeros(size(frameCapTimes));
    
    clear digTimes;
    clear digVal;
end

%% analog traces
analogIdx = find([entityInfo.EntityType]==2);
[result, analogInfo] = ns_GetAnalogInfo(handle,[analogIdx]);
%Removes digital fitlere traces by removeing anything with digital in the probe name
filtered = strfind({analogInfo.ProbeInfo},'Digital');
for ii = 1:length(filtered)
    if isempty(filtered{ii})
        filtered{ii} = 0;
    end
end

not_filtered = find(~cell2mat(filtered));
analogIdx = analogIdx(not_filtered);

%Keeps only the analog information that is the longest length.
analogName = {entityInfo(analogIdx).EntityLabel};


analogLength = [entityInfo(analogIdx).ItemCount];
longest = max(analogLength);
contDataLength = longest;
analogIdx = analogIdx(analogLength==longest);
%analogInfo = analogInfo(analogIdx);



%Gets the analog Data

%comment this line if you want all the analog traces
%analogIdx = analogIdx(1);disp('Only reading in one analog trace for the sake of memory. Change this line if you want all traces');
if ~isempty(analogIdx)
    
    
    [result, ~, rawAnalogData] = ns_GetAnalogData(handle, analogIdx,1,longest);
    analogData = struct;
    chanName = {entityInfo(analogIdx).EntityLabel};
    for ent = 1:length(analogIdx)
        thisChan = strrep(chanName{ent},' ', '_');
        analogData.(thisChan) = rawAnalogData(:,ent);
    end
    sr = analogInfo(1).SampleRate;
    [~,time] = ns_GetTimeByIndex(handle,analogIdx,1:longest);
    if ~isempty(eventIdx)
        for ii = 1:length(frameCapTimes)
            try
                [result,frameCapSamps(ii)] = ns_GetIndexByTime(handle,analogIdx(1),frameCapTimes(ii),0);
            catch
                disp(['stopped comparing frames to samples at frame ' num2str(ii)]);
            end
            
        end
    end
end
%% get tetrode info-Currently can't extract spike waveforms via this method. Gets info about the tetro I think the datawave dll file is the problem. Trying to use ns_GetSegmentData always crashes matlab.
disp('getting spike data')
trodeIdx = find([entityInfo.EntityType]==3);
if ~isempty(trodeIdx)
    trodeName = {entityInfo(trodeIdx).EntityLabel};
    if ~isempty(trodeName)
        [result, segmentInfo] = ns_GetSegmentInfo(handle,[trodeIdx]);
        
        [result,segmentSourceInfo] = ns_GetSegmentSourceInfo(handle,[trodeIdx],[zeros(1,length(trodeIdx)):[segmentInfo.SourceCount]-1]);
        numSource  = length(trodeIdx);
    end
end
%% Get ts of sorted waveforms
disp('getting timestamps');

unitIdx = find([entityInfo.EntityType]==4);
if ~isempty(unitIdx)
    [result,neuralInfo] = ns_GetNeuralInfo(handle,[unitIdx]);
    spikeTimes = struct;
    unitName = {entityInfo(unitIdx).EntityLabel};
    for unit = 1:length(unitIdx)
        thisUnit = strrep(unitName{unit},'/','');
        thisUnit = strrep(thisUnit,' ','_');
        [result, neuralData] = ns_GetNeuralData(handle,unitIdx(unit),1,[entityInfo(unitIdx(unit)).ItemCount]);
        
        spikeTimes.(thisUnit) = neuralData;
        
    end
    %% get mapping
    %     %changeMapping = 'y';
    %     %NEED TO BUILD A MAPPING PROFILE
    %
    %     mapping = {'TT1',67;'TT1',64;'TT1',62;'TT1',60;'TT2',58;'TT2',56;'TT2',54;'TT2',52;'TT3',44;'TT3',46;'TT3',48;'TT3',50;'TT6',53;'TT6',55;'TT6',57;'TT6',59;'TT7',51;'TT7',49;'TT7',47;'TT7',45;'TT8',37;'TT8',39;'TT8',41;'TT8',43};
    %
    %     if exist('mapping')
    %         clc
    %         if exist('mappingDisp')
    %             mappingDisp
    %         else
    %             mapping
    %         end
    %
    %         changeMapping = input('Do you want to change the mapping? [y/n]','s')
    %     end
    %     if strcmp(changeMapping,'y')
    %         mappingDisp = {entityInfo.EntityLabel}';
    %         for i = 1:length(mappingDisp)
    %             mappingDisp{i,2} = i;
    %         end
    %
    %         for i = 1:prod(size(segmentSourceInfo));
    %             clc
    %             startName = strfind(segmentSourceInfo(i).ProbeInfo,'/')+1;
    %             pName = segmentSourceInfo(i).ProbeInfo(startName:end);
    %             mapping{i,1} = pName;
    %             mappingDisp
    %             mapping{i,2} = input(['Input an entity number for the analog channel on: ' pName]);
    %             mappingDisp{mapping{i,2},2} = pName;
    %             clc
    %             mappingDisp
    %             %maybe add a functionality to redo the mapping here?
    %         end
    %     end
    
    %% Extract Spike Shapes
    warning('Hotfixing this to skip importing spike shapes')
    if 0
        % filter the analog data
        filtAnalog = analogData;
        fNames = fieldnames(filtAnalog);
        for i =1:length(fNames)
            filtAnalog.(fNames{i})=bwfilt(filtAnalog.(fNames{i}),sr,300,8000);
        end
        
        % Extract the spikes
        if 0
            spikes = struct;
            spikesSamples = struct;
            preWin = 40;
            postWin = 40;
            mapping = neuralynx;%hardcoded mapping for the neuralynx EIB-36PTB
            % mapping = manualArtRemoved; disp('Using manual mapping override');%hardcoded for manually removing artifacts.
            
            
            for i = 1:length(unitIdx)
                slashIdx = strfind(neuralInfo(i).ProbeInfo,'/')+1;
                underscoreIdx = strfind(neuralInfo(i).ProbeInfo,'_')-1;
                dum1 =  strcmp([neuralInfo(i).ProbeInfo(slashIdx:underscoreIdx)],[mapping]);%generalized this string operation. If it's buggy try to generalize a different way. Right now it takes anything after the /
                dum1 = dum1(:,1);
                thisUnit = strrep(unitName{i},'/','');
                thisUnit = strrep(thisUnit,' ','_');
                chanInfo.(thisUnit) = mapping{dum1,2};
            end
            
            for i  = 1:length(unitIdx)% for each unit
                
                thisUnit = strrep(unitName{i},'/','');
                thisUnit = strrep(thisUnit,' ','_');
                theseChan = chanInfo.(thisUnit);
                
                numChans = length(chanInfo.(thisUnit));
                numSpikes = length(spikeTimes.(thisUnit));
                spikes.(thisUnit) = nan(numChans,preWin+postWin+1,numSpikes);
                spikeSamples.(thisUnit) = nan(numChans,numSpikes);
                %convert channel name into entity number
                for j =1:length(theseChan)
                    tempEntity = find(strcmp({entityInfo.EntityLabel},theseChan{j}));% only keeps the entity label from the raw analog trace, not any other analog traces with the same label.
                    theseEntity(j)= intersect(tempEntity,analogIdx);% try canging the mapping if this throws an error.
                end
                %extract spike shapes
                for j = 1:numSpikes
                    count = 0;
                    for c = theseEntity
                        count = count+1;
                        [result,samp] = ns_GetIndexByTime(handle,theseEntity(count),spikeTimes.(thisUnit)(j),0);
                        if result ~= 0
                            disp(['Problem getting sample index for spike number ' int2str(j) ' on channel ' int2str(c)]);
                        else
                            if (samp+postWin)>contDataLength || (samp-preWin)<1
                                disp(['There was a spike that occurred within ' int2str(preWin) ' samples of the trace beginning or ' int2str(postWin) ' samples of the end. Ignoring.']);
                            else
                                chan = strrep(entityInfo(theseEntity(count)).EntityLabel,' ','_');
                                spikes.(thisUnit)(count,:,j) = filtAnalog.(chan)(samp-preWin:samp+postWin);
                                spikeSamples.(thisUnit)(count,j) = samp;
                            end
                            
                        end
                    end
                    
                end
                
            end
        end
    end
    
end

%% Clean up

ns_CloseFile(handle)
clear mexprog; clear analogIdx; clear analogName;
clear ans;
clear c;
clear dum1;
clear ent;
clear entityCount;
%clear fName;
clear i;
clear j;
clear neuralData;
clear numChans;
clear numSource;
clear numSpikes;
%clear pName;
clear postWin;
clear preWin;
clear result;
clear samp;
clear theseChan;
clear thisChan;
clear thisUnit;
clear trodeIdx;
clear trodeName;
clear unit;
clear unitIdx;
clear unitName;
clear analogLength;
clear longest;
clear filtered;
clear count;
clear not_filtered;

sav = input('do you want to save the file? [y/n]','s');

outname = [pName 'MDF_' fName(1:end-3) '.mat'];

if strcmp(sav,'y')
    save(outname,'-v7.3');
end
clear outname;
clear sav;
clear slashIdx;

clear ii;
clear underscoreIdx;




