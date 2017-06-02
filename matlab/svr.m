%开始，本程序用于训练SVR模型
pic_width=800;
pic_height=400;

disp('正在加载MC采样文件......');
mcSample=importdata('D:\new3\anim-bluespheres_MC16.txt');
mcSample_R=mcSample(1:end,1);
mcSample_R=reshape(mcSample_R',pic_width,pic_height)';
mcSample_G=mcSample(1:end,2);
mcSample_G=reshape(mcSample_G',pic_width,pic_height)';
mcSample_B=mcSample(1:end,3);
mcSample_B=reshape(mcSample_B',pic_width,pic_height)';
disp('正在加载第二特征数据......')
secondFeatures=load('D:\new3\anim-bluespheres_4spp_2nd.txt');
secondFeatures=reshape(secondFeatures',36, pic_width*pic_height)';
%secondFeatures=secondFeatures(1:320000,:);

disp('正在加载真实场景图像数据......')
trueGround=importdata('D:\pbrt-scenes\groudTruth\anim-bluespheres.txt');
trueGround_R=trueGround(1:end,1);
trueGround_R=reshape(trueGround_R',pic_width,pic_height)';
trueGround_G=trueGround(1:end,2);
trueGround_G=reshape(trueGround_G',pic_width,pic_height)';
trueGround_B=trueGround(1:end,3);
trueGround_B=reshape(trueGround_B',pic_width,pic_height)';

weights=importdata('D:\new3\weights.txt');

row = size(mcSample,1);
half_patch=27;

%==================误差============================
    relE=((mcSample-trueGround).^2)./(trueGround.^2);
    relE=sum(relE,2);


noiseFlag=zeros(pic_width*pic_height,1);
for i=1:1:pic_width*pic_height
    if relE(i,1) > 0.001
         noiseFlag(i,1)=1;
    end
   
end
%================正规========================
relMSE = 0;
time=0;
tic;
filterR=svrfilter(mcSample_R,secondFeatures,weights,pic_width,pic_height,half_patch);
filterB=svrfilter(mcSample_B,secondFeatures,weights,pic_width,pic_height,half_patch);    
filterG=svrfilter(mcSample_G,secondFeatures,weights,pic_width,pic_height,half_patch);
timeTotal = toc; %总时间
time=[time,timeTotal]
     relE1=((filterR-trueGround_R).^2)./(trueGround_R.^2+0.01);
     relE1=relE1';
     relE1=relE1(:);
     relE2=((filterB-trueGround_B).^2)./(trueGround_B.^2+0.01);
     relE2=relE2';
     relE2=relE2(:);
     relE3=((filterG-trueGround_G).^2)./(trueGround_G.^2+0.01);
     relE3=relE3';
     relE3=relE3(:);
     relE=sum(relE1+relE2+relE3)/row;
     a=relE;
     relMSE=[relMSE,a]
tic;
n_filterR=svrfilter_new(noiseFlag,mcSample_R,secondFeatures,weights,pic_width,pic_height,half_patch);
n_filterB=svrfilter_new(noiseFlag,mcSample_B,secondFeatures,weights,pic_width,pic_height,half_patch);    
n_filterG=svrfilter_new(noiseFlag,mcSample_G,secondFeatures,weights,pic_width,pic_height,half_patch);
timeTotal = toc; %总时间
time=[time,timeTotal]
    relE1=((n_filterR-trueGround_R).^2)./(trueGround_R.^2+0.01);
    relE1=relE1';
    relE1=relE1(:);
    relE2=((n_filterB-trueGround_B).^2)./(trueGround_B.^2+0.01);
    relE2=relE2';
    relE2=relE2(:);
    relE3=((n_filterG-trueGround_G).^2)./(trueGround_G.^2+0.01);
    relE3=relE3';
    relE3=relE3(:);
    relE=sum(relE1+relE2+relE3)/row;
    a=relE;
    relMSE=[relMSE,a]

fid=fopen('d:\anim-bluespheres.txt','w');
for i=1:1:pic_width*pic_height
    fprintf(fid,'%d 1:%f 2:%f 3:%f 4:%f 5:%f 6:%f 7:%f 8:%f 9:%f 10:%f 11:%f 12:%f 13:%f 14:%f 15:%f 16:%f 17:%f 18:%f 19:%f 20:%f 21:%f 22:%f 23:%f 24:%f 25:%f 26:%f 27:%f 28:%f 29:%f 30:%f 31:%f 32:%f 33:%f 34:%f 35:%f 36:%f\r\n',details(i,1:end));
end
fclose(fid);
% weights_new = [weights(:,1:4)*100,weights(:,5:6)*10];
% weights_new = floor(weights_new);
% temp1_new = zeros(320000,37);
% temp2_new = zeros(320000,37);
% temp3_new = zeros(320000,37);
% temp4_new = zeros(320000,37);
% temp5_new = zeros(320000,37);
% temp6_new = zeros(320000,37);
% for i=1:1:320000
%     if noiseFlag(i,1)==1
%         temp1_new(i,:) = [weights_new(i,1),secondFeatures(i,:)];
%         temp2_new(i,:) = [weights_new(i,2),secondFeatures(i,:)];
%         temp3_new(i,:) = [weights_new(i,3),secondFeatures(i,:)];
%         temp4_new(i,:) = [weights_new(i,4),secondFeatures(i,:)];
%         temp5_new(i,:) = [weights_new(i,5),secondFeatures(i,:)];
%         temp6_new(i,:) = [weights_new(i,6),secondFeatures(i,:)];
%     end
% end
% temp1_new(all(temp1_new==0,2),:)=[];
% temp2_new(all(temp2_new==0,2),:)=[];
% temp3_new(all(temp3_new==0,2),:)=[];
% temp4_new(all(temp4_new==0,2),:)=[];
% temp5_new(all(temp5_new==0,2),:)=[];
% temp6_new(all(temp6_new==0,2),:)=[];
% fid=fopen('d:\SVM_1.txt','w');
% for i=1:10:118360
%     fprintf(fid,'%f 1:%f 2:%f 3:%f 4:%f 5:%f 6:%f 7:%f 8:%f 9:%f 10:%f 11:%f 12:%f 13:%f 14:%f 15:%f 16:%f 17:%f 18:%f 19:%f 20:%f 21:%f 22:%f 23:%f 24:%f 25:%f 26:%f 27:%f 28:%f 29:%f 30:%f 31:%f 32:%f 33:%f 34:%f 35:%f 36:%f\r\n',temp1_new(i,1:end));
% end
% fclose(fid);
% fid=fopen('d:\SVM_2.txt','w');
% for i=1:10:118360
%     fprintf(fid,'%f 1:%f 2:%f 3:%f 4:%f 5:%f 6:%f 7:%f 8:%f 9:%f 10:%f 11:%f 12:%f 13:%f 14:%f 15:%f 16:%f 17:%f 18:%f 19:%f 20:%f 21:%f 22:%f 23:%f 24:%f 25:%f 26:%f 27:%f 28:%f 29:%f 30:%f 31:%f 32:%f 33:%f 34:%f 35:%f 36:%f\r\n',temp2_new(i,1:end));
% end
% fclose(fid);
% fid=fopen('d:\SVM_3.txt','w');
% for i=1:10:118360
%     fprintf(fid,'%f 1:%f 2:%f 3:%f 4:%f 5:%f 6:%f 7:%f 8:%f 9:%f 10:%f 11:%f 12:%f 13:%f 14:%f 15:%f 16:%f 17:%f 18:%f 19:%f 20:%f 21:%f 22:%f 23:%f 24:%f 25:%f 26:%f 27:%f 28:%f 29:%f 30:%f 31:%f 32:%f 33:%f 34:%f 35:%f 36:%f\r\n',temp3_new(i,1:end));
% end
% fclose(fid);
% fid=fopen('d:\SVM_4.txt','w');
% for i=1:10:118360
%     fprintf(fid,'%f 1:%f 2:%f 3:%f 4:%f 5:%f 6:%f 7:%f 8:%f 9:%f 10:%f 11:%f 12:%f 13:%f 14:%f 15:%f 16:%f 17:%f 18:%f 19:%f 20:%f 21:%f 22:%f 23:%f 24:%f 25:%f 26:%f 27:%f 28:%f 29:%f 30:%f 31:%f 32:%f 33:%f 34:%f 35:%f 36:%f\r\n',temp4_new(i,1:end));
% end
% fclose(fid);
% fid=fopen('d:\SVM_5.txt','w');
% for i=1:10:118360
%     fprintf(fid,'%f 1:%f 2:%f 3:%f 4:%f 5:%f 6:%f 7:%f 8:%f 9:%f 10:%f 11:%f 12:%f 13:%f 14:%f 15:%f 16:%f 17:%f 18:%f 19:%f 20:%f 21:%f 22:%f 23:%f 24:%f 25:%f 26:%f 27:%f 28:%f 29:%f 30:%f 31:%f 32:%f 33:%f 34:%f 35:%f 36:%f\r\n',temp5_new(i,1:end));
% end
% fclose(fid);
% fid=fopen('d:\SVM_6.txt','w');
% for i=1:10:118360
%     fprintf(fid,'%f 1:%f 2:%f 3:%f 4:%f 5:%f 6:%f 7:%f 8:%f 9:%f 10:%f 11:%f 12:%f 13:%f 14:%f 15:%f 16:%f 17:%f 18:%f 19:%f 20:%f 21:%f 22:%f 23:%f 24:%f 25:%f 26:%f 27:%f 28:%f 29:%f 30:%f 31:%f 32:%f 33:%f 34:%f 35:%f 36:%f\r\n',temp6_new(i,1:end));
% end
% fclose(fid);
% %===========神经网络方法=================




% NN1=rand(37,10)-0.5;
% NN2=rand(11,6)-0.5;
% % GuanXi=rand(36,6)-0.5;
% relMSE=0;
% for i=1:1:20
% weights = getFilterWeights_NN(secondFeatures,NN1,NN2);
% % weights=secondFeatures*GuanXi;
% % weights=log(1+exp(weights));
% [filterR,distanceMatR]=svrfilter(mcSample_R,secondFeatures,weights,pic_width,pic_height,half_patch);
% [filterB,distanceMatB]=svrfilter(mcSample_B,secondFeatures,weights,pic_width,pic_height,half_patch);    
% [filterG,distanceMatG]=svrfilter(mcSample_G,secondFeatures,weights,pic_width,pic_height,half_patch);      
%       
%      relE1=((filterR-trueGround_R).^2)./(trueGround_R.^2+0.01);
%      relE1=relE1';
%      relE1=relE1(:);
%      relE2=((filterB-trueGround_B).^2)./(trueGround_B.^2+0.01);
%      relE2=relE2';
%      relE2=relE2(:);
%      relE3=((filterG-trueGround_G).^2)./(trueGround_G.^2+0.01);
%      relE3=relE3';
%      relE3=relE3(:);
%      relE=sum(relE1)/row;
%      a=relE;
%      relMSE=[relMSE,a]
%      
% %      E1=(filterR-trueGround_R)./(trueGround_R.^2+0.01);
% %      E1=E1';
% %      E1=E1(:);
% %      E=bsxfun(@times,E1,distanceMatR);
% %      ex=exp(weights);
% %      df=ex./(1+ex);
% %      
% %      temp=bsxfun(@times,E,df);
% %      for col = 1:1:6
% %      temp1=bsxfun(@times,relE,temp);
% %      temp2=bsxfun(@times,temp1,secondFeatures);
% %      temp3=sum(temp2)/(pic_width*pic_height);
% %      GuanXi(:,col)=GuanXi(:,col)-temp3';
% %      end
% % %  
%    
% 
% [NN1,NN2]=BPNN(trueGround_R,filterR,distanceMatR,secondFeatures,NN1,NN2,row)
% end
% 
% % %===================权值迭代========================================
% weights=zeros(row,6)+1;
% [filterR,distanceMatR]=svrfilter(mcSample_R,secondFeatures,weights,pic_width,pic_height,half_patch);
%  relE1=((filterR-trueGround_R).^2)./(trueGround_R.^2+0.01);
%      relE1=relE1';
%      relE1=relE1(:); 
%      a=sum(sum(relE))/(pic_width*pic_height);
%      relMSE=[relMSE,a]
% 
% E1=(mcSample_R-trueGround_R)./(trueGround_R.^2+0.01);
% E1=E1';
% E1=E1(:);
% temp1=bsxfun(@times,E1,distanceMatR);
% weights=weights-temp1*10;
% %==========分类！！！！！============================
% filterR=RenderEdge(filterR,pic_width,pic_height,1);    
% filterR=svrfilterClass(noisedec,mcSample_R,pic_width,pic_height,1);
% filterB=svrfilterClass(noiseFlag,mcSample_B,pic_width,pic_height,1);
% filterG=svrfilterClass(noiseFlag,mcSample_G,pic_width,pic_height,1);
%     
% relE1=((filterR-trueGround_R).^2)./(trueGround_R.^2+0.01);
% relE1=relE1';
% relE1=relE1(:);
%       
% a=sum(sum(relE1))/(pic_width*pic_height);
% relMSE=[relMSE,a]
%     relE1=((mcSample_R-trueGround_R).^2)./(trueGround_R.^2+0.01);
%     relE1=relE1';
%     relE1=relE1(:);
%     relE2=((mcSample_B-trueGround_B).^2)./(trueGround_B.^2+0.01);
%     relE2=relE2';
%     relE2=relE2(:);
%     relE3=((mcSample_G-trueGround_G).^2)./(trueGround_G.^2+0.01);
%     relE3=relE3';  
%     relE3=relE3(:);
%     relE=(relE1+relE2+relE3)/3;
%     a=sum(sum(relE))/(pic_width*pic_height);
% relMSE=[relMSE,a]
% 
% 
% filter2=mcSample_R';
% filter2=filter2(:);
% TG2=trueGround_R';
% TG2=TG2(:);
% firstadd=zeros(row,6);
% noisedec=zeros(row,36);
% for i=1:1:row
%     if relE(i,1) < 0.001
%         firstadd(i,1:end)=weights(i,:);
%         
%         noisedec(i,1:end)=secondFeatures(i,:);
% 
% %     else
% %         noisedec(i,2:end)=secondFeatures(i,:);
% %         noisedec(i,1)=-1;
%     end
% end
% firstadd(all(firstadd==0,2),:)=[];
% noisedec(all(noisedec==0,2),:)=[];
% details=[weights(:,1),secondFeatures(:,:)];
% % %1-5000作为训练数据
% fid=fopen('d:\trainSVM.txt','w');
% for i=1:1:320000
%     fprintf(fid,'%d 1:%f 2:%f 3:%f 4:%f 5:%f 6:%f 7:%f 8:%f 9:%f 10:%f 11:%f 12:%f 13:%f 14:%f 15:%f 16:%f 17:%f 18:%f 19:%f 20:%f 21:%f 22:%f 23:%f 24:%f 25:%f 26:%f 27:%f 28:%f 29:%f 30:%f 31:%f 32:%f 33:%f 34:%f 35:%f 36:%f\r\n',details(i,1:end));
% end
% fclose(fid);
% fid=fopen('d:\test.txt','w');
% for i=100001:1:200000
%     fprintf(fid,'%f 1:%f 2:%f 3:%f 4:%f 5:%f 6:%f 7:%f 8:%f 9:%f 10:%f 11:%f 12:%f 13:%f 14:%f 15:%f 16:%f 17:%f 18:%f 19:%f 20:%f 21:%f 22:%f 23:%f 24:%f 25:%f 26:%f 27:%f 28:%f 29:%f 30:%f 31:%f 32:%f 33:%f 34:%f 35:%f 36:%f\r\n',details(i,1:end));   
% end
% fclose(fid);
% % %5001-8000作为测试数据
% % fid=fopen('d:\test.txt','w');
% % for i=50001:1:60000
% %     fprintf(fid,'%d 1:%f 2:%f 3:%f 4:%f 5:%f 6:%f 7:%f 8:%f 9:%f 10:%f 11:%f 12:%f 13:%f 14:%f 15:%f 16:%f 17:%f 18:%f 19:%f 20:%f 21:%f 22:%f 23:%f 24:%f 25:%f 26:%f 27:%f 28:%f 29:%f 30:%f 31:%f 32:%f 33:%f 34:%f 35:%f 36:%f\r\n',firstadd(i,3),noisedec(i,:));
% % end
% % for i=50001:1:100000
% %     fprintf(fid,'%d 1:%f 2:%f 3:%f 4:%f 5:%f 6:%f 7:%f 8:%f 9:%f 10:%f 11:%f 12:%f 13:%f 14:%f 15:%f 16:%f 17:%f 18:%f 19:%f 20:%f 21:%f 22:%f 23:%f 24:%f 25:%f 26:%f 27:%f 28:%f 29:%f 30:%f 31:%f 32:%f 33:%f 34:%f 35:%f 36:%f\r\n',noisedec(i,1:end));   
% % end
% % fclose(fid);
% 
% %全部待测数据
% fid=fopen('d:\realtest.txt','w');
% for i=1:1:row
%     fprintf(fid,'0 1:%f 2:%f 3:%f 4:%f 5:%f 6:%f 7:%f 8:%f 9:%f 10:%f 11:%f 12:%f 13:%f 14:%f 15:%f 16:%f 17:%f 18:%f 19:%f 20:%f 21:%f 22:%f 23:%f 24:%f 25:%f 26:%f 27:%f 28:%f 29:%f 30:%f 31:%f 32:%f 33:%f 34:%f 35:%f 36:%f\r\n',secondFeatures(i,1:end));
% end
% fclose(fid);
% 
% %============================细节获取================================
% detailsR = getDetails(trueGround_R,secondFeatures,pic_width,pic_height,1);
% detailsB = getDetails(trueGround_B,secondFeatures,pic_width,pic_height,1);
% detailsG = getDetails(trueGround_G,secondFeatures,pic_width,pic_height,1);
% 
% % filterR = svrfilterClass(mcSample_R,pic_width,pic_height,half_patch);
% % filterB = svrfilterClass(mcSample_B,pic_width,pic_height,half_patch);
% % filterG = svrfilterClass(mcSample_G,pic_width,pic_height,half_patch);
% 
% filterR = RenderEdge(detailsR,mcSample_R,pic_width,pic_height,2);
% filterB = RenderEdge(detailsB,mcSample_B,pic_width,pic_height,2);
% filterG = RenderEdge(detailsG,mcSample_G,pic_width,pic_height,2);
% 
% filterR = removeSpikes(filterR,pic_width,pic_height,half_patch);
% filterB = removeSpikes(filterB,pic_width,pic_height,half_patch);
% filterG = removeSpikes(filterG,pic_width,pic_height,half_patch);
% relE1=((filterR-trueGround_R).^2)./(trueGround_R.^2+0.01);
%     relE1=relE1';
%     relE1=relE1(:);
%     relE2=((filterB-trueGround_B).^2)./(trueGround_B.^2+0.01);
%     relE2=relE2';
%     relE2=relE2(:);
%     relE3=((filterG-trueGround_G).^2)./(trueGround_G.^2+0.01);
%     relE3=relE3';  
%     relE3=relE3(:);
%     relE=(relE1+relE2+relE3)/3;
%     a=sum(sum(relE))/(pic_width*pic_height);
% relMSE=[relMSE,a]
tempR=filterR';tempR=tempR(:);tempB=filterB';tempB=tempB(:);tempG=filterG';tempG=tempG(:);
temp=[tempR,tempG,tempB];
fid=fopen('d:\1.txt','w');
for i=1:1:row
    fprintf(fid,' %0.9f  %0.9f  %0.9f  1.000000000 \n',temp(i,:));
end
fclose(fid);
tempR=n_filterR';tempR=tempR(:);tempB=n_filterB';tempB=tempB(:);tempG=n_filterG';tempG=tempG(:);
temp=[tempR,tempG,tempB];
fid=fopen('d:\1.txt','w');
for i=1:1:row
    fprintf(fid,' %0.9f  %0.9f  %0.9f  1.000000000 \n',temp(i,:));
end
fclose(fid);