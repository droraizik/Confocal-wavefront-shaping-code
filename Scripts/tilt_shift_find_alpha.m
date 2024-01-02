%find tilt shift parameter using the val. camera
SC = set_PG_ND(SC);
%% settings
tilt_xs_conf = FOV.TS_ramps_alpha;                      %ramps in x axis
tilt_ys_conf = zeros(size(tilt_xs_conf));               %ramps in y axis
f_fin = OPT_S.f_fin.*SC.mask_f_laser;                   %final function
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
    SC.ramps.fx_laser=fx_laser_0+tilt_x;                %set ramp x
    SC.ramps.fy_laser=fy_laser_0+tilt_y;                %set ramp y
    for i_shft = 1:num_shifts
        f=circshift(f_fin,round([0 FOV.TS_shifts_alpha(i_shft)/SC.df]));            %circshift function
        activate_func(SC,f,1,0,1);                                                  %activate new function
        I = take_unsaturate_photo(SC,'PG',SC.PG_settings.ND_mean);                  %capture 
%         figure(12415);imagesc(I);                       
        title(['tilt x: ' num2str(FOV.TS_ramps_alpha(i_ramp))...
            ', shift: ' num2str(FOV.TS_shifts_alpha(i_shft))]);
        [~,~,maxval] = max_rc(I,1);                                                 %find maximum                    
        FOV.I_maxes_conf(i_shft,i_ramp) = maxval;                                   
    end
end
SC.ramps.fx_laser = fx_laser_0;
SC.ramps.fy_laser = fy_laser_0;

%% Calculate tilt shift parameter
[~,maxinds]=max(FOV.I_maxes_conf);
Y = FOV.TS_shifts_alpha(maxinds)';
H = [tilt_xs_conf;ones(size(tilt_xs_conf))]';
X = H\Y;
FOV.shift_alpha = X(1);                         %this is the Tilt shift parameter

figure;imagesc(FOV.TS_ramps_alpha,FOV.TS_shifts_alpha,FOV.I_maxes_conf);xlabel('tilts');ylabel('shifts');hold on
plot(FOV.TS_ramps_alpha,FOV.shift_alpha*FOV.TS_ramps_alpha+X(2),'-r');title(['Shift alpha is: ' num2str(FOV.shift_alpha)])
