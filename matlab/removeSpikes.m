function filterImg= removeSpikes(mcSample,width,hight,half_patch)
    complete = 0;%记录总做进度
    disp('Filter working!');

    filterImg=mcSample;
    
    
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
        
            patch_img=mcSample(j_row_start:j_row_end,j_col_start:j_col_end); %获取patch块
            ci=mean(mean(patch_img));
            temp1=bsxfun(@minus,patch_img,ci);
            temp1=temp1.^2;
            temp2=sum(sum(temp1))/9;
            if (mcSample(i_row,i_col)-ci)^2>temp2;
                filterImg(i_row,i_col)=ci;
            end
        
            
            if rem(i,100000)==0
                complete = complete + 10
            end
        end
    end

end

