%capture ground truth from validation camera
SC = set_PG_BP(SC);
SC = laser_set(SC.laser_settings.laser_big_FOV,SC);                             %set laser to big area
I = capture_PG_area_ramps(SC,FOV.TS_scan(end)/4,FOV.TS_scan(3)-FOV.TS_scan(1),'Ground Truth');
FOV.big_FOV_PG_finish = I;
figure;imagesc(I);title('Big area PG');
