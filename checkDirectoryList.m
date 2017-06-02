function [extra, found] = checkDirectoryList(spec,list)
% use this function to test if the directory has all the data files we
% want, and no extra. This will need to be modified a little for different
% use cases.
%%
d = dir(spec);
d_list = {d.name};
found = false(size(list));
extra = false(size(d_list));
%%
% see if all the expected data have a corresponding data file in the
% directorry
for ii = 1:length(list)
    found(ii) = any(cellfun(@any,strfind(d_list,list{ii})));
end
%% see if all there are any data files that should not be in the directory that are
% no trial suffix
for ii = 1:length(d_list)
    token = regexp(d_list{ii},'^rat\d{4}_\d{2}_[A-Z]{3}\d\d_VG_[A-Z]\d','match');
    extra(ii) = ~any(~cellfun(@isempty,strfind(list,token)));
end
%% With trial suffix
% for ii = 1:length(d_list)
%     token = regexp(d_list{ii},'^rat\d{4}_\d{2}_[A-Z]{3}\d\d_VG_[A-Z]\d_t\d\d','match');
%     extra(ii) = ~any(~cellfun(@isempty,strfind(list,token)));
% end
%