function [ar_idx ar_orig] = getBBoxARCluster(bbox, ar_c)

width = bbox(3) - bbox(1);
height = bbox(4) - bbox(2);
ar_orig = height/width;

ardists = abs(ar_orig - ar_c);
[~,ar_idx] = min(ardists);

