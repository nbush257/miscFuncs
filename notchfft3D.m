function d = notchfft3D(v,rate,fo,f1)

% function d = notchfft3D(v,rate,fo,f1)
% By Brian Rasnow and Chris Assad
% notch fft the depth of matrix v.  v is sampled at rate (Hz)
% The pass band is fo < f & f > f1.
% Hartmann EDA Toolbox v1, December 2004

% mod. 1-19-92, B.R. to take col vectors instead of rows
% mod. 8-28-92 C.A. replaced "length" function with "size"
% mod. 4-11-93 C.A. fixed indexing error 
% mod. 1997 M.H. to take either row or column vectors. 



% [foo,foo2]=size(v);
% if foo==1, 
%     v=v'; 
% end;
n = size(v,3);
ffo = round(fo .* n / rate);
ff1 = round(f1 .* n / rate);
fb = fftn(v);
if fo == 0,
    ffo = -1;
end;
for i=1:length(ffo)
fb(:,:,[ffo(i)+1:ff1(i)+1 n-ff1(i)+1:n-ffo(i)+1]) = ...
    zeros(size(fb(:,:,[ffo(i)+1:ff1(i)+1 n-ff1(i)+1:n-ffo(i)+1])));
end
d = real(ifftn(fb));
