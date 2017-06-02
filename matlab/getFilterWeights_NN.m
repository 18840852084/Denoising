function weights =getFilterWeights_NN(secondFeatures,NN1,NN2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
     a=zeros(size(secondFeatures,1),1)+1;
     secondFeatures=[secondFeatures,a];
     temp1=secondFeatures*NN1;   
     temp2=1./(exp(-temp1)+1);
     b=zeros(size(temp2,1),1)+1;
     temp2=[temp2,b];
     weights = temp2*NN2;
     weights=log(1+exp(weights));
     
end

