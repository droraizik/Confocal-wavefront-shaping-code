SC = flip_m(SC,'ND');
SC = change_exposure(SC,'PG',SC.PG_settings.ND_exp);
SC = laser_set(SC.laser_settings.laser_PG_ND,SC);
SC = load_ROIs(SC);
SC=set_ramps(SC);
%% settings
tilt_xs_conf = cosd(FOV.theta_deg)*FOV.TS_ramps_alpha;
tilt_ys_conf = sind(FOV.theta_deg)*FOV.TS_ramps_alpha;

if(OPT_S.is_tm==1)
    f_fin = OPT_S.f_fin_las;
else
    f_fin = OPT_S.f_fin;
end

num_tilts = length(tilt_xs_conf);
num_shifts = length(FOV.TS_shifts_alpha);
FOV.I_maxes_conf = zeros(num_shifts,num_tilts);
SC=set_ramps(SC);
fx_laser_0 = SC.ramps.fx_laser;
fy_laser_0 = SC.ramps.fy_laser;
las_col0 = SC.ROI_laser.col0;
las_row0 = SC.ROI_laser.row0;


%% scan tilt shift ratios
ND_mean = 1;
SC = laser_on(SC);
for i_ramp = 1:num_tilts
    tilt_x=tilt_xs_conf(i_ramp);
    tilt_y=tilt_ys_conf(i_ramp);
    SC.ramps.fx_laser=fx_laser_0+tilt_x;
    SC.ramps.fy_laser=fy_laser_0+tilt_y;
    for i_shft = 1:num_shifts
%         f=circshift(f_fin,round([0 FOV.TS_shifts_alpha(i_shft)/SC.df]));
%         SC.ROI_laser.col0 = las_col0+FOV.TS_shifts_alpha(i_shft);
        SC.ROI_laser.row0 = las_row0+FOV.TS_shifts_alpha(i_shft);

        activate_func(SC,f_fin,1,0,1);
        I = take_fixed_photo(SC,'PG',ND_mean);
        figure(12415);imagesc(I);title(['tilt: ' num2str(FOV.TS_ramps_alpha(i_ramp)) ', shift: ' num2str(FOV.TS_shifts_alpha(i_shft))]);colorbar;
        [r,c,maxval] = max_rc(I,1);
        if(r==1 || r == SC.N_PG)
            r=SC.n_PG+1;
        end
        if(c==1 || c == SC.N_PG)
            c=SC.n_PG+1;
        end
        FOV.I_maxes_conf(i_shft,i_ramp) = maxval;
    end
end
%% Calculate alpha
FOV.I_maxes_conf = imgaussfilt(FOV.I_maxes_conf,[2 0.001]);
idx_0 = find(FOV.TS_ramps_alpha == 0);
ramp_no_zero = FOV.TS_ramps_alpha([1:idx_0-1 idx_0+1:end]);
I_maxes_conf_no_zero = FOV.I_maxes_conf(:,[1:idx_0-1 idx_0+1:end]);

[~,maxinds]=max(I_maxes_conf_no_zero);
Y = FOV.TS_shifts_alpha(maxinds)';
H = [ramp_no_zero;ones(size(ramp_no_zero))]';
X = H\Y;
FOV.shift_alpha_laser = X(1);
figure;imagesc(FOV.TS_ramps_alpha,FOV.TS_shifts_alpha,FOV.I_maxes_conf);xlabel('tilts');ylabel('shifts');hold on

plot(FOV.TS_ramps_alpha,FOV.shift_alpha_laser*FOV.TS_ramps_alpha+X(2),'-r');title(['Shift alpha is: ' num2str(FOV.shift_alpha_laser)])
FOV.shift_alpha_cam = FOV.shift_alpha_laser*1.25;