function [fill fills_f] = cascadeFillSegment(example, weights, seed, labelset, thresh, maxseg)

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

if nargin < 4 || isempty(labelset)
    labelset = true(example.nSeg,1);
end
if nargin < 5
    thresh = 0;
end
if nargin < 6
    maxseg = example.nSeg;
end

unary_f = example.unary_f;

fill = seed; 

maxscore = inf;
k = 1;

pairs = example.pairs;

fills_f = struct([]);
while numel(fill) < maxseg && maxscore >= thresh
    
    % find pairs 
    fpairs = pairs(any(ismember(pairs,fill),2),:);
    isfill = ismember(fpairs, fill);
    fcandidates = fpairs(~isfill);
    fcandidates = unique(fcandidates);

    % constrain to only valid labels if given
    fcandidates = fcandidates(labelset(fcandidates));
    
    if isempty(fcandidates) break; end

    % build feature vector
    fpair = scalpel.getPairwiseFeatures(example, fill, fcandidates);
    fx = [unary_f(fcandidates,:) fpair];
  
    sz = sum(example.seg_prior(fill))./sum(example.seg_prior+eps);
        
    % find weights to use 
    if weights.nlevels == 1
        w = weights.w;
    else
        w = weights.w(weights.lookup(sz),:);
    end
    scores = w*fx' + weights.b;

    if any(isnan(scores))
        fx
        assert(~any(isnan(scores)));
    end
          
    % compute maxscore
    [maxscore, maxcandidate] = max(scores);
    fills_f(k).fill = fill;
    fills_f(k).fcandidates = fcandidates;
    fills_f(k).scores = scores;
    fills_f(k).maxcandidate = maxcandidate;
    fills_f(k).fx = fx;
    fills_f(k).fx_y = fx(maxcandidate,:);
    k = k + 1;

    if maxscore >= thresh
        fill = [fill; fcandidates(maxcandidate)];
    end
end