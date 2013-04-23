function cache = getCache(opts)

clear cache;
if ~exist(opts.working_dir, 'dir')
    mkdir(opts.working_dir);
end
cache = CFileCache(opts.working_dir, 'imgfile');

cache.register('gPb',@(c,x)scalpel.precomputeUCM(x,opts));
cache.register('seg',@(c,x)scalpel.precomputeSeg(c,x,opts));

