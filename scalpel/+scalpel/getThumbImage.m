function [img] = getThumbImage(img, ar, minsize)

if nargin<3
    minsize = 50;
end
if ar <= 1
    sz = [minsize minsize./ar];
else
    sz = [minsize*ar minsize];
end
%img = imresize_nearest(img, sz);
img = imresize(img, sz, 'nearest');



