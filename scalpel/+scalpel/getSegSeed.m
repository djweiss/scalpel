function [seed] = getSegSeed(example, labels)

seedmask = example.seg_prior;
if nargin > 1
    seedmask(~example.labels) = -inf;
end

seedidx = find(example.seg_prior == max(example.seg_prior));
[~,subseed] = max(example.seg_size(seedidx));
seed = seedidx(subseed);
