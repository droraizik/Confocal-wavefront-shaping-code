if(OPT_S.tm_is_alternate == 0)
    %% BP
    SC = set_PG_BP(SC);
    OPT_S.SLM_mat_flag = 1;
    OPT_S.py_mat_flag = 0;
    activate_func_had_fin(SC,OPT_S);
    OPT_S.fin_PG_BP_mid = take_fixed_photo(SC,'PG',SC.PG_settings.BP_mean);
    %% ND
    SC = set_PG_ND(SC);
    I = take_fixed_photo(SC,'PG',SC.PG_settings.ND_mean);
    OPT_S.fin_PG_ND_mid = I;
else
    %% BP
    SC = set_PG_BP(SC);
    OPT_S2.SLM_mat_flag = 1;
    OPT_S2.py_mat_flag = 0;
    activate_func_had_fin(SC,OPT_S2);
    OPT_S2.fin_PG_BP_mid = take_fixed_photo(SC,'PG',SC.PG_settings.BP_mean);
    %% ND
    SC = set_PG_ND(SC);
    I = take_fixed_photo(SC,'PG',SC.PG_settings.ND_mean);
    OPT_S2.fin_PG_ND_mid = I;
    %% PG Incoherent beads
    SC = set_PG_BP(SC);
    I = capture_PG_pseudo_incoherent(SC,OPT_S.num_images_inc_beads,OPT_S.radius_inc_beads,'mid incoherent beads');
    OPT_S2.mid_inc_beads = I;

end
SC = laser_set(SC.laser_settings.laser_power,SC);
