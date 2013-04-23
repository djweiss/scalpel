function [SegPairs, Adj] = getSegPairs(Seg)

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