function mask_f = had_get_mask(SC,HAD_S,i_it)
mask_f=HAD_S.had_mat(HAD_S.row_i(i_it),:)'*HAD_S.had_mat(HAD_S.col_j(i_it),:);
mask_f = (mask_f+1)/2;
mask_f=interp2(HAD_S.XM,HAD_S.YM,mask_f,SC.gfx,SC.gfy,'nearest',0);
mask_f(isnan(mask_f(:)))=0;
mask_f(isinf(mask_f(:)))=0;
mask_f=exp(mask_f*1i);

