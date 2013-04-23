function seg = precomputeSeg(cache, imgfile, opts)

addpath(fullfile(opts.src_dir,'BSR','grouping','lib'));

gPb = cache.get(imgfile, 'gPb');

fprintf('Computing segmentation from gPb...\n');

ucm2 = contours2ucm(gPb.gPb_orient, 'doubleSize');
thresh = unique(ucm2(:));

if numel(thresh) > 200
    thresh = thresh(end-199);
else
    thresh = thresh(1);
end

seg = bwlabel(ucm2<=thresh);
seg = seg(2:2:end,2:2:end);
seg = scalpel.relabelSegs(seg);
fprintf('Computed %d superpixels\n', max(seg(:)));

