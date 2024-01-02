function SC = set_PG_ND(SC)
SC = flip_m(SC,'ND');
SC = change_exposure(SC,'PG',SC.PG_settings.ND_exp);
SC = laser_set(SC.laser_settings.laser_PG_ND,SC);
