function [ncuts base_ncut] = getNCutFillToCandidates(fill, candidates, affin, affin_sum, basecut)

fillz = false(rows(affin),1);
fillz(fill) = 1;

if nargin < 5
    basecut = sum(sum(affin(fillz,~fillz)));
end

cuts_in = sum(affin(candidates,fillz), 2);
cuts_out = affin_sum(candidates) - cuts_in; %sum(affin(candidates,~fillz),2);
cuts = basecut - cuts_in + cuts_out;

cut_f = sum(affin_sum(fillz));
cut_b = sum(affin_sum(~fillz)); %_sum - cut_f; %sum(affin_assoc(~fillz));
ncuts = cuts./(cut_f + affin_sum(candidates)) + ...
    cuts./(cut_b - affin_sum(candidates));

base_ncut = basecut./cut_f + basecut./cut_b;

%if cut_f ~= 0, base_ncut = base_ncut +basecut./cut_f;end
%if cut_b ~= 0, base_ncut = base_ncut +basecut./cut_b;end