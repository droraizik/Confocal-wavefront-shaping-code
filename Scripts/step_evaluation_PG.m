OPT_S.SLM_mat_flag = 1;
OPT_S.SLM_py_flag = 0;
activate_func_had_fin(SC,OPT_S);
% I=take_fixed_photo(SC,'PG');
I=take_unsaturate_photo(SC,'PG');
had_show_I_old(OPT_S,I,show_limit);
OPT_S.ints(1) = sum_middle(I,OPT_S.mid_pix,OPT_S.mask_wind);
OPT_S.acts(ind_it) = sum_middle(I,OPT_S.mid_pix,OPT_S.mask_wind)*SC.BSI_settings.high_exp/OPT_S.this_exp;
had_show_acts(OPT_S);
