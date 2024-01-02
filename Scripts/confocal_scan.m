%confocal scan

f_fin_0 = OPT_S.f_fin.*SC.mask_f_laser;

fx_laser_0 = SC.ramps.fx_laser;
fy_laser_0 = SC.ramps.fy_laser;

fx_cam_0 = SC.ramps.fx_cam;
fy_cam_0 = SC.ramps.fy_cam;

%% confocal settings
n_conf = FOV.n_conf;
d_conf_x = FOV.d_conf_pix;
d_conf_y = FOV.d_conf_pix;
N_conf_x = 2*FOV.n_conf+1;
N_conf_y = 2*FOV.n_conf+1;
num_points = N_conf_y*N_conf_x;
FOV.conf_scan_order = 1:num_points;

n_save = FOV.confocal_n_save;
conf_tilts_x = (-n_conf:d_conf_x:n_conf)*SC.dx;
conf_tilts_y = (-n_conf:d_conf_y:n_conf)*SC.dx;
FOV.conf_ints_fixed = zeros(n_save*2+1,n_save*2+1,N_conf_y,N_conf_x);
FOV.conf_ints_unfixed = zeros(n_save*2+1,n_save*2+1,N_conf_y,N_conf_x);
SC=change_camera_ROI(SC,'BSI',SC.c0,SC.r0,n_save);
i_windw = 1;

%% Corrected
SC = laser_on(SC);
for i_p = 1:num_points
    [iy, ix] = ind2sub([N_conf_y N_conf_x],FOV.conf_scan_order(i_p));
    tilt_x=conf_tilts_x(ix);
    tilt_y=conf_tilts_y(iy);
    SC.ramps.fx_laser=fx_laser_0+tilt_x;
    SC.ramps.fy_laser=fy_laser_0+tilt_y;
    SC.ramps.fx_cam=fx_cam_0-tilt_x;
    SC.ramps.fy_cam=fy_cam_0-tilt_y;
    OPT_S.f_fin = circshift(f_fin_0,round([FOV.shift_alpha*tilt_y/SC.df FOV.shift_alpha*tilt_x/SC.df]));
    activate_func_had_fin(SC,OPT_S);
    I = take_unsaturate_photo(SC,'BSI');
    FOV.conf_ints_fixed(:,:,iy,ix) = I;
    if(mod(i_p,min(N_conf_x,N_conf_y))==0)
        I = squeeze(mean(FOV.conf_ints_fixed(n_save+1-i_windw:n_save+1+i_windw,n_save+1-i_windw:n_save+1+i_windw,:,:),[1 2]));
        figure(124155);imagesc(I);title(['Corrected. index: ' num2str(i_p) ' of: ' num2str(num_points)]);
    end
end
SC = laser_off(SC);
I = squeeze(mean(FOV.conf_ints_fixed(n_save+1-i_windw:n_save+1+i_windw,n_save+1-i_windw:n_save+1+i_windw,:,:),[1 2]));
figure(124155);imagesc(I);title(['Corrected. index: ' num2str(i_p) ' of: ' num2str(num_points)]);
tgfigure(124155);
%% unfixed
SC = laser_on(SC);
this_f=double(SC.mask_f_laser);
mat_flag = 1;
py_flag = 1;
for i_p = 1:num_points
    [iy, ix] = ind2sub([N_conf_y N_conf_x],FOV.conf_scan_order(i_p));
    tilt_x=conf_tilts_x(ix);
    tilt_y=conf_tilts_y(iy);
    SC.ramps.fx_laser=fx_laser_0+tilt_x;
    SC.ramps.fy_laser=fy_laser_0+tilt_y;
    SC.ramps.fx_cam=fx_cam_0-tilt_x;
    SC.ramps.fy_cam=fy_cam_0-tilt_y;
    activate_func(SC,this_f,mat_flag,py_flag);
    I = take_unsaturate_photo(SC,'BSI');
    FOV.conf_ints_unfixed(:,:,iy,ix) = I;
    if(mod(i_p,min(N_conf_x,N_conf_y))==0)
        I = squeeze(mean(FOV.conf_ints_unfixed(n_save+1-i_windw:n_save+1+i_windw,n_save+1-i_windw:n_save+1+i_windw,:,:),[1 2]));
        figure(12415);imagesc(I);title(['Unorrected. index: ' num2str(i_p) ' of: ' num2str(num_points)]);
    end
end
%% finish
SC = laser_off(SC);
SC.ramps.fx_laser = fx_laser_0;
SC.ramps.fy_laser = fy_laser_0;
OPT_S.f_fin = f_fin_0;
%% figures
%  show uncorrected confocal images
for i_windw = 0:3
    I = squeeze(mean(FOV.conf_ints_unfixed(n_save+1-i_windw:n_save+1+i_windw,n_save+1-i_windw:n_save+1+i_windw,:,:),[1 2]));
    figure;imagesc(I);title(['Uncorrected. mean window: ' num2str(i_windw)])
end
%  show confocal images
for i_windw = 0:3
    I = squeeze(mean(FOV.conf_ints_fixed(n_save+1-i_windw:n_save+1+i_windw,n_save+1-i_windw:n_save+1+i_windw,:,:),[1 2]));
    figure;imagesc(I);title(['Corrected. mean window: ' num2str(i_windw)])
end

