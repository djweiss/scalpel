function opts = config(varargin)
% Edit this to point to where input/outputs should go

defaults.model_file = './data/scalpel_voc2012train_final.mat';
defaults.working_dir = './work'; 
defaults.src_dir = fileparts(which('startup'));

opts = propval(varargin, defaults);
