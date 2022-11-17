function [subwindows, img] = detect_clefs(sheet, treble_image, scales)
%Template match a treble clef
% and a bass clef 

[result, max_scales] = multiscale_correlation(sheet, treble_image, scales);

new_img = sheet;
treble_locations = zeros(1,2);

for j = 1:100
    hi = max(max(result));
    scale = max_scales(find(result == hi, 1));
    bbox_size = scale * size(treble_image, 1);

    [i,r] = find(result == hi);
    
    %Assign the first value to the treble coords
    if(j == 1)
        treble_locations(:,1) = i;
        treble_locations(:,2) = r;
    end 
    
    %if the difference between the new column or row and any of the
    %previous ones is less than some threshold, don't include it
    if any(abs(treble_locations(:,1) - i) < 10,1)
        result(i,r) = -Inf;
        continue
    end
    
    %Tack on the next unique location onto the list 
    treble_locations = vertcat(treble_locations,[i,r]); %#ok<AGROW> 

    result(i,r) = -Inf;
end

treble_locations = sort(treble_locations,"ascend");

offset = floor(bbox_size/2);
subwindows = zeros(2*offset+1,size(sheet,2),size(treble_locations,1)); 

%Draw boxes for the trebles / make subwindows
for i = 1:size(treble_locations,1)
    box = make_bounding_box(treble_locations(i,1),treble_locations(i,2),[3 3]);
    new_img = draw_rectangle(new_img,box(1),box(2),box(3),box(4));
    subwindows(:,:,i) = sheet(treble_locations(i,1) - offset : treble_locations(i,1) + offset, 1:end);
end

img = new_img;

end