function las_SLM_func(f_mat,SC,fx,fy,interp_type)
%place f_mat on laser SLM, multiplied by phase ramp:
%exp(1i*2*pi*(fx*SC.gfx+fy*SC.gfy)), where SC.gfx/y are fourier plane grids.
%interp_type decided which interpolation goes from f_mat to the SLM (nearest neibour, linear,..)

