function cache = getCache(opts)

clear cache;
if ~exist(opts.working_dir, 'dir')
    mkdir(opts.working_dir);
end
cache = CFileCache(opts.working_dir, 'imgfile');

cache.register('gPb',@(c,x)scalpel.precomputeUCM(x,opts));
cache.register('seg',@(c,x)scalpel.precomputeSeg(c,x,opts));

% check if training code is installed
if ~isempty(which('train.learnEverything'))
    cache.register('dpm', @(c,x)train.precomputeDPM(c,x,opts));
    cache.register('objness',@(c,x)train.precomputeObjness(c,x,opts));
    cache.register('gPb_boxes',@(c,x)train.precomputeUCMBoxes(c,x,opts));
end