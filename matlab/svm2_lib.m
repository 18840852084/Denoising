
pic_width=1200;
pic_height=800;

disp('正在加载MC采样文件......');
mcSample=importdata('D:/[0SVR]/room-path_MC.txt');
mcSample_R=mcSample(1:end,1);
mcSample_R=reshape(mcSample_R',pic_width,pic_height)';
mcSample_G=mcSample(1:end,2);
mcSample_G=reshape(mcSample_G',pic_width,pic_height)';
mcSample_B=mcSample(1:end,3);
mcSample_B=reshape(mcSample_B',pic_width,pic_height)';
disp('正在加载第二特征数据......')
secondFeatures=load('d:/[0SVR]/second_Feature.txt');
secondFeatures=reshape(secondFeatures',36, 960000)';
%secondFeatures=secondFeatures(1:320000,:);

disp('正在加载真实场景图像数据......')
trueGround=importdata('D:/[0SVR]/room-path-trueGround.txt');
trueGround_R=trueGround(1:end,1);
%trueGround_R=reshape(trueGround_R',pic_width,pic_height)';
trueGround_G=trueGround(1:end,2);
trueGround_G=reshape(trueGround_G',pic_width,pic_height)';
trueGround_B=trueGround(1:end,3);
trueGround_B=reshape(trueGround_B',pic_width,pic_height)';


row = size(mcSample,1);
col = size(mcSample,2);
half_patch=27;

[mat,pic_mean]=svm2getcolor(mcSample_R,secondFeatures,pic_width,pic_height,half_patch);

val=trueGround_R./(pic_mean+0.0001);

mat=[val,mat];


fid=fopen('d:\train.txt','w'); 
for i=1:1:10000
   
fprintf(fid,'%f 1:%f 2:%f 3:%f 4:%f 5:%f 6:%f 7:%f 8:%f 9:%f 10:%f 11:%f 12:%f 13:%f 14:%f 15:%f 16:%f 17:%f 18:%f 19:%f 20:%f 21:%f 22:%f 23:%f 24:%f 25:%f 26:%f 27:%f 28:%f 29:%f 30:%f 31:%f 32:%f 33:%f 34:%f 35:%f 36:%f \r\n',e(i,1),secondFeatures(i,1:end));

  
end
fclose(fid);

fid=fopen('d:\test.txt','w'); 
for i=10001:1:15000
fprintf(fid,'%f 1:%f 2:%f 3:%f 4:%f 5:%f 6:%f 7:%f 8:%f 9:%f 10:%f 11:%f 12:%f 13:%f 14:%f 15:%f 16:%f 17:%f 18:%f 19:%f 20:%f 21:%f 22:%f 23:%f 24:%f 25:%f 26:%f 27:%f 28:%f 29:%f 30:%f 31:%f 32:%f 33:%f 34:%f 35:%f 36:%f \r\n',e(i,1),secondFeatures(i,1:end));
end
fclose(fid);

%===========================================
tG_R=trueGround(1:end,1);
out=importdata('D:/god/libsvm/out.txt');
result=out.*pic_mean;
sum(sum(((out-tG_R).^2)./(tG_R.^2+0.01)))/(pic_width*pic_height)
