function [conv_matrix] = Convolve(original,sigma,sz)
% function convolves raw data by a gaussian filter


%Parameters for gaussian filter, size and sigma
% sigma = 2;
% sz = 15;    % length of gaussFilter vector
x = linspace(-sz / 2, sz / 2, sz);
gaussFilter = exp(-x .^ 2 / (2 * sigma ^ 2));
gaussFilter = gaussFilter / sum (gaussFilter); % normalize

conv_matrix = conv(original, gaussFilter, 'same');


end 