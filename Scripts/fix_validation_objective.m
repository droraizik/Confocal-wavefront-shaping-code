tgprintf('fix validation objective')
%fix validation objective
SC = flip_m(SC,'BP');
activate_func(SC,double(SC.mask_f_laser),1,0,0);
shutter_transmit(SC);
SC = laser_off(SC);
imaqreset;
!cd C:\Program Files\Point Grey Research\FlyCap2 Viewer\bin64 & "Point Grey FlyCap2.exe" &exit&
keyboard;       
SC = change_exposure(SC,'PG',SC.PG_settings.BP_exp);
SC = set_refocus_ramps(SC,OPT_S);
SC = change_camera_ROI(SC,'BSI',SC.c0,SC.r0,OPT_S.n_cap);
SC = change_exposure(SC,'BSI',OPT_S.this_exp);
SC = laser_on(SC);