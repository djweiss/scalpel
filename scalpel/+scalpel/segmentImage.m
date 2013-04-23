function [p candidates] = segmentImage(imgfile, boxes)

opts = scalpel.config();

modeldata = load(opts.model_file);

lookup = modeldata.lookup;
segmodels = modeldata.segmodels;
structmodels = modeldata.structmodels;
models =  modeldata.models;

cache = scalpel.getCache(opts);
% use the specific modeldata to compute features
cache.register('features', @(c,x,m)scalpel.precomputeFeatures(c,x,modeldata.precomp));

%% get priors
candidates = scalpel.getPriorCandidates(cache, imgfile, boxes, modeldata.models);

example = cache.get(imgfile, 'features');

clear p
t0 = CTimeleft('[running cascades]', numel(candidates.idar));
for i = 1:numel(candidates.idar)
    t0.timeleft();
    bbox = candidates.bboxes(i,:);

    % find the appropriate shape model to use
    midx = find(lookup(:,1) == candidates.idar(i) & ...
        lookup(:,end) == candidates.idshape(i));
    %fprintf('%s, %d, %d\n', mat2str(lookup(midx,:)), candidates.idar(i), candidates.idshape(i));
    assert(~isempty(midx));
    midx = lookup(midx,end-1);
    
    classid = segmodels(midx).classid;
    if rows(structmodels) == 20
        sweights = [structmodels(classid,:).weights];
    else
        sweights = [structmodels.weights];
    end
    area = bb.area(bbox);
    [~,bestarea] = min(abs(area-[sweights.mnarea]));
    weights = sweights(bestarea);
    
    shape = double(models(candidates.idar(i)).shapes(:,:,candidates.idshape(i)))./255;
    example = scalpel.getLocalizedPrior(example, shape, bbox);
    seed = scalpel.getSegSeed(example);
    
    example.bcolor = sum(example.seg_lab_id{8},1);
    example.lab_sims_K = exp(-(example.lab_sims{end}.^2)).*(example.bucm_max>0);
    for j = 1:example.nSeg
        example.bucm_max_assoc(j) = sum(example.bucm_max(j,:));
        example.lab_sims_K_sum(j) = sum(example.lab_sims_K(j,:));
    end
    example.bucm_max_assoc_sum = sum(example.bucm_max_assoc);
    
    example.unary_f = scalpel.getUnaryFeatures(example);
    [fill] = scalpel.cascadeFillSegment(example, weights, seed);
    
    segmask = ismember(example.seg, fill);
    p(i) = bundle(segmask);
end

segmask = ones(size(segmask));
p(end+1) = bundle(segmask);
candidates.bboxes(end+1,:) = [1 1 size2(example.img, [2 1])];

p = cat(3,p.segmask);

return;

