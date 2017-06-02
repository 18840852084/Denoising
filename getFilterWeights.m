function weights = getFilterWeights(secondFeatures,SVR1,SVR2,SVR3,SVR4,SVR5,SVR6,rows)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
disp('正在计算权值......')
    weights = zeros(rows,6);
    SVR1_w = SVR1(1:36,1);
    SVR2_w = SVR2(1:36,1);
    SVR3_w = SVR3(1:36,1);
    SVR4_w = SVR4(1:36,1);
    SVR5_w = SVR5(1:36,1);
    SVR6_w = SVR6(1:36,1);
   
    
    weights(:,1)=secondFeatures*SVR1_w;
    weights(:,2)=secondFeatures*SVR2_w;
    weights(:,3)=secondFeatures*SVR3_w;
    weights(:,4)=secondFeatures*SVR4_w;
    weights(:,5)=secondFeatures*SVR5_w;
    weights(:,6)=secondFeatures*SVR6_w;
    
    weights=1./(1+exp(-weights));
end

