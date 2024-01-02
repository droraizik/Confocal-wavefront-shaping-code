SC = laser_on(SC);
OPT_S2.SLM_mat_flag = 1;
OPT_S2.SLM_py_flag = 0;
activate_func_had_fin(SC,OPT_S2);
%% BP
SC = set_PG_BP(SC);
OPT_S2.fin_PG_BP = take_fixed_photo(SC,'PG',SC.PG_settings.BP_mean);
figure;imagesc(OPT_S2.fin_PG_BP);title('final PG beads - two masks');

%% ND
fx_laser_0 = SC.ramps.fx_laser;
SC.ramps.fx_laser = fx_laser_0+OPT_S.ND_ts_x;
f_fin0 = OPT_S2.f_fin_las;
OPT_S2.f_fin_las=circshift(f_fin0,round([0 OPT_S.ND_ts_x*FOV.shift_alpha/SC.df]));
activate_func_had_fin(SC,OPT_S2);
SC = set_PG_ND(SC);
I = take_fixed_photo(SC,'PG',SC.PG_settings.ND_mean);
OPT_S2.fin_PG_ND = I;
figure;imagesc(OPT_S2.fin_PG_ND);title('final PG speckles - two masks');
OPT_S2.f_fin_las = f_fin0;
SC.ramps.fx_laser = fx_laser_0;

%%
SC = set_PG_BP(SC);
disp('remove ND');
keyboard;
I = capture_PG_pseudo_incoherent(SC,OPT_S.num_images_inc_beads,OPT_S.radius_inc_beads,'original incoherent beads');
disp('restore ND');
keyboard;
OPT_S.fin_inc_beads = I;

