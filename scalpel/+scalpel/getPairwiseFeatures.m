function [f] = getPairwiseFeatures(example, fill, candidates)

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

%%

outstr = [example.u_ucm_sum(candidates)' - sum(example.bucm_sum(candidates, fill),2)] ...
    ./ [example.u_border(candidates)']; % - sum(example.border(candidates, fill), 2)];

bsum = sum(example.border(candidates, fill), 2);

intstr = sum(example.bucm_sum(candidates, fill),2) ./ bsum;

intstr2 = sum(example.bucm_max(candidates, fill).*example.border(candidates,fill),2) ./ bsum;

blength =  bsum ./ example.u_border(candidates)';

%%


fillz = false(example.nSeg,1);
fillz(fill) = 1;
%%
if sum(fillz) < example.nSeg-1
%     cuts = zeros(numel(candidates),1); ncuts = cuts;
    
%     for j = 1:numel(candidates)
%         fillz(candidates(j)) = true;
%         cuts(j) = sum(sum(example.bucm_max(fillz,~fillz)));
%         %     ncuts(j) = cuts(j)./sum(sum(example.bucm_max(fillz,:))) + ...
%         %         cuts(j)./sum(sum(example.bucm_max(~fillz,:))); % + b...
%         %ncuts(j) = cuts(j)./sum(sum(example.bucm_max(fillz,fillz)));
%         fillz(candidates(j)) = false;
%     end
%     
%     basecut = sum(sum(example.bucm_max(fillz,~fillz)));
% 
%     cuts_in = sum(example.bucm_max(candidates,fillz), 2);
%     cuts_out = example.bucm_max_assoc(candidates)' - cuts_in; %sum(example.bucm_max(candidates,~fillz),2);
%     cuts = basecut - cuts_in + cuts_out;
%     
%     cut_f = sum(example.bucm_max_assoc(fillz));
%     cut_b = example.bucm_max_assoc_sum - cut_f; %sum(example.bucm_max_assoc(~fillz));
%     ncuts = cuts./(cut_f + example.bucm_max_assoc(candidates)') + ...
%         cuts./(cut_b - example.bucm_max_assoc(candidates)');
%     
% %     assert(sum(abs(cuts2-cuts)) < 0.01)
%         
%     
%     base_ncut = 0;
%     if cut_f ~= 0, base_ncut = base_ncut +basecut./cut_f;end
%     if cut_b ~= 0, base_ncut = base_ncut +basecut./cut_b;end
    
    %base_ncut = basecut ./ sum(sum(example.bucm_max(fillz,fillz))); % + ...
        %basecut ./ sum(sum(example.bucm_max(~fillz,~fillz))); %cut_b;
    
    %ncuts = base_ncut - ncuts;
    %basecut./cut_f
    %cuts./(cut_f + example.bucm_max_assoc(candidates)')
    
    %ncuts = (basecut./cut_f) - (cuts./(cut_f + example.bucm_max_assoc(candidates)'; %sum(fillz) - cuts./(sum(fillz)+1);
    %ncuts = basecut./sum(fillz) - cuts./(sum(fillz)+1);
    [ncuts base_ncut] = scalpel.getNCutFillToCandidates(fill, candidates, example.bucm_max, example.bucm_max_assoc'); 
    ncuts = ncuts - base_ncut; %- ncuts;
    
    [ncuts2 base_ncut2] = scalpel.getNCutFillToCandidates(fill, candidates, example.lab_sims_K, example.lab_sims_K_sum');
    ncuts2 = ncuts2 - base_ncut2; %- ncuts;    
    
    %     ncuts(j) = cuts(j)./
    %         cuts(j)./sum(example.bucm_max_assoc(~fillz)); % + b...
    %%
%     labdist = example.seg_lab_id{8};
%     fcolor = sum(labdist(fillz,:), 1);
%     bcolor = example.bcolor - fcolor; %sum(labdist(~fillz,:), 1);
%     
%     base_fcolor = fcolor./sum(fcolor);
%     base_bcolor = bcolor./sum(bcolor);
%     base_color = sum((base_fcolor-base_bcolor).^2./(eps + base_fcolor+base_bcolor));
%     
%     fcolor_cand = mex_combine_normalize_hist(fcolor, labdist(candidates,:), 1);
%     bcolor_cand = mex_combine_normalize_hist(bcolor, labdist(candidates,:), -1);
% 
% %     fcolor_cand = bsxfun(@plus, fcolor, labdist(candidates,:));
% %     bcolor_cand = bsxfun(@minus, bcolor, labdist(candidates,:));
% %     
% %     fcolor_cand = bsxfun(@rdivide, fcolor_cand, sum(fcolor_cand,2));
% %     bcolor_cand = bsxfun(@rdivide, bcolor_cand, sum(bcolor_cand,2));
%     %d = sum((fcolor_cand-bcolor_cand).^2./(eps + fcolor_cand+bcolor_cand),2)
%     d = mex_chisq(fcolor_cand, bcolor_cand);
    
    
    
%    color_e = d - base_color;

    %color_e = sum(min(fcolor_cand, bcolor_cand),2);
else
    ncuts = 0; color_e = 0; ncuts2 = 0;
end
%cuts

% mask = mex_seg_union(example.seg, fillz)>0;
% bwconvhull(mask);
%cvex = [1-([example.u_border(candidates)' - sum(example.border(candidates,fill), 2)])./example.u_border(candidates)'] ...
%cvex2 = cvex ./ example.seg_size(candidates);
 
f = [ncuts ncuts2 ... color_e ...
    double(outstr) double(intstr) double(intstr2) ...
    blength ... 
    get_sim_f(example.phow_sims) ...
    get_sim_f(example.lab_sims) ...
    ];  

%assert(all(~isnan(f(:))));

function f = get_sim_f(sims)

f = [];
for k = 2% :numel(sims)
    wsim = bsxfun(@times, sims{k}(fill,candidates), example.seg_size(fill));
    frgb = sum(wsim,1)'./sum(example.seg_size(fill))'; % sims{k}(fill, candidates), 1)';
    %frgb = mean(sims{k}(fill, candidates), 1)';
    %frgb_max = max(sims{k}(fill, candidates), [], 1)';
    %frgb_min = max(sims{k}(fill, candidates), [], 1)';
    %frgb_min = min(example.rgb_sims{k}(fill, candidates), [], 1)';
    
    f = [f frgb]; % exp(-frgb_max)];
end

end
end

% 
% for k = 1:numel(example.sift_sims)
%     fsift  = mean(example.sift_sims{k}(fill, candidates), 1)';
%     fsift_max = max(example.sift_sims{k}(fill, candidates), [], 1)';
%     %fsift_min = min(example.sift_sims{k}(fill, candidates), [], 1)';
%     f = [f fsift exp(-fsift_max)];
% end