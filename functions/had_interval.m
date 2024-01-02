function [SC,OPT_S]= had_interval(SC,OPT_S)
%interval function - assess score and change exposure accordingly, while keeping constant SNR
ind_it = OPT_S.ind_it;
ind_val = floor(ind_it/OPT_S.val_interval);
orig_exp = OPT_S.this_exp;
%% adjust exposure value
this_int = mean(OPT_S.total_ints(1,end-5:end-1));
this_exp = OPT_S.this_exp*(OPT_S.I0/this_int);
if(ind_val>1)
    this_exp = this_exp*0.5+OPT_S.exp_arr(ind_val-1)*0.5;
end
OPT_S.this_exp=this_exp;
OPT_S.exp_arr(ind_val)=OPT_S.this_exp;
%% set laser and exposures
if(orig_exp~=OPT_S.this_exp)
    SC = change_exposure(SC,'BSI',OPT_S.this_exp);
end
