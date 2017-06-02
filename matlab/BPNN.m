function [ newNN1,newNN2 ] = BPNN(trueGround_R,mcSample_R,distanceMatR,secondFeatures,NN1,NN2,rows)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
     
     speed=1;
     a=zeros(size(secondFeatures,1),1)+1;
     secondFeatures=[secondFeatures,a];
    
     E1=(mcSample_R-trueGround_R)./(trueGround_R.^2+0.01);
     E1=E1';
     E1=E1(:);
     
%      E2=(mcSample_B-trueGround_B)./(trueGround_R.^2+0.01);
%      E2=E2';
%      E2=E2(:);
%      
%      E3=(mcSample_G-trueGround_G)./(trueGround_G.^2+0.01);
%      E3=E3';
%      E3=E3(:);
     
     
     
     relE1=((mcSample_R-trueGround_R).^2)./(trueGround_R.^2+0.01);
     relE1=relE1';
     relE1=relE1(:);
%      relE2=((mcSample_B-trueGround_B).^2)./(trueGround_B.^2+0.01);
%      relE2=relE2';
%      relE2=relE2(:);
%      relE3=((mcSample_G-trueGround_G).^2)./(trueGround_G.^2+0.01);
%      relE3=relE3';
%      relE3=relE3(:);
     relE=sum((relE1+relE1+relE1)./3)/rows*speed;
     
     temp1=bsxfun(@times,E1,distanceMatR(:,1:6));
%      temp1=bsxfun(@times,E2,distanceMatB(:,1:6))+temp1;
%      temp1=bsxfun(@times,E3,distanceMatG(:,1:6))+temp1;
     temp2=(zeros(rows,6)+relE)*NN2';

     ex=exp(-secondFeatures*NN1);
    
     y=1./(ex+1);
     b=zeros(size(y,1),1)+1;
     y=[y,b];
     second=exp(y*NN2);
     newNN1=NN1;
     newNN2=NN2;
     for numOfCom =1:1:10
        
        temp3=bsxfun(@times,(1+ex(:,numOfCom)).^(-2),ex(:,numOfCom));
        
        temp4=bsxfun(@times,temp3,secondFeatures);
        temp5=bsxfun(@times,temp2(:,numOfCom),temp4);
        temp5=sum(temp5)/rows;
        newNN1(:,numOfCom)=NN1(:,numOfCom)-temp5';
        
     end
     
     for numOfCom =1:1:6
        temp3=second(:,numOfCom)./(1+second(:,numOfCom));
        temp3=bsxfun(@times,temp1(:,numOfCom),temp3);
        temp4=bsxfun(@times,temp3,y);
        temp5=bsxfun(@times,relE,temp4);
        temp5=sum(temp5)/rows;
        newNN2(:,numOfCom)=NN2(:,numOfCom)- temp5';
     end
     
end

