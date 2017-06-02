function filterImg = svrfilterClass(mcSample,width,hight,half_patch)
    %Eq. 2 And Eq. 1
    complete = 0;%记录总做进度
    disp('Filter working!');

    filterImg=mcSample;
    
    
    for i_row=1:1:hight
        for i_col=1:1:width
        i=(i_row-1)*width+i_col;
       % if NoiseFlag(i,1)==-1
       
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
        
            patch_img=filterImg(j_row_start:j_row_end,j_col_start:j_col_end); %获取patch块
            ci=mean(mean(patch_img));
            dev=mcSample(i_row,i_col)-ci;
            if dev>2*ci
            adddev=dev/((2*half_patch+1)^2);
            filterImg(j_row_start:j_row_end,j_col_start:j_col_end)=patch_img+adddev;
            end

%        else
%            filterImg(i_row,i_col)=mcSample(i_row,i_col);
%        end
        if rem(i,100000)==0
            complete = complete + 10
        end
        end
    end
end

