function fName = overwriteProtection(fName)
%% function fName = overwriteProtection(fName)
% This function is useful if you want to save data to a file, but want to
% be careful not to overwrite a previous file. 
%
% This function looks in the current directory to see if the input fName
% already exists as a file. If it does, it appends a suffix to fName and
% returns a new fName. The function allows for an indefinite number of
% copies, so you will never overwrite a file with the same suffix. e.g. you
% have file 'bob.mat'. you then rerun a function saving to 'bob.mat', but
% don't want to overwrite. this function changes the filename to
% bob(1).mat. If you run the functino again, it will spit out
% bob(2).mat...etc.
%
% If you choose to overwrite, the filename is not changed
%
% INPUTS:       fName - desired filename (generally a file to save to)
% OUTPUTS:      fName - modified filename 
%
% NEB  2016_07_06
%%


if exist(fName,'file')
    fprintf(repmat('=',10,1))
    fprintf('\n')
    
    overwriteTGL = input('File already exists, overwrite? (Y/n)','s');
    overwriteTGL = lower(overwriteTGL);
    if isempty(overwriteTGL)
        overwriteTGL = 'y';
    end
    overwriteTGL = strcmp(overwriteTGL,'y');
    overwrite_iter = 0;
    while ~overwriteTGL
        overwrite_iter = overwrite_iter+1;
        [~,fName,~ ] = fileparts(fName);
        str_idx = regexp(fName,'\(\d\)')-1;
        if isempty(str_idx)
                    fName = sprintf([fName '(%i).mat'],overwrite_iter);
        else
                    fName = sprintf([fName(1:str_idx) '(%i).mat'],overwrite_iter);
        end
        
        overwriteTGL = ~exist(fName,'file');
    end
end    