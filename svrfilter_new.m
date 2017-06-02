function filterImg = svrfilter_new(noiseFlag,mcSample,secondFeatures,weights,width,hight,half_patch)
    
    complete = 0;%记录总做进度
    beta=7;%beta预定
    disp('Filter working!');
    patch_size = 2*half_patch+1;
    filterImg=mcSample;
   
    
    
    meanOffset=5;
    stddevOffset=10;
    
    position_r=-half_patch:half_patch;
    position_r=abs(position_r);
    position_c=position_r';
    position=bsxfun(@plus,(position_c.^2),(position_r.^2));
        E=eye(hight,width);
        E=E*(1*10^(-4));
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
        
      if noiseFlag(i,1)==0
      else
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
        dcolor=dcolor./0.0001;
        
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
        
      end    
        if rem(i,100000)==0
            complete = complete + 10
        end
     end
    end
end


