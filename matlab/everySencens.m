mcSample=importdata('D:\scenes\yeahright_MC.txt');
secondFeatures=load('D:\scenes\yeahright_4spp_2ndF.txt');
secondFeatures=reshape(secondFeatures',36,size(mcSample,1))';
trueGround=importdata('D:\pbrt-scenes\groudTruth\yeahright.txt');
noiseFlag=zeros(size(mcSample,1),1);
relE=((mcSample-trueGround).^2)./(trueGround.^2);
relE=sum(relE,2);
for i=1:1:size(mcSample,1)
    if relE(i,1) > 0.001
         noiseFlag(i,1)=1;
    end
end
details = [noiseFlag,secondFeatures];
noise_num = sum(details(:,1))
pixel_num = size(mcSample,1)
fid=fopen('d:\yeahright.txt','w');
for i=1:1:size(mcSample,1)
    fprintf(fid,'%d 1:%f 2:%f 3:%f 4:%f 5:%f 6:%f 7:%f 8:%f 9:%f 10:%f 11:%f 12:%f 13:%f 14:%f 15:%f 16:%f 17:%f 18:%f 19:%f 20:%f 21:%f 22:%f 23:%f 24:%f 25:%f 26:%f 27:%f 28:%f 29:%f 30:%f 31:%f 32:%f 33:%f 34:%f 35:%f 36:%f\r\n',details(i,1:end));
end
fclose(fid);
