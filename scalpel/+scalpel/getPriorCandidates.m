function candidates = getPriorCandidates(cache, imgfile, boxes, models)

% ======================================================================
% Copyright (c) 2012 David Weiss
% 
% Permission is hereby granted, free of charge, to any person obtaining
% a copy of this software and associated documentation files (the
% "Software"), to deal in the Software without restriction, including
% without limitation the rights to use, copy, modify, merge, publish,
% distribute, sublicense, and/or sell copies of the Software, and to
% permit persons to whom the Software is furnished to do so, subject to
% the following conditions:
% 
% The above copyright notice and this permission notice shall be
% included in all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
% NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
% LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
% OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
% WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
% ======================================================================

alpha = 1;
ar_c = [models.ar];

img = imread(imgfile);

patch = {}; hogs = {};
for n = 1:rows(boxes)
    ar_idx(n) = scalpel.getBBoxARCluster(boxes(n,:), ar_c);
    ar = models(ar_idx(n)).ar;

    patch = scalpel.getThumbImage(bb.extract(img,round(boxes(n,:))), ar, models(ar_idx(n)).thumb_size);
    hogs = features(double(patch), models(ar_idx(n)).hog_bin_size);

    m = models(ar_idx(n));
    
    x = [hogs(:); 1];
    
    scores = m.w*x;

    yset = 1:numel(scores); %m.Label'; %1:t.maxid(end);
    
    if rows(m.w) > size(m.shapes,3)
        scores = scores(1:end-1);
        yset = 1:numel(scores); %m.Label'; %1:t.maxid(end);
        
        %yset = [1:(numel(scores)-1) -1]; %m.Label'; %1:t.maxid(end);
    end
    
    [sscores] = sort(scores,'descend');
    thresh = sscores(alpha);
    
    yset = yset(scores >= thresh);
    areas = squeeze(sum(sum(double(models(ar_idx(n)).shapes(:,:,yset))./255,1),2)) ./  ...
        prod(size2(models(ar_idx(n)).shapes, [1 2]));
    yset = yset(areas>0.4);
    
    if isequal(yset, -1)
        continue;
    end
    
%     yset = randperm(numel(scores));
%     yset = yset(1:alpha);
    
    Yset{n} = yset;
    Yscores{n} = scores(yset);
    Ybox{n} = ones(size(yset))*n;
    Yar{n} = ones(size(yset))*ar_idx(n);   
end
% 
% for i = 1:numel(models)
%     idx = find(ar_idx==i);
%     if isempty(idx)
%         continue;
%     end
%     scores = sort(vertcat(Yscores{idx}),'descend');
%     thresh = scores(min(numel(scores),sum(ar_idx==i)));
%     
%     for n = 1:numel(idx)
%         Yset{idx(n)} = Yset{idx(n)}(Yscores{idx(n)} >= thresh);
%         Yscores{idx(n)} = Yscores{idx(n)}(Yscores{idx(n)} >= thresh);
%         Ybox{idx(n)} = Ybox{idx(n)}(Yscores{idx(n)} >= thresh);
%         Yar{idx(n)} = Yar{idx(n)}(Yscores{idx(n)} >= thresh);
%     end
% end

idbox = [Ybox{:}]';
idshape = [Yset{:}]';
idar = [Yar{:}]';
scores = vertcat(Yscores{:});
bboxes = boxes(idbox,1:4);

% [~,scoreidx] = sort(scores,'descend');
% scoreidx = scoreidx(1:min(numel(scoreidx), 1000));
% bboxes = bboxes(scoreidx,:); 
% idar = idar(scoreidx); 
% idshape = idshape(scoreidx);
% scores = scores(scoreidx);

fprintf('%d boxes --> %d candidates\n', rows(boxes), rows(bboxes));

candidates = bundle(idar, idshape, bboxes, scores, Yset);

seg = cache.get(imgfile, 'seg');

t = CTimeleft('[computing priors]', numel(candidates.idar));
maskbase = zeros(size(seg));

for j = 1:numel(candidates.idar)
    t.timeleft();

    b = round(candidates.bboxes(j,:));
    m = models(candidates.idar(j));
    prior = double(m.shapes(:,:,candidates.idshape(j)))./255;
    
    assert(prod(bb.size(b)) <= prod(size(seg)));
    
    fmask = maskbase;
    fmask(b(2):b(4)-1,b(1):b(3)-1) = imresize_nearest(prior, bb.size(b));
    %fmask(b(2):b(4)-1,b(1):b(3)-1) = imresize(prior, bb.size(b), 'nearest');
    
%     [int area] = mex_seg_intarea(seg, fmask, max(seg(:)));
%     segmask = mex_seg_union(seg, double(int./area >= 0.5));
    
    segmask = scalpel.getSegGreedyUnionMask(seg, fmask);
    
    iou = scalpel.iou(segmask, fmask);
    
    [ii jj] = find(segmask);
    bbox = [min(jj(:)) min(ii(:)) max(jj(:)) max(ii(:))];
    
    segmask = segmask>0;
    proposals{j} = bundle(segmask, bbox, iou);
end

p = [proposals{:}];
sz = arrayfun(@(x)sum(x.segmask(:)), p);
pidx = find(sz>100);

candidates.idshape = candidates.idshape(pidx);
candidates.bboxes = candidates.bboxes(pidx,:);
candidates.idar = candidates.idar(pidx,:);
proposals = proposals(pidx);

for i = 1:numel(proposals)
    candidates.segmasks{i} = proposals{i}.segmask;
end

%fprintf('%d boxes --> %d candidates\n', rows(boxes), rows(candidates.bboxes));

