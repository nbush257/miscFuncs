function [analogData,trigger,sr,rawAnalogData,time] = importAnalogDDF(varargin)


if length(varargin) == 2
    filename = varargin{1};
    inChan = varargin{2};
elseif length(varargin) ==1
    filename =varargrin{1}
end

result = ns_SetLibrary('C:\DataWave\DWShared\nsDWFile64.dll');
if length(varargin)==0
    [fName,pName] = uigetfile('*.ddf');
    filename = [pName fName];
end
[result,handle] = ns_OpenFile(filename);
[result,fileInfo] = ns_GetFileInfo(handle);
entityCount = fileInfo.EntityCount;
[result, entityInfo] = ns_GetEntityInfo(handle, [1:entityCount]);
% events are markers
eventIdx = find([entityInfo.EntityType]==1 & [entityInfo.ItemCount]~=0);
if ~isempty(eventIdx)
    for i=1:length(eventIdx)
        [result,eventInfo] = ns_GetEventInfo(handle,eventIdx);
        [result, eventTS{i}, eventData{i}, eventDataSize{i}] = ns_GetEventData(handle,eventIdx(i),1:entityInfo(eventIdx).ItemCount);
    end
end
trigger = eventTS;
%% analog traces
analogIdx = find([entityInfo.EntityType]==2);
if ~isempty(analogIdx)
    analogName = {entityInfo(analogIdx).EntityLabel};
    
    [result, analogInfo] = ns_GetAnalogInfo(handle,[analogIdx]);
    
    
    mappingDisp = {entityInfo.EntityLabel}';
    for i = 1:length(mappingDisp)
        mappingDisp{i,2} = i;
    end
    if length(varargin) ~=2
        mappingDisp
    end
    if length(varargin)<2
        inChan = input('Type the entity numbers of the channels you want to load in a [1xN] array');
    end
    if range([entityInfo(inChan).ItemCount]) ==0
        contDataLength = mean([entityInfo(inChan).ItemCount]);
    else
        disp('Continuous data is not all the same length');
        pause
    end
    
    analogData = struct;
    for c = 1:length(inChan)
        [result, ~, rawAnalogData(:,c)] = ns_GetAnalogData(handle,inChan(c),1,contDataLength);
        
        chanName = entityInfo(inChan(c)).EntityLabel;
        
        thisChan = strrep(chanName,' ', '_');
        analogData.(thisChan) = rawAnalogData(:,c);
    end
end
% get time vector
[~,time] = ns_GetTimeByIndex(handle,inChan(1),1:contDataLength);
ns_CloseFile(handle);
sr = analogInfo(1).SampleRate;