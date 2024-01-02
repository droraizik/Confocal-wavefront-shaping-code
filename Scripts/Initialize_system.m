SC=init_system(SC);
%% hadamard masks
M = OPT_S.M;
rads = OPT_S.rads;
[HAD_S.had_mat,HAD_S.row_i,HAD_S.col_j] = hadamard_matrix(M,rads);
[HAD_S.XM,HAD_S.YM]=meshgrid(linspace(-SC.mask_rad_laser,SC.mask_rad_laser,M));
[HAD_S.XM_int,HAD_S.YM_int]=meshgrid(linspace(-(SC.mask_rad_laser-0.1),(SC.mask_rad_laser-0.1),M));
HAD_S.rads=rads;
HAD_S.M=M;
HAD_S.total_its = length(HAD_S.row_i);
%% phases
OPT_S.phases=((0:1/OPT_S.num_phases:1-1/OPT_S.num_phases)*2*pi)';
H=[cos(OPT_S.phases) -sin(OPT_S.phases) ones(size(OPT_S.phases))];
OPT_S.H_hat=(H'*H)\H';
%% optimization settings
OPT_S.ind_change_windw = 1;
OPT_S.mid_pix = OPT_S.mid_pixes(1);
OPT_S.mid_pix_set = [OPT_S.mid_pix_set inf];
OPT_S.mask_wind = had_set_mask(OPT_S.mid_pix,OPT_S.mask_wind_exp);
OPT_S.f_fin = ones(size(SC.mask_f_laser));

%% power and exposure
OPT_S.this_exp = SC.BSI_settings.init_exp;
SC = laser_set(SC.laser_settings.laser_power,SC);

%% allocations
OPT_S.speckle_images_BSI=zeros(OPT_S.n_cap*2+1,OPT_S.n_cap*2+1,HAD_S.total_its);
OPT_S.f_fins=zeros(M,M,HAD_S.total_its);   %also for laser
OPT_S.f_fins_las=zeros(M,M,HAD_S.total_its);
OPT_S.f_fins_cam=zeros(M,M,HAD_S.total_its);
OPT_S.acts=zeros(1,HAD_S.total_its);
num_images_total_val=ceil(HAD_S.total_its/OPT_S.val_interval);
OPT_S.PG_beads_debug=zeros(SC.N_PG,SC.N_PG,num_images_total_val);
OPT_S.laser_arr=zeros(1,num_images_total_val);
OPT_S.exp_arr=zeros(1,num_images_total_val);
OPT_S.ints = zeros(OPT_S.num_phases,1);
OPT_S.total_ints = [];
OPT_S.ind_total_ints = 1;
ind_it=0;
%% laser 
SC.laser_settings.laser_PG_BP = SC.laser_settings.laser_power;
