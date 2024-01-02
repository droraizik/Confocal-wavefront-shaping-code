%find tilt shift parameter using the val. camera
SC = set_PG_ND(SC);
%% settings
theta_deg = 0;
tilt_xs_conf = cosd(theta_deg)*FOV.TS_ramps_alpha;
tilt_ys_conf = sind(theta_deg)*FOV.TS_ramps_alpha;
f_fin = OPT_S.f_fin.*SC.mask_f_laser;
num_tilts = length(tilt_xs_conf);
num_shifts = length(FOV.TS_shifts_alpha);
FOV.I_maxes_conf = zeros(num_shifts,num_tilts);
fx_laser_0 = SC.ramps.fx_laser;
fy_laser_0 = SC.ramps.fy_laser;


%% scan tilt shift ratios
SC = laser_on(SC);
for i_ramp = 1:num_tilts
    tilt_x=tilt_xs_conf(i_ramp);
    tilt_y=tilt_ys_conf(i_ramp);
    SC.ramps.fx_laser=fx_laser_0+tilt_x;
    SC.ramps.fy_laser=fy_laser_0+tilt_y;
    for i_shft = 1:num_shifts
        f=circshift(f_fin,round([0 FOV.TS_shifts_alpha(i_shft)/SC.df]));
        activate_func(SC,f,1,0,1);
        I = take_fixed_photo(SC,'PG',SC.PG_settings.ND_mean);
        figure(12415);imagesc(I);title(['tilt x: ' num2str(FOV.TS_ramps_alpha(i_ramp)) ', shift: ' num2str(FOV.TS_shifts_alpha(i_shft))]);colorbar;
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
[~,maxinds]=max(FOV.I_maxes_conf);
Y = FOV.TS_shifts_alpha(maxinds)';
H = [tilt_xs_conf;ones(size(tilt_xs_conf))]';
X = H\Y;
FOV.shift_alpha = X(1);

figure;imagesc(FOV.TS_ramps_alpha,FOV.TS_shifts_alpha,FOV.I_maxes_conf);xlabel('tilts');ylabel('shifts');hold on
plot(FOV.TS_ramps_alpha,FOV.shift_alpha*FOV.TS_ramps_alpha+X(2),'-r');title(['Shift alpha is: ' num2str(FOV.shift_alpha)])
