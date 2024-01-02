%% Initialize
SC = change_camera_ROI(SC,'BSI',SC.c0,SC.r0,OPT_S.n_cap);
SC = change_exposure(SC,'BSI',SC.BSI_settings.init_exp);
SC = laser_set(SC.laser_settings.laser_power,SC);
OPT_S.this_exp = SC.BSI_settings.init_exp;
OPT_S.rep_flag = 1;
OPT_S.total_reps = HAD_S.total_its;
%% First image
SC = laser_on(SC);
OPT_S.SLM_mat_flag = 1;
OPT_S.SLM_py_flag = 1;
OPT_S.SLM_flag_nearest = 1;
activate_func(SC,OPT_S.f_fin,OPT_S.SLM_mat_flag,OPT_S.SLM_py_flag,OPT_S.SLM_flag_nearest);  %activate f_fin on SLMs

I = take_unsaturate_photo(SC,'BSI',OPT_S.num_images_mean_first);                %capture first image
max_I = max(I(:));
SC.BSI_settings.init_exp = SC.BSI_settings.init_exp*OPT_S.SNR_max_val/max_I;    %decide exposure to keep highest pixel value
OPT_S.this_exp = SC.BSI_settings.init_exp;                                      
SC = change_exposure(SC,'BSI',SC.BSI_settings.init_exp);                        %change exposure of main camera
I = take_unsaturate_photo(SC,'BSI',OPT_S.num_images_mean_first);                %capture first image again

OPT_S.ints(1)=sum_middle(I,OPT_S.mid_pix,OPT_S.mask_wind);                      %set to first sinusoid restoration
OPT_S.I0 = OPT_S.ints(1);                                                       %set for later exposure maintenance

%% Optimization
while(OPT_S.rep_flag == 1)
    for ind_it=(1+ind_it):OPT_S.total_reps
        OPT_S.ind_it = ind_it;
        OPT_S = had_step(SC,OPT_S,HAD_S);                                       %fit sin of next hadamard mask and find best coeff.
        step_evaluation;                                                        %evaluate new mask and update score
        if(ind_it==round(OPT_S.mid_pix_set(OPT_S.ind_change_windw)*HAD_S.total_its+1))
            [SC,OPT_S] = had_wind_size_change(SC,OPT_S);                        %reduce window size if necessary
        elseif(mod(ind_it,OPT_S.val_interval)==0)
            [SC,OPT_S] = had_interval(SC,OPT_S);                                %change exposure to keep SNR constant
        end
    end
    [SC,OPT_S] = had_add_reps(SC,OPT_S);                                        %option for adding more iterations
end

