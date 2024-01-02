function SC=init_system(SC)
%% ramps
SC.N_PG=2*SC.n_PG+1;
n=SC.n;
SC.r0 = 1046;                                           %main camera 00
SC.c0 = 953;                                            %main camera 00

SC.ramp_fx_laser=1;                                     %DC offset laser SLM x
SC.ramp_fy_laser=0;                                     %DC offset laser SLM y
SC.ramp_fx_cam=0;                                       %DC offset camera SLM x
SC.ramp_fy_cam=1;                                       %DC offset camera SLM y

SC.ramps.fx_laser=SC.ramp_fx_laser;
SC.ramps.fy_laser=SC.ramp_fy_laser;
SC.ramps.fx_cam=SC.ramp_fx_cam;
SC.ramps.fy_cam=SC.ramp_fy_cam;



%% Motors
%initialize flip mount
%% Cameras
%initialize cameras
%% SLMs
%initialize SLMs
SC.ROI_laser.rad = 300;             %number of pixels in radius of effective SLM area
SC.ROI_cam.rad = 300;               %number of pixels in radius of effective SLM area
%% working grids

SC.dx=6.5e-3;                               %BSI pixel size
SC.x=(-n:n)*SC.dx;                          %BSI pixels grid
[SC.gx,SC.gy]=meshgrid(SC.x);
Rx=(2*n+1)*SC.dx;

SC.df=1/Rx;                                 %matlab df
SC.f=(-n:n)*SC.df;                          %matlab f grid
[SC.gfx,SC.gfy]=meshgrid(SC.f);
[SC.theta_f,SC.r_f] = cart2pol(SC.gfx,SC.gfy);


ds=8e-3;                                                                    %pixel size in both SLMs, units - mm
best_s_laser=17.5;                                                          %scale - laser SLM to main camera

SC.mask_rad_laser=SC.ROI_laser.rad*ds*best_s_laser;                         %radius of binary mask in SLM grid (units - 1/mm)
SC.s_laser=(-SC.ROI_laser.rad:SC.ROI_laser.rad)*ds*best_s_laser;
[SC.gsx_laser,SC.gsy_laser]=meshgrid(SC.s_laser);
SC.r_s_laser=sqrt(SC.gsx_laser.^2+SC.gsy_laser.^2);
SC.mask_f_laser=SC.r_f<SC.mask_rad_laser;                                   %binary mask in matlab grid


best_s_cam=13.23;                                                           %for cam SLM
SC.mask_rad_cam=SC.ROI_cam.rad*ds*best_s_cam;                               %radius of binary mask in SLM grid (units - 1/mm)
s_cam=(-SC.ROI_cam.rad:SC.ROI_cam.rad)*ds*best_s_cam;
[SC.gsx_cam,SC.gsy_cam]=meshgrid(s_cam);
SC.r_s_cam=sqrt(SC.gsx_cam.^2+SC.gsy_cam.^2);
SC.mask_f_cam=SC.r_f<SC.mask_rad_cam;                                       %binary mask in matlab grid



%%
SC.x_PG=(-SC.n_PG:SC.n_PG)*3.69e-3*24/20;
SC.N=2*n+1;

