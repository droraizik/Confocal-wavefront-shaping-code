function [r,c,max_val] = max_rc(I,pix_smooth)
%returns location r and c of maximum in image, 
% max_val returns mean of small area around r c determined by pix_smooth
if(~exist('pix_smooth','var'))
    pix_smooth = 0;
end
[~,maxind] = max(I(:));
[r,c,~] = ind2sub(size(I),maxind);
try
    max_val = mean(I(r-pix_smooth:r+pix_smooth,c-pix_smooth:c+pix_smooth),'all');
catch e
    warning('max is in edge, return 0');
    max_val = 0;
end