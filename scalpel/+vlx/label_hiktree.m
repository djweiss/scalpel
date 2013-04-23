function [tree n] = label_hiktree(tree, D, n, d, maxdepth)

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
    

