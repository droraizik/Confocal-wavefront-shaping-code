function I = capture_PG_area_ramps(SC,max_ramp,d_ramp,titl)
ramps = -max_ramp:d_ramp:max_ramp;
num_ramps = length(ramps);
mat_flag = 1;
py_flag = 0;
flag_nearest = 0;
images = zeros(SC.N_PG,SC.N_PG,num_ramps,num_ramps);
for ix = 1:num_ramps
    for iy = 1:num_ramps
        fx = ramps(ix);
        fy = ramps(iy);
        f_ramp=exp(2*pi*1i*(fx*SC.gfx+fy*SC.gfy));
        activate_func(SC,f_ramp,mat_flag, py_flag, flag_nearest);
        I = take_fixed_photo(SC,'PG',SC.PG_settings.big_area_ramps_mean);
        images(:,:,ix,iy) = I;
        figure(13515);imagesc(mean(images,[3 4]));title([titl ' ix: ' num2str(ix) ', iy: ' num2str(iy) ' of:' num2str(num_ramps)]);
    end
end
I = mean(images,[3 4]);