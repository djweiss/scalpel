function [example] = getLocalizedPrior(example, shape, bbox)

example.prior = zeros(size(example.seg)); b = ceil(bbox);
b(b==0) = 1;

b(4) = min(b(4), rows(example.seg));
b(3) = min(b(3), cols(example.seg));
example.prior(b(2):b(4)-1, b(1):b(3)-1) = imresize_nearest(shape, bb.size(b));
%example.prior(b(2):b(4)-1, b(1):b(3)-1) = imresize(shape, bb.size(b), 'nearest');

[int area] = scalpel.mex_seg_intarea(example.seg, example.prior, example.nSeg);
example.seg_prior = int./area; 
example.seg_size = area;
    