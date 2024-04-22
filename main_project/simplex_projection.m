function w = simplex_projection(v, b)
%{
This file is part of codes for the following paper.
For any usage of this file, please cite the following paper as reference:

[1] John Duchi, Shai Shalev-Shwartz, Yoram Singer, and Tushar Chandra, ¡°Efficient
projections onto the \ell_1-ball for learning in high dimensions,¡± in
Proceedings of the International Conference on Machine Learning (ICML), 2008.


%}

if (b < 0)
  error('Radius of simplex is negative: %2.3f\n', b);
end
v = (v > 0) .* v;
u = sort(v,'descend');
sv = cumsum(u);
rho = find(u > (sv - b) ./ (1:length(u))', 1, 'last');
theta = max(0, (sv(rho) - b) / rho);
w = max(v - theta, 0);
