function [id] = get_hikid(X, tree)

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