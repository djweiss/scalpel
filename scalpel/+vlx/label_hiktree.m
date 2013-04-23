function [tree n] = label_hiktree(tree, D, n, d, maxdepth)

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

if nargin==2
    d = 1; n = 1; maxdepth = tree.depth;
end
if d == D
    tree.id = [];
    for i = 1:cols(tree.centers)
        tree.id(i) = n;
        n = n + 1;
    end    
else

    for i = 1:numel(tree.sub)
        [newsub(i) n] = vlx.label_hiktree(tree.sub(i), D, n, d+1, maxdepth);
    end
    if numel(tree.sub) > 0
        tree.sub = newsub;
    end
end
   
if d == 1
    tree.maxid(D) = n-1;
end
    

