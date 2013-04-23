%% Using SCALPEL tutorial

%% Set up the configuration for input/output/working dir as desired.
edit scalpel.config

%% Load the demo input to SCALPEL.
imgname = '2007_000033';

% Load the image
imgfile = sprintf('./data/%s.jpg', imgname);
img = imread(imgfile);
imshow(img);

% Load the bounding boxes from the paper for this image
boxes = loadvar(sprintf('./data/boxes/%s.mat',imgname));
hold on;
bb.plot(boxes(1:10:end,:));
hold off;
title('Sample of bounding box inputs');

%% Run SCALPEL
opts = scalpel.config; % Make sure working directory exists
if ~exist(opts.working_dir, 'dir')
    mkdir(opts.working_dir);
end

t0 = tic;
proposals = scalpel.segmentImage(imgfile, boxes);
fprintf('Total processing time: %s\n', sec2timestr(toc(t0)));

%% Evaluate SCALPEL 

objimg = imread(sprintf('./data/%s_obj.png', imgname));
objidx = unique(objimg(:));
objidx = objidx(objidx>0&objidx<255);

for j = 1:numel(objidx)
    j
    obj = objimg==j;

    iou = [];
    for k = 1:size(proposals,3)
        iou(k) = scalpel.iou(obj, proposals(:,:,k).*[objimg~=255]);
    end
    
    [iou, best] = max(iou);
    figure(j);    
    A = bsxfun(@times, reshape(uint8([128 255 128]), [1 1 3]), uint8(proposals(:,:,best)));
    A(A(:)==0) = img(A(:)==0); 
    image(A); axis image ij off;
    title(sprintf('Object %d, IoU = %g', j, iou));
end


