OPT_S.inds_SNR = 1:100:OPT_S.total_reps;
SC = change_exposure(SC,'BSI',SC.BSI_settings.high_exp);
SC = change_camera_ROI(SC,'BSI',SC.c0,SC.r0,OPT_S.n_cap);
N_cap = 2*OPT_S.n_cap+1;
num_SNR = OPT_S.num_SNR_ims;
SC = laser_set(SC.laser_settings.laser_power,SC);
OPT_S.SNR_ims = zeros(N_cap,N_cap,length(OPT_S.inds_SNR),OPT_S.num_SNR_ims);
OPT_S.SLM_mat_flag = 1;
OPT_S.SLM_py_flag = 1;


tm_ind0 = OPT_S.tm_ind;
if(OPT_S.tm_is_alternate == 2)
    OPT_S.tm_ind = inf;
end
for i_it = 1:length(OPT_S.inds_SNR)
    this_it = OPT_S.inds_SNR(i_it);
    if(this_it<OPT_S.tm_ind)
        OPT_S.f_fin = had_up_interp(SC,OPT_S,OPT_S.f_fins(:,:,this_it));
        OPT_S.is_tm=0;
    else
        OPT_S.f_fin_las = had_up_interp(SC,OPT_S,OPT_S.f_fins_las(:,:,this_it));
        OPT_S.f_fin_cam = had_up_interp(SC,OPT_S,OPT_S.f_fins_cam(:,:,this_it));
        OPT_S.is_tm=1;
    end
    activate_func_had_fin(SC,OPT_S);
    for i_SNR = 1:num_SNR
        OPT_S.SNR_ims(:,:,i_it,i_SNR) = take_unsaturate_photo(SC,'BSI');
        figure(197589175);imagesc(OPT_S.SNR_ims(:,:,i_it,i_SNR))
    end
end
% restore
OPT_S.tm_ind = tm_ind0;
SC = change_exposure(SC,'BSI',OPT_S.this_exp);
if(OPT_S.ind_it<OPT_S.tm_ind)
    OPT_S.f_fin = had_up_interp(SC,OPT_S,OPT_S.f_fins(:,:,OPT_S.ind_it));
    OPT_S.is_tm=0;
else
    OPT_S.f_fin_las = had_up_interp(SC,OPT_S,OPT_S.f_fins_las(:,:,OPT_S.ind_it));
    OPT_S.f_fin_cam = had_up_interp(SC,OPT_S,OPT_S.f_fins_cam(:,:,OPT_S.ind_it));
    OPT_S.is_tm=1;
end

