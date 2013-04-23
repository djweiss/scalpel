function [gt] = getBBoxARMask(params, gt, ar_c, thumb_size)
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



