'''
This file is part of codes for the following paper.
For any usage of this file, please cite the following paper as reference:

[1] Zhao-Rong Lai, Xiaotian Wu, Liangda Fang, Ziliang Chen, "A De-singularity 
Subgradient Approach for the Extended Weber Location Problem", the 33rd 
International Joint Conference on Artificial Intelligence (IJCAI, main track), 2024.

At the same time, it is encouraged to cite the following papers with previous related works:

[2] Yehuda Vardi and Cun-Hui Zhang. The multivariate L1-median and associated data depth.
Proceedings of the National Academy of Sciences of the United States of America, 
97(4):1423–1426, Feb. 2000.

[3] Khurrum Aftab, Richard Hartley, and Jochen Trumpf. Generalized weiszfeld 
algorithms for lq optimization. IEEE Transactions on Pattern Analysis and
Machine Intelligence, 37(4):728–745, Apr. 2015.
'''
import torch
import torch.autograd as autograd
import torch.optim as optim
import scipy.io
import os

global y, X, eta, q

eta = torch.ones(1,6);
X = torch.tensor([[-2,-1,1,2,0,0],[0,0,0,0,1,-1]]);
q=1.1


# Define the de-singularity module

class Example(autograd.Function):
    
    @staticmethod
    def forward(ctx, y, X, eta, q):
        m = X.size(dim=1)
        p_dim = X.size(dim=0)
        Y = y @ torch.ones(1, m)
        ETA = torch.ones(p_dim, 1) @ eta
        out = torch.norm(ETA * (X - Y), dim=0)
        out = (out ** q).sum(-1)
        m = torch.tensor(m)
        ctx.save_for_backward(Y, X, eta, m)
        return out
    
    @staticmethod
    def backward(ctx, grad_output):
        zero_tol = 1e-10
        Y, X, eta, m = ctx.saved_tensors
        m = int(m.item())
        d = X.size(dim=0)
        grad_tmp = torch.zeros(d, 1)
        for i in range(m): #This loop can be further parallelized
            diff = torch.zeros(d, 1)
            diff[:,0] = Y[:,i] - X[:,i]
            if diff.abs().max() > zero_tol:
                grad_tmp=grad_tmp+q*(eta[0,i]**q)*(diff.norm()**(q-2))*diff
        y_grad=grad_output * grad_tmp
        return y_grad, None, None, None

# Define loss function

def loss_function(y, X, eta, q):
    return Example.apply(y, X, eta, q)


# 3 Different starting points.

y = torch.tensor([[1.68645],[0]], dtype=torch.float32, requires_grad=True)
#y = torch.tensor([[2.0],[2.0]], dtype=torch.float32, requires_grad=True)
#y = torch.tensor([[0.5],[0.5]], dtype=torch.float32, requires_grad=True)

# Create parameter list

parameters_y = [y]

# Create optimizer


optimizer_y = optim.Adam(parameters_y, lr=0.1)  


# Main Iterations

for i in range(1000):
    
    optimizer_y.zero_grad()
    
    loss = loss_function(y, X, eta, q)
    loss.backward(retain_graph=True)
    
    optimizer_y.step()

print(y)
print(loss)

