function [seg_phow_id]  = getSegHists(seg, frames, descrs, tree)

phow_id = vlx.get_hikid(descrs, tree);
frames = round(frames);
frame_ind = sub2ind(size(seg), frames(2,:), frames(1,:));
seg_ind = seg(frame_ind);

seg_phow_id = {};
for d = 3:tree.depth
    seg_phow_id{d} = scalpel.getSegFeatureVectors(seg, seg_ind, ...
        phow_id(d,:), tree.maxid(d));
end
