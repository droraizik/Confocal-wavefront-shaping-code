function [had_mat,row_i,col_j]= hadamard_matrix(M,rads)
had_mat=hadamard(M);
diffs=diff(had_mat);
diffs=sum(abs(diffs),1);
[~,is]=sort(diffs);
had_mat=had_mat(is,:);
num_rads = length(rads);
row_i = [];
col_j = [];
for i_rad=1:num_rads
    this_rad = min(rads(i_rad),M);
    [X,Y] = meshgrid(0:this_rad-1);
    [~,r] = cart2pol(X,Y);
    r = r(:);
    [~,inds] = sort(r);
    inds(inds == 1) =[];
    [this_row_i,this_col_j] = ind2sub([this_rad this_rad],inds);
    row_i = [row_i;this_row_i];
    col_j = [col_j;this_col_j];
end