function status = isPar()
%% function status = isPar()
% shortcut to give a logical that tells us if we currently have a parallel
% pool open. % outputs a 1 if there is a pool, a 0 if not.
status = ~isempty(gcp('nocreate'));