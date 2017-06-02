function [filterImg,distanceMat] = svrfilter(mcSample,secondFeatures,weights,width,hight,half_patch)
    %Eq. 2 And Eq. 1
    complete = 0;%记录总做进度
    beta=7;%beta预定
    disp('Filter working!');
    patch_size = 55;
    filterImg=zeros(hight,width);
   
    %distanceMat为后期训练用矩阵
    distanceMat=zeros(hight*width,7);
    %共有hight*width行
    %M=7列（见等式14）
    
    meanOffset=5;
    stddevOffset=10;
    
    position_r=-27:27;
    position_r=abs(position_r);
    position_c=position_r';
    position=bsxfun(@plus,(position_c.^2),(position_r.^2));
        E=eye(hight,width);
        E=E*(1*10^(-6));
        disF1=secondFeatures(1:end,meanOffset);%获取K=1平均值块
        disF1=reshape(disF1',width,hight)';
        disF2=secondFeatures(1:end,meanOffset+1);%获取K=2平均值块
        disF2=reshape(disF2',width,hight)';
        disF3=secondFeatures(1:end,meanOffset+2);%获取K=3平均值块
        disF3=reshape(disF3',width,hight)';
        disF4=secondFeatures(1:end,meanOffset+3);%获取K=4平均值块
        disF4=reshape(disF4',width,hight)';
        disF5=secondFeatures(1:end,meanOffset+4);%获取K=5平均值块
        disF5=reshape(disF5',width,hight)';
        
        dev1=secondFeatures(1:end,stddevOffset);
        dev1=reshape(dev1',width,hight)'.^2+E;
        dev2=secondFeatures(1:end,stddevOffset+1);
        dev2=reshape(dev2',width,hight)'.^2+E;
        dev3=secondFeatures(1:end,stddevOffset+2);
        dev3=reshape(dev3',width,hight)'.^2+E;
        dev4=secondFeatures(1:end,stddevOffset+3);
        dev4=reshape(dev4',width,hight)'.^2+E;
        dev5=secondFeatures(1:end,stddevOffset+4);
        dev5=reshape(dev5',width,hight)'.^2+E;
    
    for i_row=1:1:hight
        for i_col=1:1:width
        i=(i_row-1)*width+i_col;
        
        weight1=weights(i,1);
        weight2=weights(i,2);
        weight3=weights(i,3);
        weight4=weights(i,4);
        weight5=weights(i,5);
        weight6=weights(i,6);
        
        j_col_start = i_col - half_patch;
        j_col_end = i_col + half_patch;
        j_row_start = i_row - half_patch;
        j_row_end = i_row + half_patch;
        pos_l=1;
        pos_u=1;
        pos_b=patch_size;
        pos_r=patch_size;
        %确定patch块的大小
        if j_col_start < 1
            pos_l= 2-j_col_start;
            j_col_start =1;
            
        end
        if j_col_end > width
            pos_r =patch_size-(j_col_end - width);
            j_col_end = width;
        end
        if j_row_start < 1
            pos_u= 2 -j_row_start;
            j_row_start =1;
        end
        if j_row_end > hight
            pos_b =patch_size-(j_row_end -hight);
            j_row_end = hight;
        end
        
        patch_img=mcSample(j_row_start:j_row_end,j_col_start:j_col_end); %获取patch块
        
        pos =position(pos_u:pos_b,pos_l:pos_r);
        
        dcolor= bsxfun(@minus,mcSample(i_row,i_col),patch_img);
        dcolor=dcolor.^2;
       % dcolor=dcolor./(1*10);
        
        df1 = disF1(j_row_start:j_row_end,j_col_start:j_col_end);
        d1=dev1(j_row_start:j_row_end,j_col_start:j_col_end);
        df1 = bsxfun(@minus,df1,secondFeatures(i,meanOffset));
        df1=df1.^2;
        df1=df1./d1;
       
        df2 = disF2(j_row_start:j_row_end,j_col_start:j_col_end);
        df2 = bsxfun(@minus,df2,secondFeatures(i,meanOffset+1));
        d2=dev2(j_row_start:j_row_end,j_col_start:j_col_end);
        df2=df2.^2;
        df2=df2./d2;
       
        df3 = disF3(j_row_start:j_row_end,j_col_start:j_col_end);
        df3 = bsxfun(@minus,df3,secondFeatures(i,meanOffset+2));
        d3=dev3(j_row_start:j_row_end,j_col_start:j_col_end);
        df3=df3.^2;
        df3=df3./d3;
        
        df4 = disF4(j_row_start:j_row_end,j_col_start:j_col_end);
        df4 = bsxfun(@minus,df4,secondFeatures(i,meanOffset+3));
        d4=dev4(j_row_start:j_row_end,j_col_start:j_col_end);
        df4=df4.^2;
        df4=df4./d4;
        
        df5 = disF5(j_row_start:j_row_end,j_col_start:j_col_end);
        df5 = bsxfun(@minus,df5,secondFeatures(i,meanOffset+4));
        d5=dev5(j_row_start:j_row_end,j_col_start:j_col_end);
        df5=df5.^2;
        df5=df5./d5;
        
        d=pos*weight1+((1/beta)^2)*dcolor+weight2*df1+weight3*df2+weight4*df3+weight5*df4+weight6*df5;
        d=exp(-d);
        
        %Eq. 1
        d_sum=sum(sum(d));
        ci=sum(sum(patch_img.*d));
        filterImg(i_row,i_col)=ci/d_sum;
        
         %等式14，等式15，为训练做准备
        temp1=sum(sum(patch_img.*d));
        temp2=patch_img*d_sum-temp1;
        temp2=temp2/d_sum^2;
        distanceMat(i,1)=sum(sum(temp2.*(d.*pos)));
        %distanceMat(i,2)=sum(sum(temp2.*(d.*dcolor.*beta^3)));
        distanceMat(i,2)=sum(sum(temp2.*(d.*df1)));
        distanceMat(i,3)=sum(sum(temp2.*(d.*df2)));
        distanceMat(i,4)=sum(sum(temp2.*(d.*df3)));
        distanceMat(i,5)=sum(sum(temp2.*(d.*df4)));
        distanceMat(i,6)=sum(sum(temp2.*(d.*df5)));
        
        if rem(i,100000)==0
            complete = complete + 10
        end
        end
    end
end

