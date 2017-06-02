function [colos,pic_mean] = svm2getcolor( mcSample,secondFeatures,width,hight,half_patch )
    complete=0;
   colos=zeros(width*hight,1);
   pic_mean=zeros(width*hight,1);
   patch_size=half_patch+half_patch+1;
   
    position_r=-27:27;
    position_r=abs(position_r);
    position_c=position_r';
    position=bsxfun(@plus,(position_c.^2),(position_r.^2));
    
    for i_row=1:1:hight
        for i_col=1:1:width
        i=(i_row-1)*width+i_col;
        
        
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
        
       
        patch_pos_a=patch_img./(pos+0.01);
        patch_pos=sum(sum(patch_pos_a));
        
        patch_mean=mean(mean(patch_img));

        
        colos(i,1)=1/(1+exp(-patch_pos));
        pic_mean(i,1)=patch_mean;
        if rem(i,100000)==0
            complete = complete + 10
        end
        end
    end
        
        colos =[secondFeatures,colos];
end

