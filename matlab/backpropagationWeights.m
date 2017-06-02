function [newWeights] = backpropagationWeights(trueGround_O,mcSample_O,distanceMat,weights)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    disp('!!!!!反向迭代算法（权值）')

    E=(mcSample_O-trueGround_O)./(trueGround_O.^2+0.01);
    E=E';
    E=E(:);
    relE=((mcSample_O-trueGround_O).^2)./(trueGround_O.^2+0.01);
    relE=relE';
    relE=relE(:);
   
    dev=bsxfun(@times,E,distanceMat(:,1:6));
    temp1=bsxfun(@times,dev,relE);
    newWeights=abs(weights-temp1);

end

