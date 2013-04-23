function [tax] = get_tree_taxonomy(tree)

for d = 2:tree.depth
    tax{d-1}=  get_tree_taxonomy_r(tree, d);
end

function tax = get_tree_taxonomy_r(tree, D, d, tax)

if nargin==2
    d = 1; tax = cell(tree.maxid(D-1), 1);
end

if (d == D-1)
    for i = 1:numel(tree.sub)
        tax{tree.id(i)} = tree.sub(i).id;
    end
else
    for i = 1:numel(tree.sub)
        tax = get_tree_taxonomy_r(tree.sub(i), D, d+1, tax);
    end
end


    


