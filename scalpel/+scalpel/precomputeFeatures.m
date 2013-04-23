function [example] = precomputeFeatures(cache, imgfile, precomp)

t0 = tic;
fprintf('Computing image features for ''%s''...\n', imgfile);

img = imread(imgfile);
gPb = cache.get(imgfile, 'gPb');
seg = cache.get(imgfile, 'seg');

ucm = gPb.ucm;

fprintf('Computing PHOW: ');
t1 = tic;
imgs = im2single(rgb2gray(img));
[frames, descrs] = vl_phow(imgs, 'fast', true, 'step', 2, 'sizes', [2 4 6 8]);
fprintf('vl_phow: %.2f sec', toc(t1));

%phow = bundle(frames, descrs);

t1 = tic;
seg_phow_id = scalpel.getSegHists(seg, frames, descrs, precomp.phow_tree);
fprintf(' compute hists: %.2f sec\n', toc(t1));

%
fprintf('Computing Lab: ');
[ii jj] = meshgrid(1:rows(seg), 1:cols(seg));
frames = [jj(:) ii(:)]'; 
t1 = tic;
imgLab = applycform(img, makecform('srgb2lab'));

[ii jj] = meshgrid(1:rows(seg), 1:cols(seg));
frames = [jj(:) ii(:)]'; 

descrs = reshape(imgLab, prod(size2(img, [1 2])), 3)';
fprintf(' applycform: %.2f sec', toc(t1));

t1 = tic;
seg_lab_id = scalpel.getSegHists(seg, frames, descrs, precomp.Lab_tree);
fprintf(' compute hists: %.2f sec\n', toc(t1));

example = bundle(img, seg, ucm, seg_phow_id, seg_lab_id);

% compute additional segment info
example.nSeg = max(example.seg(:));

t1 = tic;
fprintf('Compute sim/border features: ');
% compute border strength
se = ones(3);
for i = 1:example.nSeg
    segi = imdilate(example.seg == i, se);
    
    example.u_border(i) = sum(segi(segi>0));
    example.u_ucm_sum(i) = sum(example.ucm(segi>0));
    example.u_ucm_max(i) = max(example.ucm(segi>0));
end

% compute pairwise relationships between segments
example.pairs = scalpel.getSegPairs(example.seg);

example.phow_sims = get_sims(example.seg_phow_id(6:10));
example.lab_sims = get_sims(example.seg_lab_id(6:10));

% compute border cross
example.bucm = zeros(example.nSeg, example.nSeg);

se = ones(3);
for n = 1:rows(example.pairs)
    i = example.pairs(n,1);
    j = example.pairs(n,2);
    
    segi = imdilate(example.seg == i, se);
    segj = imdilate(example.seg == j, se);
    border = segi & segj;

    %     example.bucm(i,j) = mean(example.ucm(border));
    %     example.bucm(j,i) = example.bucm(i,j);

    example.bucm_max(i,j) = max(example.ucm(border));
    example.bucm_max(j,i) = example.bucm_max(i,j);

    example.bucm_sum(i,j) = sum(example.ucm(border));
    example.bucm_sum(j,i) = example.bucm_sum(i,j);
    
    example.border(i,j) = sum(border(:));
    example.border(j,i) = example.border(i,j);
end
fprintf('%.2f sec\n', toc(t1));
fprintf('Total time for image: %.2f sec\n', toc(t0));

function sims = get_sims(bow_ids)

sims = {};
for k = 1:numel(bow_ids)
    bow = get_bow_dist(bow_ids{k});
    sims{end+1} = sqrt(bow*bow');
end

function seg_bow = get_bow_dist(ids)

seg_bow = bsxfun(@rdivide, ids, sum(ids, 2));
seg_bow(all(isnan(seg_bow),2),:) = 1./cols(ids);


