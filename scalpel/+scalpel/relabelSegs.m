function Seg = relabelSegs(Seg)

% ensure no ESPs are skipped, i.e. unique(Seg(:)) == 1:max(Seg(:))
Seg = Seg + 1;

U = unique(Seg(:));
Conv = zeros(max(U), 1);
Conv(U) = 1:numel(U);

Seg = Conv(Seg);