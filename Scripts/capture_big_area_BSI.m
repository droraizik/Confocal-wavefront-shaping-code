if(OPT_S.is_tm == 0)
    f_fin = OPT_S.f_fin.*SC.mask_f_cam;
else
    f_fin = OPT_S.f_fin_cam.*SC.mask_f_cam;
end
delta_r = OPT_S2.cam_00(1)-OPT_S1.cam_00(1);
delta_c = OPT_S2.cam_00(2)-OPT_S1.cam_00(2);
FOV.ramp_offset_r = round(delta_r/2);
FOV.ramp_offset_c = round(delta_c/2);
FOV.max_ramp_y = max(abs((2*FOV.ramp_offset_r)*SC.dx),40*SC.dx);
FOV.max_ramp_x = max(abs((2*FOV.ramp_offset_c)*SC.dx),40*SC.dx);
FOV.max_ramp_y = ceil(FOV.max_ramp_y/FOV.d_ramp)*FOV.d_ramp;
FOV.max_ramp_x = ceil(FOV.max_ramp_x/FOV.d_ramp)*FOV.d_ramp;
ramp_max = max(FOV.max_ramp_x,FOV.max_ramp_y);
n_big_area = round(ramp_max/SC.dx*2);
N_big_area = 2*n_big_area+1;

SC.r0=OPT_S1.cam_00(1)+FOV.ramp_offset_r;
SC.c0=OPT_S1.cam_00(2)+FOV.ramp_offset_c;
SC = flip_m(SC,'BP');
%% settings
ramps_big_fov_x = (-FOV.max_ramp_x :FOV.d_ramp :FOV.max_ramp_x)+FOV.ramp_offset_c*SC.dx;
ramps_big_fov_y = (-FOV.max_ramp_y :FOV.d_ramp :FOV.max_ramp_y)+FOV.ramp_offset_r*SC.dx;
num_ramps_fov_x = length(ramps_big_fov_x);
num_ramps_fov_y = length(ramps_big_fov_y);

FOV.big_FOV_fixed_finish_alg_high=zeros(N_big_area,N_big_area,num_ramps_fov_x,num_ramps_fov_y,FOV.big_area_mean_num);
FOV.big_FOV_unfixed_finish_high=zeros(N_big_area,N_big_area,num_ramps_fov_x,num_ramps_fov_y,FOV.big_area_mean_num);
Kfs = zeros(SC.N,SC.N,FOV.big_area_mean_num);
for i_mask = 1:FOV.big_area_mean_num
    Kfs(:,:,i_mask)=squeeze(create_rand_phases(SC,1,FOV.d_ramp*FOV.big_area_scale/SC.dx));
end


%% set power, exposure and FOV
SC = change_camera_ROI(SC,'BSI',SC.c0,SC.r0,n_big_area);
SC = change_exposure(SC,'BSI',SC.BSI_settings.big_FOV_exp);
SC = laser_set(SC.laser_settings.laser_big_FOV,SC);


%% Corrected
SC = laser_on(SC);
SC = set_refocus_ramps(SC,OPT_S1);
fx_laser_0 = SC.ramps.fx_laser;
fy_laser_0 = SC.ramps.fy_laser;

for ix = 1:num_ramps_fov_x
    for iy = 1:num_ramps_fov_y
        tilt_x = ramps_big_fov_x(ix);
        tilt_y = ramps_big_fov_y(iy);
        this_shift_x = round((tilt_x-OPT_S.offset_from_00_c*SC.dx)*FOV.shift_alpha/SC.df);
        this_shift_y = round((tilt_y-OPT_S.offset_from_00_r*SC.dx)*FOV.shift_alpha/SC.df);
        this_f=circshift(f_fin,[this_shift_y this_shift_x]);
        activate_func(SC,this_f,0,1,1);   %only in camera SLM
        
        SC.ramps.fx_laser=fx_laser_0+tilt_x;
        SC.ramps.fy_laser=fy_laser_0+tilt_y;
        for i_mask = 1:FOV.big_area_mean_num
            Kf=Kfs(:,:,i_mask);
            activate_func(SC,Kf,1,0,0);   %only in laser SLM
            I = take_unsaturate_photo(SC,'BSI');
            figure(5152);imagesc(I);title(['corrected. ix: ' num2str(ix) ' of: ' num2str(num_ramps_fov_x) ' , iy ' num2str(iy) ', of: ' num2str(num_ramps_fov_y) '. mask: ' num2str(i_mask) ' of: ' num2str(FOV.big_area_mean_num)]);
            FOV.big_FOV_fixed_finish_alg_high(:,:,ix,iy,i_mask)=I;
        end
    end
end
FOV.big_FOV_fixed_finish_alg_high = mean(FOV.big_FOV_fixed_finish_alg_high,5);
SC = laser_off(SC);
%% Uncorrected
SC = laser_on(SC);
SC=set_ramps(SC);
fx_laser_0 = SC.ramps.fx_laser;
fy_laser_0 = SC.ramps.fy_laser;
activate_func(SC,double(SC.mask_f_laser),0,1);   %only in camera SLM
% for ix = 1:num_ramps_fov_x
%     for iy = 1:num_ramps_fov_y
%         tilt_x = ramps_big_fov_x(ix);
%         tilt_y = ramps_big_fov_y(iy);
%         SC.ramps.fx_laser=fx_laser_0+tilt_x;
%         SC.ramps.fy_laser=fy_laser_0+tilt_y;
%         for i_mask = 1:FOV.big_area_mean_num
%             Kf=Kfs(:,:,i_mask);
%             activate_func(SC,Kf,1,0);   %only in laser SLM
%             I = take_unsaturate_photo(SC,'BSI');
%             figure(5152);imagesc(I);title(['Uncorrected. ix: ' num2str(ix) ' of: ' num2str(num_ramps_fov_x) ' , iy ' num2str(iy) ', of: ' num2str(num_ramps_fov_y) '. mask: ' num2str(i_mask) ' of: ' num2str(FOV.big_area_mean_num)]);
%             FOV.big_FOV_unfixed_finish_high(:,:,ix,iy,i_mask)=I;
%         end
%     end
% end
FOV.big_FOV_unfixed_finish_high = mean(FOV.big_FOV_unfixed_finish_high,5);

SC = laser_off(SC);
SC = laser_set(SC.laser_settings.laser_power,SC);

