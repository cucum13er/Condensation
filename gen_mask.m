function mask = gen_mask(mask_size, class, small_width, big_width, sinF, sinA, hole_range)
region_mask = zeros(mask_size);
pair = floor(mask_size(1)/(small_width+big_width));
col = 1:mask_size(2);
if strcmpi(class,"sin")
    for j = 1:pair
        row1 = (small_width+big_width)*(j-1)+big_width+1;
        row2 = (small_width+big_width)*j;
        for i = 1:length(sinF)
            row1 = row1 + rand*(sinA)*sin(2*pi*sinF(i)*col/mask_size(2));
            row2 = row2 - rand*(sinA)*sin(2*pi*sinF(i)*col/mask_size(2));
        end
        if j == 1
            row1(row1<0)=0;
        elseif j == pair
            row2(row2>mask_size(1)) = mask_size(1);
        end
        for i = 1:1000
            region_mask(round(row1(i)):round(row2(i)),col(i),1) = 1;
        end
    end
elseif strcmpi(class,"line")
    for j = 1:pair
        row1 = (small_width+big_width)*(j-1)+big_width+1;
        row2 = (small_width+big_width)*j;
        region_mask(row1:row2,:,1) = 1;

    end
elseif strcmpi(class,"hole")
    
elseif strcmpi(class,"sin&hole")
else
end

mask = 1 - region_mask;

end