I = FOV.big_FOV_PG_finish;
I1 = imresize(I,24/20*3.69/6.5);
I = OPT_S.fin_PG_BP;
I2 = imresize(I,24/20*3.69/6.5);
[rr,cc] = max_rc(I2);
figure;imagesc(I2);
NN = size(I1,1);
figure;imagesc((1:NN)-cc,(1:NN)-rr,I1);

tgprintf('refocus')
OPT_S.offset_from_00_r = input('refocus offset r: ');
OPT_S.offset_from_00_c = input('refocus offset c: ');
OPT_S.cam_00 = [OPT_S1.cam_00(1)+OPT_S.offset_from_00_r OPT_S1.cam_00(2)+OPT_S.offset_from_00_c];
SC = set_refocus_ramps(SC,OPT_S);

if(OPT_S.is_tm == 0)
    OPT_S.f_fin_first = OPT_S.f_fin;
    OPT_S.f_fin = circshift(OPT_S.f_fin,round([FOV.shift_alpha*OPT_S.offset_from_00_r*SC.dx/SC.df FOV.shift_alpha*OPT_S.offset_from_00_c*SC.dx/SC.df])).*SC.mask_f_laser;
else
    OPT_S.f_fin_cam_first = OPT_S.f_fin_cam;
    OPT_S.f_fin_las_first = OPT_S.f_fin_las;
    OPT_S.f_fin_cam = circshift(OPT_S.f_fin_cam,round([FOV.shift_alpha*OPT_S.offset_from_00_r*SC.dx/SC.df FOV.shift_alpha*OPT_S.offset_from_00_c*SC.dx/SC.df])).*SC.mask_f_laser;
    OPT_S.f_fin_las = circshift(OPT_S.f_fin_las,round([FOV.shift_alpha*OPT_S.offset_from_00_r*SC.dx/SC.df FOV.shift_alpha*OPT_S.offset_from_00_c*SC.dx/SC.df])).*SC.mask_f_laser;
    OPT_S.tm_ind = 0;
end

%% hadamard masks
M = OPT_S.M;
HAD_S.rads=OPT_S.rads;
HAD_S.M=M;
HAD_S.total_its = floor(count_hads(rads,M)/HAD_S.num_masks_grad)*HAD_S.num_masks_grad;
HAD_S.total_its_grad = HAD_S.total_its/HAD_S.num_masks_grad;
OPT_S.total_reps_0 = HAD_S.total_its_grad;
ind_it = round(OPT_S.refocus_ind_perc*HAD_S.total_its);
