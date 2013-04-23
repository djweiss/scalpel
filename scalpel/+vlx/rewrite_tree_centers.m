function [tree] = rewrite_tree_centers(tree, centers, D, d)

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


