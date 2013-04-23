%% Using SCALPEL code

%% Test setup
try
    v = ver('matlab-utils');
    assert(~isempty(v));
    v = ver('scalpel');
    assert(~isempty(v));
    vl_root;
catch
    error('Your paths are not set up properly. SCALPEL will not work.');
end
%% Step 1 - Set up your input/output path properly.
edit scalpel.config

%% Run on an image from VOC2010 val set.

imgname = '2007_000033';

imgfile = sprintf('./data/%s.jpg', imgname);
img = imread(imgfile);
imshow(img);

opts = scalpel.config;
if ~exist(opts.working_dir, 'dir')
    mkdir(opts.working_dir);
end

