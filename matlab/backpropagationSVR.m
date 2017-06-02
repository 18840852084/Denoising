function newSVR = backpropagationSVR(SVR,trueGround_O,mcSample_O,distanceMat,secondFeatures,numOfFilterCom,rows)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    disp('反向迭代算法')
  
    E=(mcSample_O-trueGround_O)./(trueGround_O.^2+0.01);
    E=E';
    E=E(:);
    
    relE=(mcSample_O-trueGround_O);
    relE=relE';
    relE=relE(:);
    
    SVR_w=SVR(1:36,1);
    dev=E.*distanceMat(:,numOfFilterCom);
    ex=exp(-secondFeatures*SVR_w);
    dfDevde=bsxfun(@times,((1+ex).^(-2)),ex);
    dev=dev.*dfDevde;
    
    temp1=bsxfun(@times,dev,secondFeatures);
    temp2=bsxfun(@times,temp1,relE);
    newSVR = SVR_w + (sum(temp2)/rows)';

end

