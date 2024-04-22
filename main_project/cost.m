function [ out ] = cost( y,X,q )
%{
This file is part of codes for the following paper.
For any usage of this file, please cite the following paper as reference:

[1] Zhao-Rong Lai, Xiaotian Wu, Liangda Fang, Ziliang Chen, "A De-singularity 
Subgradient Approach for the Extended Weber Location Problem", the 33rd 
International Joint Conference on Artificial Intelligence (IJCAI, main track), 2024.

At the same time, it is encouraged to cite the following papers with previous related works:

[2] Yehuda Vardi and Cun-Hui Zhang. The multivariate L1-median and associated data depth.
Proceedings of the National Academy of Sciences of the United States of America, 
97(4):1423¨C1426, Feb. 2000.

[3] Khurrum Aftab, Richard Hartley, and Jochen Trumpf. Generalized weiszfeld 
algorithms for lq optimization. IEEE Transactions on Pattern Analysis and
Machine Intelligence, 37(4):728¨C745, Apr. 2015.

[4] Dingjiang Huang, Junlong Zhou, Bin Li, Steven C. H. Hoi, and Shuigeng Zhou. 
Robust median reversion strategy for online portfolio selection. IEEE Transactions 
on Knowledge and Data Engineering, 28(9):2480-2493, Sep. 2016.

[5] Bin Li, Doyen Sahoo, and Steven C.H. Hoi. OLPS: a toolbox for on-line portfolio 
selection. Journal of Machine Learning Research, 17(1):1242-1246, 2016.

[6] Zhao-Rong Lai and Haisheng Yang. A survey on gaps between mean-variance approach 
and exponential growth rate approach for portfolio optimization. ACM Computing Surveys, 
55(2):1¨C36, Mar. 2023. Article No. 25.
%}

[rn,vn] = size(X);
out=0;
for i=1:rn
    out=out+norm(X(i,:)-y)^q;
end


end

