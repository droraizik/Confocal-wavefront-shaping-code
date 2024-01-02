SC = flip_m(SC,'ND');
SC = change_exposure(SC,'PG',SC.PG_settings.ND_exp);
SC= laser_set(SC.laser_settings.laser_PG_ND,SC);
SC = set_refocus_ramps(SC,OPT_S);
%% settings
if(OPT_S.is_tm==1)
    f_fin = OPT_S.f_fin_las.*SC.mask_f_laser;
else
    f_fin = OPT_S.f_fin.*SC.mask_f_laser;
end

num_tilts = length(FOV.TS_scan);
FOV.conf_images=zeros(SC.N_PG,SC.N_PG,num_tilts,4);
SC = set_refocus_ramps(SC,OPT_S);
fx_laser_0 = SC.ramps.fx_laser;
fy_laser_0 = SC.ramps.fy_laser;

%% show final confocal images
SC = laser_set(SC.laser_settings.laser_power,SC);
SC = change_exposure(SC,'PG',SC.PG_settings.ND_scan_exp);
SC = laser_on(SC);
thetas = [0 45 90 135];
for i_theta = 1:4
    FOV.theta_deg = thetas(i_theta);
    tilt_xs_conf = cosd(-FOV.theta_deg)*FOV.TS_scan;
    tilt_ys_conf = sind(-FOV.theta_deg)*FOV.TS_scan;
    maxes_fin=zeros(num_tilts,1);
    for i_ramp = 1:num_tilts
        tilt_x=tilt_xs_conf(i_ramp);
        tilt_y=tilt_ys_conf(i_ramp);
        f=circshift(f_fin,round([FOV.shift_alpha*tilt_y/SC.df FOV.shift_alpha*tilt_x/SC.df]));
        SC.ramps.fx_laser=fx_laser_0+tilt_x;
        SC.ramps.fy_laser=fy_laser_0+tilt_y;
        activate_func(SC,f,1,0,1);
%         I = take_fixed_photo(SC,'PG',SC.PG_settings.ND_mean);
        I = take_photo_val(SC,'PG',SC.PG_settings.ND_mean);
        figure(12415);imagesc(I);title(['tilt: ' num2str(FOV.TS_scan(i_ramp))]);
        FOV.conf_images(:,:,i_ramp,i_theta) = I;
        [~,~,maxes_fin(i_ramp)] = max_rc(I,1);
    end
    figure;plot(maxes_fin);title(FOV.shift_alpha)
end
SC = laser_off(SC);
