function [SC,OPT_S] = had_add_reps(SC,OPT_S)
%this functions asks the user if he wants to add iterations, and sets accordingly.
ind_it = OPT_S.ind_it;
SC = laser_off(SC);
new_reps_num = input('how many more masks? ');      

ind_val = floor(ind_it/OPT_S.val_interval);
OPT_S.total_reps = OPT_S.total_reps+new_reps_num;
if(new_reps_num == 0)
    OPT_S.rep_flag=0;
else
    OPT_S.f_fins(:,:,OPT_S.total_reps) = zeros(OPT_S.M);
    OPT_S.exp_arr(ind_val + ceil(new_reps_num/OPT_S.val_interval))=0;
end
SC = laser_on(SC);
