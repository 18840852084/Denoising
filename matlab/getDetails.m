function details = getDetails(trueGround_R,secondFeatures,width,hight,half_patch)
    complete=0;
    details=zeros(width*hight,37);
    details(:,2:end)=secondFeatures;
     for i_row=1:1:hight
        for i_col=1:1:width
            i=(i_row-1)*width+i_col;
       
            j_col_start = i_col - half_patch;
            j_col_end = i_col + half_patch;
            j_row_start = i_row - half_patch;
            j_row_end = i_row + half_patch;

        %确定patch块的大小
            if j_col_start < 1

                j_col_start =1;
            end
            if j_col_end > width

                j_col_end = width;
            end
            if j_row_start < 1

                j_row_start =1;
            end
            if j_row_end > hight

                j_row_end = hight;
            end
        
            patch_img=trueGround_R(j_row_start:j_row_end,j_col_start:j_col_end); %获取patch块
            ci=mean(mean(patch_img));
            min=bsxfun(@minus,patch_img,ci);
            if sum(sum((min.^2)/(ci.^2+0.001)))>3
                details(i,1)=1;
            end
            
            if rem(i,100000)==0
                complete = complete + 10
            end
       end
      
    end



end

