    if(ind_it<OPT_S.tm_ind)
        OPT_S = had_grad_step(SC,OPT_S,HAD_S,'both');
    elseif(ind_it==OPT_S.tm_ind)
        %% PG Incoherent beads
        SC = set_PG_BP(SC);
        I = capture_PG_pseudo_incoherent(SC,OPT_S.num_images_inc_beads,OPT_S.radius_inc_beads,'two masks incoherent beads');
        OPT_S.tm_phase_inc_beads = I;
        OPT_S2 = OPT_S;
        OPT_S2.is_tm = 1;
        OPT_S2.f_fin_las = OPT_S.f_fin;
        OPT_S2.f_fin_cam = OPT_S.f_fin;
        OPT_S2.ints = zeros(OPT_S2.tm_num_phases,1);
        OPT_S2.ints(1) = OPT_S.ints(1);
        OPT_S2.f_fin_las_prev = OPT_S.f_fin;
        OPT_S2.f_fin_cam_prev = OPT_S.f_fin;
        OPT_S = had_grad_step(SC,OPT_S,HAD_S,'both');
        OPT_S2 = had_grad_step(SC,OPT_S2,HAD_S,'laser');
        OPT_S2 = had_grad_step(SC,OPT_S2,HAD_S,'cam');
    elseif(ind_it>OPT_S.tm_ind)
        OPT_S2.ind_it = OPT_S.ind_it;
        OPT_S2.mid_pix = OPT_S.mid_pix;
        OPT_S2.mask_wind = OPT_S.mask_wind;
        OPT_S2.this_exp = OPT_S.this_exp;
        OPT_S = had_grad_step(SC,OPT_S,HAD_S,'both');
        OPT_S2 = had_grad_step(SC,OPT_S2,HAD_S,'laser');
        OPT_S2 = had_grad_step(SC,OPT_S2,HAD_S,'cam');
    end
end
