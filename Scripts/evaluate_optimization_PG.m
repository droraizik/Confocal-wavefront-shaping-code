%evaluate the optimization in validation camera
SC = laser_on(SC);
OPT_S.las_SLM_flag = 1;
OPT_S.cam_SLM_flag = 0;
activate_func_had_fin(SC,OPT_S);                                                %set final function on laser SLM                             
%% fluorescence
SC = set_PG_BP(SC);                                                             %set val. camera to fluor.
OPT_S.fin_PG_BP = take_unsaturate_photo(SC,'PG',SC.PG_settings.BP_mean*3);      %capture final image
figure;imagesc(OPT_S.fin_PG_BP);title('final PG fluor');
%% laser
SC = set_PG_ND(SC);                                                             %set val. camera to laser
OPT_S.fin_PG_ND = take_unsaturate_photo(SC,'PG',SC.PG_settings.ND_mean);
figure;imagesc(OPT_S.fin_PG_ND);title('final PG speckles');
