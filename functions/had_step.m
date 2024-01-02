function OPT_S = had_step(SC,OPT_S,HAD_S)
ind_it=OPT_S.ind_it;
OPT_S.las_SLM_flag = 1;
OPT_S.cam_SLM_flag = 1;
f_fin = OPT_S.f_fin;
num_phases = OPT_S.num_phases;
phases = OPT_S.phases;


%% fit sinus
ind_mask=mod(ind_it-1,HAD_S.total_its)+1;
mask_f = had_get_mask(SC,HAD_S,ind_mask);
for p=2:num_phases
    f0=f_fin.*(mask_f.^phases(p));
    activate_func(SC,f0,OPT_S.las_SLM_flag,OPT_S.cam_SLM_flag,OPT_S.SLM_flag_nearest);
    I=take_unsaturate_photo(SC,'BSI');
    OPT_S.ints(p)=sum_middle(I,OPT_S.mid_pix,OPT_S.mask_wind);
end
theta_max = had_fit_sin(OPT_S,OPT_S.ints);
%% update final function and save values

best_f = mask_f.^(theta_max);
best_f(isinf(best_f))=0;
OPT_S.f_fin = f_fin.*best_f;
OPT_S.f_fins(:,:,ind_it)=interp2(SC.gfx,SC.gfy,angle(OPT_S.f_fin),HAD_S.XM_int,HAD_S.YM_int,'nearest',0);
OPT_S.total_ints(:,OPT_S.ind_total_ints) = OPT_S.ints;
OPT_S.ind_total_ints = OPT_S.ind_total_ints+1;


