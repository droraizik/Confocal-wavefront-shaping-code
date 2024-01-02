num_exposures = OPT_S.num_exposures;
exposures = linspace(SC.BSI_settings.low_exp,SC.BSI_settings.very_high_exp,num_exposures);
SC=change_camera_ROI(SC,'BSI',SC.c0,SC.r0,OPT_S.n_FOV);
SC = laser_set(SC.laser_settings.laser_power,SC);
OPT_S2.fin_BSI = zeros(OPT_S.n_FOV*2+1,OPT_S.n_FOV*2+1,num_exposures);
OPT_S2.fin_BSI_PSF = zeros(OPT_S.n_FOV*2+1,OPT_S.n_FOV*2+1,num_exposures);
SC = laser_on(SC);
for i_exp = 1:num_exposures
    SC = change_exposure(SC,'BSI',exposures(i_exp));
    OPT_S2.SLM_mat_flag = 1;
    OPT_S2.SLM_py_flag = 1;
    activate_func_had_fin(SC,OPT_S2);
    I=take_unsaturate_photo(SC,'BSI');
    figure(168126);imagesc(I);title('final BSI speckle');
    OPT_S2.fin_BSI(:,:,i_exp)=I;
    
    mat_flag = 0;
    py_flag = 1;
    nearest_flag = 1;
    activate_func(SC,double(SC.mask_f_laser),mat_flag,py_flag,nearest_flag);
    pause(SC.spt);
    I=take_unsaturate_photo(SC,'BSI');
    figure(168129);imagesc(I);title('final BSI speckle only laser');
    OPT_S2.fin_BSI_PSF(:,:,i_exp)=I;
    
    mat_flag = 1;
    py_flag = 1;
    nearest_flag = 1;
    activate_func(SC,double(SC.mask_f_laser),mat_flag,py_flag,nearest_flag);
    pause(SC.spt);
    I=take_unsaturate_photo(SC,'BSI');
    figure(168149);imagesc(I);title('final BSI Orig speckles');
    OPT_S2.fin_BSI_ramp(:,:,i_exp)=I;

    
    f_fin0 = OPT_S.f_fin;
    OPT_S.f_fin = OPT_S.f_fin_mid;
    OPT_S.SLM_mat_flag = 1;
    OPT_S.SLM_py_flag = 1;
    activate_func_had_fin(SC,OPT_S);
    I=take_unsaturate_photo(SC,'BSI');
    figure(1681246);imagesc(I);title('mid BSI speckle');
    OPT_S2.mid_BSI(:,:,i_exp)=I;
    OPT_S.f_fin = f_fin0;

end

SC = change_camera_ROI(SC,'BSI',SC.c0,SC.r0,OPT_S.n_cap);
SC = change_exposure(SC,'BSI',OPT_S.this_exp);
SC = laser_off(SC);
