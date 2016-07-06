function [CC,cStart,cEnd] = convertContact(C)
%% function [CC,cEnd,cStart] = convertContact(C)
% returns indices of continue=os stretches of contact(inclusive)
% INPUTS: C, a binary vector of contact. If the vector is not binary, it is
%           converted.
% OUTPUTS:
%       CC: a nx2 matrix of contact onset and offset times (inclusive)
%       cStart: a nx1 vector of just onset times
%       cEnd: a nx1 vector of just offset times
% NEB
%% 

C(isnan(C)) = 0;
C = logical(C);
if isrow(C);C = C';end
ct =[0;C;0];
cStart = find(diff(ct)==1);
cEnd = find(diff(ct)==-1)-1;
CC = [cStart cEnd];
end
