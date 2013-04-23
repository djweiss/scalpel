function [id] = get_hikid(X, tree)

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

% if nargin==2
%     D = tree.depth;
% end
path = vlx.vlx_hikmeanspush(tree, X);
%id = sum(bsxfun(@times, double(path)-1, tree.K.^[0:(tree.depth-1)]'),1)+1;
%id = sum(bsxfun(@times, double(path)-1, [1 tree.maxid(1:end-1)]'),1)+1;
id = vlx.mex_get_hikid(tree, double(path)')';
%%
% id = zeros(tree.depth, cols(X));
% for D = 1:tree.depth
%     for i = 1:cols(path)
%         r = tree;
%         for d = 1:D-1
%             r = r.sub(path(d,i));
%         end
%         assert(strcmp(class(r.id(path(D,i))), 'double'))
%         id(D, i) = r.id(path(D, i));
%     end
% end