function activate_func_had_fin(SC,OPT_S)
% activate final function on SLMs, depending on flags
f_mat = rot90(OPT_S.f_fin,2);
f_py = OPT_S.f_fin;
if(OPT_S.las_SLM_flag == 1)
    las_SLM_func(f_mat,SC,SC.ramps.fx_laser,SC.ramps.fy_laser,OPT_S.SLM_flag_nearest);
end
if(OPT_S.cam_SLM_flag == 1)
    cam_SLM_func(f_py,SC,SC.ramps.fx_cam,SC.ramps.fy_cam,OPT_S.SLM_flag_nearest);
end
