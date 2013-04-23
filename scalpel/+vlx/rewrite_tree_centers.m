function [tree] = rewrite_tree_centers(tree, centers, D, d)

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

if nargin==3
    d = 1;
end

if d == D
    tree.centers = [centers{tree.id}];
else
    for i = 1:numel(tree.sub)
        tree.sub(i) = vlx.rewrite_tree_centers(tree.sub(i), centers, D, d+1);
    end
end


% 
% if d == D-1
%     for i = 1:numel(tree.sub)
%         % find child that needs to be rewritten
%         
%         isidx = find(tree.sub(i).id == id);
%         if ~isempty(isidx)
%             fprintf([mfilename ': found node %d, %d child of %d\n'], id, isidx, tree.id(i));
%             tree.sub(i).centers(:,isidx) = tree.centers(:,i);            
%             if ~isempty(tree.sub(i).sub)
%                 fprintf([mfilename ': found node %d has %d children\n'], id, numel(tree.sub(i).sub(isidx).id));
%                 
%                 tree.sub(i).sub(isidx) = rewrite_tree_centers(tree.sub(i).sub(isidx), tree.centers(:,i), ...
%                     maxdepth, d+2);
%             else
%                 fprintf([mfilename ': found node %d has %d children\n'], id, numel(tree.sub(i).sub));
%             end
%             break;
%         end
%     end
% else
%     for i = 1:numel(tree.sub)
%         tree.sub(i) = rewrite_tree_node(tree.sub(i), id, D, d+1, maxdepth);
%     end
% end


