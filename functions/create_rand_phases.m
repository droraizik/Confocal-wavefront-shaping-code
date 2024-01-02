function phaseL=create_rand_phases(SC,num_masks,windw_pix)
N=SC.N;
n=SC.n;
hn = n+1;
phaseL=zeros(N,N,num_masks);

windw_pix_n = (floor(windw_pix/2)*2+1)/2-0.5;
wind_small = zeros(N,N);
wind_small(hn-windw_pix_n:hn+windw_pix_n,hn-windw_pix_n:hn+windw_pix_n)=1;
for i_phase=1:num_masks
    I=rand(N).*exp(1i*2*pi*rand(N)).*wind_small;
    If=sign(fftshift(fft2(ifftshift(I)))).*SC.mask_f_laser;
    phaseL(:,:,i_phase)=If;
end
