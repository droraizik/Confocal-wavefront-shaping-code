%scan ramps using tilt shifts
SC = set_PG_ND(SC);
%% settings
f_fin = OPT_S.f_fin.*SC.mask_f_laser;
num_tilts = length(FOV.TS_scan);
FOV.conf_images=zeros(SC.N_PG,SC.N_PG,num_tilts,4);
fx_laser_0 = SC.ramps.fx_laser;
fy_laser_0 = SC.ramps.fy_laser;

%% scan ramps
SC = laser_on(SC);
thetas = [0 45 90 135];                                         %degrees to scan
for i_theta = 1:4
    theta_deg = thetas(i_theta);
    tilt_xs_conf = cosd(theta_deg)*FOV.TS_scan;
    tilt_ys_conf = sind(theta_deg)*FOV.TS_scan;
    maxes_fin=zeros(num_tilts,1);
    for i_ramp = 1:num_tilts
        tilt_x=tilt_xs_conf(i_ramp);
        tilt_y=tilt_ys_conf(i_ramp);
        f=circshift(f_fin,round([FOV.shift_alpha*tilt_y/SC.df FOV.shift_alpha*tilt_x/SC.df]));
        SC.ramps.fx_laser=fx_laser_0+tilt_x;
        SC.ramps.fy_laser=fy_laser_0+tilt_y;
        activate_func(SC,f,1,0,1);
        I = take_unsaturate_photo(SC,'PG',SC.PG_settings.ND_mean);
        figure(12415);imagesc(I);title(['tilt: ' num2str(FOV.TS_scan(i_ramp))]);
        FOV.conf_images(:,:,i_ramp,i_theta) = I;
        [~,~,maxes_fin(i_ramp)] = max_rc(I,1);
    end
    figure;plot(maxes_fin);title(FOV.shift_alpha)
end
SC = laser_off(SC);
SC.ramps.fx_laser = fx_laser_0;
SC.ramps.fy_laser = fy_laser_0;
