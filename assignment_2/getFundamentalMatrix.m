function [ fundamental ] = getFundamentalMatrix(left, right)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here  
    % make coordinates homogeneous, resulting in 3xN vectors
    left = [left, ones(length(left), 1)]';
    right = [right, ones(length(right), 1)]';
    % normalize 
    norm_mat_l = getNormMat(left);
    norm_mat_r = getNormMat(right);
    normed_left = norm_mat_l*left;
    normed_right = norm_mat_r*right;
    % make matrix that is equivalent to linear system of 8p slide
    %% estimate fundamental matrix using points specified
    eightPointMat = [repmat(normed_right(1,:)', 1,3) .* normed_left',...
    repmat(normed_right(2,:)', 1,3) .*normed_left',...
    normed_left(1:3,:)'];
    [U, S, V] = svd(eightPointMat);
    fundamental_normed = reshape(V(:, end),3,3)';
    % ensure rank 2 by taking svd and discarding smallest eigenvalue/vector
    [u_fund,s_fund,v_fund] = svd(fundamental_normed);
    fundamental_normed_ranked = u_fund*diag([s_fund(1,1) s_fund(2,2) 0])*v_fund';
    fundamental = norm_mat_r' * fundamental_normed_ranked * norm_mat_l;
    disp(fundamental);
end

