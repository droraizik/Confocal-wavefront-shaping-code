OPT_S.SLM_mat_flag = 1;
OPT_S.SLM_py_flag = 1;
activate_func_had_fin(SC,OPT_S);                                    %activate final function on both SLMs
I=take_unsaturate_photo(SC,'BSI');
OPT_S.ints(1) = sum_middle(I,OPT_S.mid_pix,OPT_S.mask_wind);        %use image to fit next sinusoid
OPT_S.acts(ind_it) = sum_middle(I,OPT_S.mid_pix,OPT_S.mask_wind)*SC.BSI_settings.init_exp/OPT_S.this_exp;   %score
