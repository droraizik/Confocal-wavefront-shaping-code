
%% Ground truth from validation
SC = set_PG_BP(SC);
SC = laser_set(SC.laser_settings.laser_big_FOV,SC);
I = capture_PG_area_ramps(SC,OPT_S.max_ramp_PG,OPT_S.d_ramp_PG,'Ground Truth');
FOV.big_FOV_PG_finish = I;
figure;imagesc(I);title('Big area PG');
%% Ground truth from main
disp('Remove ND filter')
keyboard;
SC = laser_on(SC);
SC = change_exposure(SC,'BSI',SC.BSI_settings.big_FOV_exp);
SC = change_camera_ROI(SC,'BSI',SC.c0,SC.r0,OPT_S.n_FOV);
OPT_S.big_area_BSI_init = zeros(OPT_S.n_FOV*2+1,OPT_S.n_FOV*2+1,OPT_S.num_rand_BSI);
for i_rand = 1:OPT_S.num_rand_BSI
    rand_laser(SC,OPT_S.rand_BSI_rad);
    I = take_unsaturate_photo(SC,'BSI',2);
    OPT_S.big_area_BSI_init(:,:,i_rand) = I;
    figure(135109);imagesc(mean(OPT_S.big_area_BSI_init,3));
end
OPT_S.big_area_BSI_init = mean(OPT_S.big_area_BSI_init,3);
disp('Restore ND filter')
keyboard;
