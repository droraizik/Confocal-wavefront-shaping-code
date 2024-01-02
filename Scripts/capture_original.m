%% BSI
SC = change_camera_ROI(SC,'BSI',SC.c0,SC.r0,OPT_S.n_FOV);                       %change camera ROI to capture N_FOV by N_FOV pixels
SC = laser_set(SC.laser_settings.laser_power,SC);                               %set laser to standart power
cam_SLM_func(double(SC.mask_f_cam),SC,SC.ramp_fx_cam,SC.ramp_fy_cam);           %set plane function on camera SLM
las_SLM_func(double(SC.mask_f_laser),SC,SC.ramp_fx_laser,SC.ramp_fy_laser);     %set plane function on laser SLM
SC = laser_on(SC);
SC = change_exposure(SC,'BSI',SC.BSI_settings.very_high_exp);                   %change exposure of main camera                  
OPT_S.init_BSI=take_unsaturate_photo(SC,'BSI');                                 %capture original image in main

%% PG
SC = set_PG_BP(SC);                                                             %set val. camera to fluorescence mode
OPT_S.init_PG_BP = take_unsaturate_photo(SC,'PG',SC.PG_settings.BP_mean*3);     %capture original image in val.
SC = set_PG_ND(SC);                                                             %set val. camera to laser mode
OPT_S.init_PG_ND = take_unsaturate_photo(SC,'PG',SC.PG_settings.ND_mean);       %capture original image in val.
%% show
figure;imagesc(OPT_S.init_BSI);title('Original BSI speckles')
figure;imagesc(OPT_S.init_PG_BP);title('Original BP')
figure;imagesc(OPT_S.init_PG_ND);title('Original ND')
SC = laser_set(SC.laser_settings.laser_power,SC);

