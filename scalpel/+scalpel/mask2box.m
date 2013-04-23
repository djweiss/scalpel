function [box] = mask2box(mask)

[ii jj] = find(mask);
box = [min(jj(:)) min(ii(:)) max(jj(:)) max(ii(:))];

