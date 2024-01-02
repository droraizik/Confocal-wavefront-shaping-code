%% Initialize
SC = laser_set(SC.laser_settings.laser_power,SC);
OPT_S.this_exp = SC.BSI_settings.high_exp;
OPT_S.rep_flag = 1;
OPT_S.total_reps = HAD_S.total_its_grad;
%% First image
SC = laser_on(SC);
OPT_S.SLM_mat_flag = 1;
OPT_S.SLM_py_flag = 0;
OPT_S.SLM_flag_nearest = 1;
activate_func(SC,OPT_S.f_fin,OPT_S.SLM_mat_flag,OPT_S.SLM_py_flag,OPT_S.SLM_flag_nearest);

I = take_unsaturate_photo(SC,'BSI',OPT_S.num_images_mean_first);
OPT_S.ints(1)=sum_middle(I,OPT_S.mid_pix,OPT_S.mask_wind);

%% Optimization
while(OPT_S.rep_flag == 1)
    for ind_it=(1+ind_it):OPT_S.total_reps
        OPT_S.ind_it = ind_it;
        OPT_S = had_grad_step_PG(SC,OPT_S,HAD_S);
        step_evaluation_PG;
    end
end


