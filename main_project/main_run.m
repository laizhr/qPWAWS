function [run_ret, total_ret, day_ret, turno,lbd_iter_total,day_weight_total,x_t1_total,totaliter_total,time_total,y_total_full,cost_total_full] = main_run( data)
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


epsilon=5;
tc=0;
W=5;

[T N]=size(data);

run_ret =[];
total_ret = ones(T, 1);
day_ret = ones(T, 1);
time_total=[];
y_total_full={};
cost_total_full={};


% Portfolio variables, starting with uniform portfolio
day_weight = ones(N, 1)/N;  
day_weight_o = zeros(N, 1);

day_weight_total=ones(N, T)/N;
x_t1_total=zeros(N, T);
turno = 0;
lbd_iter_total=zeros(T,1);
totaliter_total=zeros(T,1);

%to get the close price according to relative price
data_close = ones(T,N);
for i=2:T
    data_close(i,:)= data_close(i-1,:).*data(i,:);
end



k=1;
run_ret(k)=1;
for t = 1:1:T
    % Step 1: Receive stock price relatives 

    % Step 2: Cal t's return and total return
    day_weight_total(:,t)=day_weight;
    day_ret(t, 1) = (data(t, :)*day_weight)*(1-tc/2*sum(abs(day_weight-day_weight_o)));

    run_ret(k) = run_ret(k) * day_ret(t, 1);
    total_ret(t, 1) = run_ret(k);
    
    % Adjust weight(t, :) for the transaction cost issue
    day_weight_o = day_weight.*data(t, :)'/day_ret(t, 1);

    % Step 3: Update portfolio

     if(t<=T)

       [day_weight_n,lbd_iter1,x_t1,totaliter,time,y_total,cost_total]=data_extraction(data_close,data,t+1,day_weight, W, epsilon);
       x_t1_total(:,t)=x_t1';
       turno = turno + sum(abs(day_weight_n-day_weight));
       day_weight = day_weight_n;
       
     if(t>=W)
         lbd_iter_total(t)=lbd_iter1;
         totaliter_total(t)=totaliter;
         time_total=[time_total;time];
         y_total_full=[y_total_full;y_total];
         cost_total_full=[cost_total_full;cost_total];
     end 
     end

    

end



turno = turno/(T-1);


end