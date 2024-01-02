function [SC,OPT_S] = had_wind_size_change(SC,OPT_S)

OPT_S.mid_pix = OPT_S.mid_pixes(OPT_S.ind_change_windw);
OPT_S.mask_wind = had_set_mask(OPT_S.mid_pix,OPT_S.mask_wind_exp);
OPT_S.ind_change_windw = OPT_S.ind_change_windw+1;

