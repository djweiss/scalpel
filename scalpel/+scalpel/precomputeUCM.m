function [segdata] = precomputeUCM(imgfile, opts)

addpath(fullfile(opts.src_dir,'thirdparty', 'BSR','grouping','lib'));

tic
[gPb_orient, gPb_thin, textons] = globalPb(imgfile); %, '', 0.1);
toc
ucm = contours2ucm(gPb_orient, 'imageSize');

segdata = bundle(gPb_orient, gPb_thin, textons, ucm);


