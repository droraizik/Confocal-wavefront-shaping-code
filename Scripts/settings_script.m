%experiment name
save_folder =                               'results';      %data folder
%flipper
SC.motors_flags.flipper =                   1;              %flipper motor ono
%BSI
SC.BSI_settings.flag =                      1;              %main camera on
SC.BSI_settings.very_high_exp =             400e3;          %exposure for initial and final capture
SC.BSI_settings.big_FOV_exp =               200e3;          %exposure for large big area images
SC.BSI_settings.confocal_exp =              50e3;           %exposure for confocal imaging (after optimization)
SC.BSI_settings.init_exp =                  200e3;
%PG
SC.PG_settings.flag =                       1;              %validation camera on
SC.PG_settings.BP_exp =                     40e3;           %fluorescence exposure
SC.PG_settings.ND_exp =                     1e3;            %laser exposure
SC.PG_settings.BP_mean =                    3;              %fluorescence - number of mean images
SC.PG_settings.ND_mean =                    3;              %laser - number of mean images
%Laser
SC.laser_settings.laser_power =             30;             %laser power - optimization
SC.laser_settings.laser_big_FOV =           80;             %laser power - big area
SC.laser_settings.laser_confocal =          30;             %laser power - confocal imaging
SC.laser_settings.laser_PG_ND =             20;             %laser power - validation camera when capture laser.

%window
OPT_S.SNR_max_val =                         0.09;           %set exposure such that max of first image is this high
OPT_S.num_images_mean_first =               5;              %find max of first image

% validation
SC.n_PG =                                   200;            %half number of pixels in validation image
SC.r0_PG =                                  803;            %validation camera 00
SC.c0_PG =                                  1238;           %validation camera 00

% main
SC.n =                                      800;            %half number of pixels in Fourier space

% Optimization settings
OPT_S.M =                                   32;             %Hadamard basis size (MxM)
% OPT_S.rads =                                [28 28 28];     %Optimization elements max radius (will be explained)
OPT_S.rads =                                [4 4]     %Optimization elements max radius (will be explained)
OPT_S.num_phases =                          4;              %number of phases to restore sinusoid
OPT_S.mid_pixes =                           [3 2];          %number of pixels to mean in optimization
OPT_S.mid_pix_set =                         [0 0.5];        %when to set the mean number (for example, 0.5 is half of total iterations)
OPT_S.mask_wind_exp =                       0.8;            %optimization window mask

% capture settings
OPT_S.n_cap =                               20;             %half number of pixels in optimization window
OPT_S.n_FOV =                               300;            %half number of pixels in big area window

% interval settings
OPT_S.val_interval =                        10;             %number of iterations to evaluate and change exposure


% big FOV - find tilt shift ratio
FOV.TS_ramps_alpha =                        -0.1:0.025:0.1; %Tilt shift first scan ramps
FOV.TS_shifts_alpha =                       -8:0.5:8;       %Tilt shift first scan shifts
FOV.TS_scan =                               -0.5:0.0125:0.5;%Tilt shift second scan ramps
FOV.shift_alpha =                           -30;            %default value for tilt shift parameter

% big FOV - scan parameters
FOV.num_rand_PG =                           30;             %number of mean images - capture Ground truth
FOV.validation_cam_rand_radius =            1;              %random illumination radius
FOV.d_ramp =                                4*6.5e-3;       %big area ramp delta
FOV.max_ramp =                              60*6.5e-3;      %big area ramp max
FOV.big_area_mean_num =                     2;              %number of random illuminations
FOV.big_area_scale =                        3;              %random illumination magnification

% Confocal
FOV.d_conf_pix =                            1;              %confocal ramp delta
FOV.n_conf =                                30;             %confocal ramp max
FOV.confocal_n_save =                       3;              %confocal window capture
FOV.conf_scan_order_str =                   'x_cont';       %confocal scan direction

% flags
OPT_S.SLM_las_flag =                        1;
OPT_S.SLM_cam_flag =                     	1;
OPT_S.SLM_flag_nearest =                    1;
