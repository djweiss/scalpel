function [gt] = getBBoxARMask(params, gt, ar_c, thumb_size)

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

if nargin < 4
    keep_orig = false;
end
t = CTimeleft(numel(gt));
for n = 1:numel(gt)
    t.timeleft();
    img = params.imread(gt(n).img_name); %get_img(gt(n).ImgName, Params);
    
    if isfield(gt,'bbox') % bbox+pts labeled data
        if isempty(gt(n).maskpts)
            continue;
        end

        bbox = gt(n).bbox;
        % extract segmentation mask
        Seg = poly2mask(gt(n).maskpts(1,:), gt(n).maskpts(2,:), ...
            rows(img), cols(img));
    
    else % seg labeled data
        
        Seg = gt(n).Seg>0;
        [ii jj] = find(Seg);
        bbox = [min(jj(:)) min(ii(:)) max(jj(:)) max(ii(:))];
    end
    
    [gt(n).ar_idx gt(n).ar_orig] = scalpel.getBBoxARClust(bbox, ar_c);
    bbox = round(bbox);
    
    gt(n).ar = ar_c(gt(n).ar_idx);
    gt(n).mask = scalpel.getThumbImage(bb.extract(Seg, bbox), gt(n).ar, params.tax.thumb_size);
    gt(n).patch = scalpel.getThumbImage(bb.extract(img, bbox), gt(n).ar, params.tax.thumb_size);
    if keep_orig
        gt(n).seg_orig = bb.extract(Seg, bbox);
    end
end



