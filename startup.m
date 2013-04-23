addpath(pwd);
srcdir = fileparts(which('startup'));

% external dependencies
addpath([srcdir '/matlab-utils']);
addpath([srcdir '/thirdparty/vlfeat-0.9.16/toolbox']); vl_setup;
addpath([srcdir '/thirdparty/features']);
addpath([srcdir '/thirdparty/liblinear']);

% local dependencies
addpath([srcdir '/scalpel'])

% package based editing
pedit = CFuncEditor([srcdir '/scalpel']);

% some basic test of paths
try
    v = ver('matlab-utils');
    assert(~isempty(v));
    v = ver('scalpel');
    assert(~isempty(v));
    vl_root;
catch
    error('Your SCALPEL paths are not set up properly. SCALPEL will not work.');
end