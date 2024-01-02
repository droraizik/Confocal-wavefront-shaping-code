function mask = had_set_mask(mid_pix,alpha)
x = sqrt(alpha.^(abs(-mid_pix:mid_pix)));
mask=x'*x;

