function [SegPairs, Adj] = getSegPairs(Seg)

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

    nSeg = max(Seg(:));
    
    Adj = false(nSeg, nSeg);

    IdxPairs = sub2ind([nSeg nSeg], Seg(:, 1:end-1), Seg(:, 2:end));
    Adj(IdxPairs) = true;
    
    IdxPairs = sub2ind([nSeg nSeg], Seg(1:end-1, :), Seg(2:end, :));
    Adj(IdxPairs) = true;
    
    IdxPairs = sub2ind([nSeg nSeg], Seg(1:end-1, 1:end-1), Seg(2:end, 2:end));
    Adj(IdxPairs) = true;
    
    IdxPairs = sub2ind([nSeg nSeg], Seg(1:end-1, 2:end), Seg(2:end, 1:end-1));
    Adj(IdxPairs) = true;
    
    % indices of adjacent elements
    Adj = Adj | Adj';
    
    [SegPairs(:, 2), SegPairs(:, 1)] = find(tril(Adj, -1));
    SegPairs = single(SegPairs);    
    
end