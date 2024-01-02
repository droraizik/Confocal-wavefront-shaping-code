function activate_func(SC,f,mat_flag,py_flag,flag_nearest)
%activate f on SLMs, depending on the flags
if(~exist('mat_flag','var'))
    mat_flag=1;
end
if(~exist('py_flag','var'))
    py_flag=1;
end
if(~exist('flag_nearest','var'))
    flag_nearest=0;
end
f_mat=rot90(f,2);                       %to align correctly
f_py=f;                                 
if(mat_flag==1)
    las_SLM_func(f_mat,SC,SC.ramps.fx_laser,SC.ramps.fy_laser,flag_nearest);
end
if(py_flag==1)
    cam_SLM_func(f_py,SC,SC.ramps.fx_cam,SC.ramps.fy_cam,flag_nearest);
end