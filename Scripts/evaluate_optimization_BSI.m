SC = change_camera_ROI(SC,'BSI',SC.c0,SC.r0,OPT_S.n_FOV);                       %change camera ROI to capture N_FOV by N_FOV pixels
SC = laser_set(SC.laser_settings.laser_power,SC);                               %set laser to standart power
SC = change_exposure(SC,'BSI',SC.BSI_settings.very_high_exp);                   %change exposure of main camera                  

%% final image - delta
OPT_S.las_SLM_flag = 1;
OPT_S.cam_SLM_flag = 1;
activate_func_had_fin(SC,OPT_S);
I=take_unsaturate_photo(SC,'BSI');
figure;imagesc(I);title('final BSI speckle');
OPT_S.fin_BSI = I;
%% final image - psf
las_SLM_flag = 0;
cam_SLM_flag = 1;
nearest_flag = 1;
activate_func(SC,double(SC.mask_f_laser),las_SLM_flag,cam_SLM_flag,nearest_flag);   %put blank image in camera SLM to capture psf
I=take_unsaturate_photo(SC,'BSI');
figure;imagesc(I);title('final BSI speckle only laser');
OPT_S.fin_BSI_PSF=I;
