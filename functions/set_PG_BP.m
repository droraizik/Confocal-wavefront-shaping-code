function SC = set_PG_BP(SC)
SC = flip_m(SC,'BP');
SC = change_exposure(SC,'PG',SC.PG_settings.BP_exp);
SC = laser_set(SC.laser_settings.laser_PG_BP,SC);
