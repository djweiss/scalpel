function [ncuts base_ncut] = getNCutFillToCandidates(fill, candidates, affin, affin_sum, basecut)

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