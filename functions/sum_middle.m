function sum_mid = sum_middle(I,num_pix,mask)
%returns the mean of the middle pixels of the image, multiplied by mask.
%assumes size(I,1)=size(I,2), and size(I,1) is odd.
if(~exist('num_pix','var'))
    num_pix=1;
end
if(num_pix==-1)
    sum_mid=max(I(:));
    return;
end
N=size(I,1);
hn=N/2+0.5;
this_sum=I(hn-num_pix:hn+num_pix,hn-num_pix:hn+num_pix);
if(~exist('mask','var'))
    mask = ones(size(this_sum));
end
sum_mid = sum(mask.*this_sum,'all')./sum(mask,'all');
