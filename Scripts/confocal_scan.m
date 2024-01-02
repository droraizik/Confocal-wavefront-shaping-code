disp('remove ND');
keyboard;
confocal_f_fins.is_tm = OPT_S.is_tm;
if(confocal_f_fins.is_tm == 0)
    f_fin_las_0 = OPT_S.f_fin.*SC.mask_f_laser;
    f_fin_cam_0 = OPT_S.f_fin.*SC.mask_f_laser;
else
    f_fin_las_0 = OPT_S.f_fin_las.*SC.mask_f_laser;
    f_fin_cam_0 = OPT_S.f_fin_cam.*SC.mask_f_laser;
end
confocal_f_fins.is_tm = 1;
confocal_f_fins.SLM_mat_flag = 1;
confocal_f_fins.SLM_py_flag = 1;
confocal_f_fins.SLM_flag_nearest = 1;


SC=set_refocus_ramps(SC,OPT_S);
fx_laser_0 = SC.ramps.fx_laser;
fy_laser_0 = SC.ramps.fy_laser;
fx_cam_0 = SC.ramps.fx_cam;
fy_cam_0 = SC.ramps.fy_cam;
SC=change_exposure(SC,'BSI',SC.BSI_settings.confocal_exp);

%% check confocal images
SC = laser_on(SC);
SC = change_camera_ROI(SC,'BSI',SC.c0,SC.r0,OPT_S.n_cap);
scale_t=0.05;
FOV.tilt_xs = [0 0 0 scale_t -scale_t];
FOV.tilt_ys = [0 scale_t -scale_t 0 0];
num_ts = length(FOV.tilt_xs);
FOV.confocal_00_im=zeros(2*OPT_S.n_cap+1);
for i_tilt=1:num_ts
    tilt_x = FOV.tilt_xs(i_tilt);
    tilt_y = FOV.tilt_ys(i_tilt);
    SC.ramps.fx_laser=fx_laser_0+tilt_x;
    SC.ramps.fy_laser=fy_laser_0+tilt_y;
    SC.ramps.fx_cam=fx_cam_0-tilt_x;
    SC.ramps.fy_cam=fy_cam_0-tilt_y;
    
    confocal_f_fins.f_fin_las = circshift(f_fin_las_0,round([FOV.shift_alpha*tilt_y/SC.df FOV.shift_alpha*tilt_x/SC.df]));
    confocal_f_fins.f_fin_cam = circshift(f_fin_cam_0,round([FOV.shift_alpha*tilt_y/SC.df FOV.shift_alpha*tilt_x/SC.df]));
    
    activate_func_had_fin(SC,confocal_f_fins);
    I = take_unsaturate_photo(SC,'BSI');
    figure;imagesc(I);title('BSI')
    FOV.confocal_00_im(:,:,i_tilt) = I;
end
figure;imagesc(OPT_S.fin_BSI);title('last image from BSI')
disp('check images');
keyboard;
%% confocal settings
n_conf = FOV.n_conf;
d_conf_x = FOV.d_conf_pix;
d_conf_y = FOV.d_conf_pix;
N_conf_x = 2*FOV.n_conf+1;
N_conf_y = 2*FOV.n_conf+1;
num_points = N_conf_y*N_conf_x;
FOV.conf_scan_order = 1:num_points;

n_save = FOV.confocal_n_save;
SC.r0=OPT_S.cam_00(1);
SC.c0=OPT_S.cam_00(2);

if(isfield(FOV,'conf_scan_order_str'))
    if(strcmp(FOV.conf_scan_order_str,'x_cont'))
        N_conf_y = (N_conf_y-1)/FOV.res_non_cont+1;
        d_conf_y = FOV.res_non_cont*d_conf_y;
        num_points = N_conf_x*N_conf_y;
        FOV.conf_scan_order=reshape(reshape(1:num_points,N_conf_y,N_conf_x)',num_points,1);
    elseif(strcmp(FOV.conf_scan_order_str,'y_cont'))
        N_conf_x = (N_conf_x-1)/FOV.res_non_cont+1;
        d_conf_x = FOV.res_non_cont*d_conf_x;
        num_points = N_conf_x*N_conf_y;
        FOV.conf_scan_order = 1:num_points;
    elseif(strcmp(FOV.conf_scan_order_str,'rand'))
        FOV.conf_scan_order = randperm(num_points);
    end
end

conf_tilts_x = (-n_conf:d_conf_x:n_conf)*SC.dx;
conf_tilts_y = (-n_conf:d_conf_y:n_conf)*SC.dx;
SC=change_camera_ROI(SC,'BSI',SC.c0,SC.r0,n_save);

FOV.conf_ints_fixed = zeros(n_save*2+1,n_save*2+1,N_conf_y,N_conf_x);
FOV.conf_ints_unfixed = zeros(n_save*2+1,n_save*2+1,N_conf_y,N_conf_x);

i_windw = 1;

SC=change_camera_ROI(SC,'BSI',SC.c0,SC.r0,n_save);

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
    confocal_f_fins.f_fin_las = circshift(f_fin_las_0,round([FOV.shift_alpha*tilt_y/SC.df FOV.shift_alpha*tilt_x/SC.df]));
    confocal_f_fins.f_fin_cam = circshift(f_fin_cam_0,round([FOV.shift_alpha*tilt_y/SC.df FOV.shift_alpha*tilt_x/SC.df]));
    activate_func_had_fin(SC,confocal_f_fins);
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
tgfigure(12415);

SC = laser_off(SC);
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

SC=set_refocus_ramps(SC,OPT_S);
