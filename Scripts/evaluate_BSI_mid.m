num_exposures = OPT_S.num_exposures;
exposures = linspace(SC.BSI_settings.low_exp,SC.BSI_settings.very_high_exp,num_exposures);
SC=change_camera_ROI(SC,'BSI',SC.c0,SC.r0,OPT_S.n_FOV);
SC = laser_set(SC.laser_settings.laser_power,SC);
if(OPT_S.tm_is_alternate == 0)
    OPT_S.tm_BSI_mid = zeros(OPT_S.n_FOV*2+1,OPT_S.n_FOV*2+1,num_exposures);
    OPT_S.tm_BSI_mid_PSF = zeros(OPT_S.n_FOV*2+1,OPT_S.n_FOV*2+1,num_exposures);
    for i_exp = 1:num_exposures
        SC = change_exposure(SC,'BSI',exposures(i_exp));
        OPT_S.SLM_mat_flag = 1;
        OPT_S.SLM_py_flag = 1;
        activate_func_had_fin(SC,OPT_S);
        I=take_unsaturate_photo(SC,'BSI');
        figure(168126);imagesc(I);title('mid BSI speckle');
        OPT_S.tm_BSI_mid(:,:,i_exp)=I;
               
        mat_flag = 0;
        py_flag = 1;
        nearest_flag = 1;
        activate_func(SC,double(SC.mask_f_laser),mat_flag,py_flag,nearest_flag);
        pause(SC.spt);
        I=take_unsaturate_photo(SC,'BSI');
        figure(168129);imagesc(I);title('mid BSI speckle only laser');
        OPT_S.tm_BSI_mid_PSF(:,:,i_exp)=I;
    end
else
    OPT_S2.tm_BSI_mid = zeros(OPT_S.n_FOV*2+1,OPT_S.n_FOV*2+1,num_exposures);
    OPT_S2.tm_BSI_mid_PSF = zeros(OPT_S.n_FOV*2+1,OPT_S.n_FOV*2+1,num_exposures);
    for i_exp = 1:num_exposures
        SC = change_exposure(SC,'BSI',exposures(i_exp));
        OPT_S2.SLM_mat_flag = 1;
        OPT_S2.SLM_py_flag = 1;
        activate_func_had_fin(SC,OPT_S2);
        I=take_unsaturate_photo(SC,'BSI');
        figure(168126);imagesc(I);title('mid BSI speckle');
        OPT_S2.tm_BSI_mid(:,:,i_exp)=I;
        mat_flag = 0;
        py_flag = 1;
        nearest_flag = 1;
        activate_func(SC,double(SC.mask_f_laser),mat_flag,py_flag,nearest_flag);
        pause(SC.spt);
        I=take_unsaturate_photo(SC,'BSI');
        figure(168129);imagesc(I);title('mid BSI speckle only laser');
        OPT_S2.tm_BSI_mid_PSF(:,:,i_exp)=I;
    end
end
SC = change_camera_ROI(SC,'BSI',SC.c0,SC.r0,OPT_S.n_cap);
SC = change_exposure(SC,'BSI',OPT_S.this_exp);
