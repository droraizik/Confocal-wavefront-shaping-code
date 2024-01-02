SC = flip_m(SC,'ND');
SC = change_exposure(SC,'PG',SC.PG_settings.ND_exp);
SC = laser_set(SC.laser_settings.laser_PG_ND,SC);
%% settings
tilt_xs_conf = cosd(FOV.theta_deg)*FOV.TS_scan;
tilt_ys_conf = sind(FOV.theta_deg)*FOV.TS_scan;

if(OPT_S.is_tm==1)
    f_fin = OPT_S.f_fin_las;
else
    f_fin = OPT_S.f_fin;
end

num_tilts = length(tilt_xs_conf);
FOV.conf_images=zeros(SC.N_PG,SC.N_PG,num_tilts);
SC=set_ramps(SC);
SC = load_ROIs(SC);

fx_laser_0 = SC.ramps.fx_laser;
fy_laser_0 = SC.ramps.fy_laser;
las_col0 = SC.ROI_laser.col0;
las_row0 = SC.ROI_laser.row0;


%% show final confocal images
SC = laser_on(SC);
maxes_fin=zeros(num_tilts,1);
for i_ramp = 1:num_tilts
    tilt_x=tilt_xs_conf(i_ramp);
    tilt_y=tilt_ys_conf(i_ramp);

    this_shift_x = round(tilt_x*FOV.shift_alpha_laser);
    this_shift_y = round(tilt_y*FOV.shift_alpha_laser);
    SC.ROI_laser.col0 = las_col0-this_shift_x;
    SC.ROI_laser.row0 = las_row0+this_shift_y;

    SC.ramps.fx_laser=fx_laser_0+tilt_x;
    SC.ramps.fy_laser=fy_laser_0+tilt_y;
    activate_func(SC,f_fin,1,0,1);
    I = take_fixed_photo(SC,'PG',SC.PG_settings.ND_mean);
    figure(12415);imagesc(I);title(['tilt: ' num2str(FOV.TS_scan(i_ramp))]);
    FOV.conf_images(:,:,i_ramp) = I;
    [~,~,maxes_fin(i_ramp)] = max_rc(I,1);
end
figure;plot(maxes_fin);title(FOV.shift_alpha_laser)
SC = laser_off(SC);
