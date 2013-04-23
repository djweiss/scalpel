% basic matlab utility functions by SW
addpath(pwd);
srcdir = fileparts(which('startup'));

% external dependencies
addpath([srcdir '/matlab-utils']);
addpath([srcdir '/thirdparty/vlfeat-0.9.16/toolbox']); vl_setup;
addpath([srcdir '/thirdparty/features']);

% local dependencies
addpath([srcdir '/scalpel'])

% package based editing
pedit = CFuncEditor([srcdir '/scalpel']);
