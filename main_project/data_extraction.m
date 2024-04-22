function [day_weight,lbd_iter1,x_t2,totaliter,time,y_total,cost_total]=data_extraction(data_close,data,t1,day_weight, w, epsilon)
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

lbd_iter1=0;
totaliter=0;
time=0;
y_total=[];
cost_total=[];

if t1<w+1
    x_t1=data(t1-1,:);
    x_t2=x_t1;
else
    tic;
    [x_t1,lbd_iter1,totaliter,y_total,cost_total] = qPWAWS(data_close((t1-w):(t1-1),:));
    time=toc;
    x_t2=x_t1;
   x_t1 = x_t1./data_close(t1-1,:);
end

if (norm(x_t1-mean(x_t1)))^2==0
    tao = 0;
else
    tao = min(0,(x_t1*day_weight-epsilon)/(norm(x_t1-mean(x_t1)))^2);
end
day_weight = day_weight - tao*(x_t1-mean(x_t1)*ones(size(x_t1)))';
day_weight = simplex_projection(day_weight,1);

end
