function [f] = getUnaryFeatures(example)

f = {};

phowf = example.seg_phow_id{4};
phowf = bsxfun(@rdivide, phowf, sum(phowf,2));
phowf(isnan(phowf)) = 0;


% labid = example.seg_lab_id{end};
% bcolor = sum(bsxfun(@times, 1-example.seg_prior, labid), 1);
% bcolor = bcolor./sum(bcolor);
% fcolor = sum(bsxfun(@times, example.seg_prior, labid), 1);
% fcolor = fcolor./sum(fcolor);
% 
% colordiff = bcolor - fcolor;
% prior_color = sum(bsxfun(@times, labid, colordiff),2);
% prior_color = prior_color./example.seg_size; %sum(prior_color(:))
% prior_color = 1./(1+exp(prior_color./mean(abs(prior_color(:)))));
% %prior_color = 1./(1+exp(prior_color./mean(prior_color(:))))

%prior_color = sum(exp(prior_color./mean(prior_color(:))
%f = [phowf example.seg_prior];

fgsize = example.seg_prior.*example.seg_size;
bgsize = (1-example.seg_prior).*example.seg_size;

fgsize_sum = sum(fgsize) + eps;
bgsize_sum = sum(bgsize) + eps;

fphowsim = sum(bsxfun(@times, example.phow_sims{end}, fgsize), 1)'./fgsize_sum;
bphowsim = sum(bsxfun(@times, example.phow_sims{end}, bgsize), 1)'./bgsize_sum;

%p_phow = get_lr_predictions([fphowsim bphowsim fphowsim./(eps+bphowsim)]);
p_phow = get_lr_predictions([fphowsim./(eps+bphowsim)]);

flabsim = sum(bsxfun(@times, example.lab_sims{end}, fgsize), 1)'./fgsize_sum;
blabsim = sum(bsxfun(@times, example.lab_sims{end}, bgsize), 1)'./bgsize_sum;

%p_lab = get_lr_predictions([flabsim blabsim flabsim./(eps+blabsim)]);
p_lab = get_lr_predictions([flabsim./(eps+blabsim)]);

%[~,~,pY] = liblinear_predict(double(Y), sparse(f), m, '-b 1');

% wsim = bsxfun(@times, example.lab_sims{5},  example.seg_prior.*example.seg_size);
% flabsim = sum(wsim,1)'./sum(eps + example.seg_prior.*example.seg_size)'; 

f = [example.seg_prior p_phow p_lab ...
    example.seg_size./sum(example.seg_size) example.seg_size./example.u_border' ...
    ];
f = [ones(rows(f),1) f];

function [pY] = get_lr_predictions(f)

Y = example.seg_prior>=mean(example.prior(:));
m = liblinear_train(double(Y), sparse(f), '-c 1000 -B 1 -s 0 -q');
if m.Label(1) == 0, m.w = m.w; end
pY = 1./(1+exp(m.w(1:end-1)*f' + m.w(end)))';

end
end
