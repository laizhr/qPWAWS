function [y,lbd_iter1,totaliter,y_total,cost_total] = qPWAWS(X, maxiter, tol, zerotol, medIn )
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

q=1.9;
shorten=0.1;
y_total=[];
cost_total=[];
cost_cur=[];
lbd_iter1=0;
    
    
    if (nargin > 5)
        error ('Too many input arguments.') ;
    elseif (nargin < 5)
        medIn = X(1,:);
     
        if(nargin < 4)
            zerotol = 1e-15 ;
            if (nargin < 3)
                tol = 1e-9 ;
                if (nargin < 2)
                    maxiter = 200 ;
                    if (nargin < 1)
                        error ('Data matrix X is missing.') ;
                    end
                end
            end
        end
    end
    
    [rn,vn] = size(X);
    iterdis = 1;
    iter = 0;
    y = medIn;
    
    %Begin the iteration
    while (iterdis > 0) && (iter < maxiter)
        Tnum=zeros(1,vn);
        R = zeros(1,vn);
        Tden=0;
        yita = 0;
        flag=0;
        for i=1:rn
            dist = norm(X(i,:)-y);
            if dist >= zerotol
                Tnum = Tnum + X(i,:)*dist^(q-2);
                Tden=Tden + dist^(q-2);
                R = R + (X(i,:)-y)*dist^(q-2);
            else
                disp('singular!');
                flag=1;
                k=i;
                if q==1
                    yita=1;
                else
                yita = yita+1;
                end
            end
        end

        if Tden == 0
            T=0;
        else
           T=Tnum/Tden;
        end

        if norm(R) == 0
            r = 0;
        else
            r = min(1,yita/norm(R));
        end
        
        lbd_iter=0;
        
        if(q==1)
            Ty = (1-r)*T + r*y;
        elseif(flag==1)
            lambda=min((norm(R)^(2-q)/yita)^(1/(q-1)), 1  );
            cost_cur=cost(y,X,q);
            
            while(1)
                lbd_iter=lbd_iter+1;
                ytmp=X(k,:)+lambda*R;
                cost_new=cost(ytmp,X,q);
                if(cost_new<cost_cur)
                    Ty=ytmp;
                    break;
                end
                lambda=lambda*shorten;
            end
         lbd_iter1=lbd_iter;
        else
            Ty=T;
        end

        iterdis = norm((Ty-y),1) - tol*norm(y,1);
        iter = iter + 1;
        y=Ty;
        y_total=[y_total;y];
        cost_total=[cost_total;cost_cur];
    end
    totaliter=iter+lbd_iter1;

    
      
    
        
