function [SegUnionMask SegIncluded] = getSegGreedyUnionMask(Seg, GTSegMask)

[int area] = scalpel.mex_seg_intarea(Seg, double(GTSegMask), max(Seg(:)));
[~,idx] = sort(int./area,'descend');
mious = cumsum(int(idx))./[sum(GTSegMask(:)) + cumsum(area(idx)-int(idx))];
[~,bestidx ]= max(mious);

SegIncluded = [int./area]>=[int(idx(bestidx))./area(idx(bestidx))];
SegUnionMask = scalpel.mex_seg_union(Seg, double(SegIncluded));