which_test = 'laser';
% which_test = 'cam';
% which_test = 'both';

if(strcmp(which_test,'laser'))
    OPT_S.SLM_mat_flag = 1;
    OPT_S.SLM_py_flag = 0;
    f_fin = OPT_S.f_fin_las;
    tm_flag = 1;
elseif(strcmp(which_test,'cam'))
    OPT_S.SLM_mat_flag = 0;
    OPT_S.SLM_py_flag = 1;
    f_fin = OPT_S.f_fin_cam;
    tm_flag = 1;
elseif(strcmp(which_test,'both'))
    OPT_S.SLM_mat_flag = 1;
    OPT_S.SLM_py_flag = 1;
    f_fin = OPT_S.f_fin;
    tm_flag = 0;
end

num_phases = SinT_S.num_phases_test;
phases=((0:1/num_phases:1-1/num_phases)*2*pi)';
H=[cos(phases) -sin(phases) ones(size(phases))];
SinT_S.H_hat=(H'*H)\H';
SinT_S.phases = phases;



mask_f = had_get_mask_old(SC,HAD_S,ind_it);
SinT_S.ints = zeros(num_phases,1);
for p=1:num_phases
    f0=f_fin.*(mask_f.^phases(p));
    activate_func(SC,f0,OPT_S.SLM_mat_flag,OPT_S.SLM_py_flag,OPT_S.SLM_flag_nearest);
    I=take_unsaturate_photo(SC,'BSI');
    SinT_S.ints(p)=sum_middle(I,OPT_S.mid_pix,OPT_S.mask_wind);
end
theta_max = had_fit_sin_old(SinT_S,SinT_S.ints,1,0);

