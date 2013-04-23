function [pruned npruned] = get_pruned_hiktree(tree, X, sz_limit)

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

pruned = tree; sz = {};
for d = 1:(tree.depth)
    Xids = vlx.get_hikid(X, pruned);
    Xids = Xids(d,:);
    sz{d} = sum(bsxfun(@eq, 1:max(pruned.maxid(d)), Xids'));
    
    remidx = find(sz{d} < sz_limit);
    npruned(d) = numel(remidx);
    fprintf('depth %d: pruning %d clusters\n', d, numel(remidx));
    for i = 1:numel(remidx)
        pruned = vlx.rewrite_tree_node(pruned, remidx(i), d);
    end
    
    for d = 1:pruned.depth
        pruned = vlx.label_hiktree(pruned, d);
    end
end  
%%
return;

%%

P = [0 1 1];
for d = 1:8%pruned.depth
    if d > 1
        parents{d} = get_tree_parents(pruned, 1, d);
        P = [P parents{d}+sum(pruned.maxid(1:(d-2)))+1];
    end
end
P
figure(1);
treeplot(P)

%%
figure(1);
P = [0 1 1];
for d = 1:tree.depth
    if d > 1
        parents{d} = get_tree_parents(tree, 1, d);
        P = [P parents{d}+sum(tree.maxid(1:(d-2)))+1];
    end
end
P
treeplot(P)
%%
subtree = tree.sub(2).sub(2).sub(1);
subtree.depth = tree.depth-3;
for d = 1:subtree.depth
    subtree = label_hiktree(subtree, d);
end

figure(1);
P = [0 1 1];
for d = 1:subtree.depth
    if d > 1
        parents{d} = get_tree_parents(subtree, 1, d);
        P = [P parents{d}+sum(subtree.maxid(1:(d-2)))+1];
    end
end
P
%
subs{1} = subtree; cents = {};
for d = 1:subtree.depth
    cents{d} = reshape([subs{d}.centers], [tree.mask_size subtree.maxid(d)]);
    subs{d+1} = [subs{d}.sub];
end

ims = (double(cat(3,cents{:})));
%
[x y h s] = treelayout(P);
x = scale01(x);
x = 1 + x .* (1.2*size(cents{end},3)) .* cols(ims)./rows(ims);
y = y * (h+2)
%plot(x,y,'o');
cla
hold on;
for i = 2:numel(x)
    xx = [x(i) cols(ims)./rows(ims)+x(i)];
    yy = [y(i)+1 y(i)];
    imagesc(xx,yy, ims(:,:,i-1)); colormap gray;
end
hold off;
axis off;
axis image;
%plot(x,y,'o');







%%
%%
% transition = cell(tree.depth, 1);
% for d = 1:tree.depth
%     transition{d}{}
% end

%%

%%
ids = {}; sz = {}; parents = {};
for d = 1:tree.depth
    d
    ids{d} = 1:tree.maxid(d);
    if d > 1
        parents{d} = get_tree_parents(tree, 1, d);
    end
    Xids = get_hikid(X, tree, d);
    sz{d} = sum(bsxfun(@eq, 1:max(ids{d}), Xids'));
end

%%
pruned = label_hiktree(pruned, pruned.depth)

%%
%for d = 1:tree.depth
%    Xids = get_hikid(X, tree2, d);
% end
