function [f] = getSegFeatureVectors(esp, seg_ind, vals, nf)

nSeg = max(esp(:));
    
f = zeros(nSeg, nf);

% frame_ind = sub2ind(size(esp), round(frames(2,:)), round(frames(1,:)));
% seg_ind = esp(frame_ind);

f_ind = sub2ind(size(f), seg_ind, vals);

f = vl_binsum(f, 1, f_ind);
    