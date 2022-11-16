function [result, subwindows] = detect_clefs(sheet, treble_image, scales)
%Template match a treble clef
% and a bass clef 
%  - hope that the highest n results indicate the beginning of a staff

norm_corr = normalized_correlation(sheet,treble_image);

[result, max_scales] = multiscale_correlation(sheet, treble_image, scales);

new_img = sheet;

for j = 1:100
    hi = max(max(result));
    scale = max_scales(find(result == hi, 1))
    bbox_size = scale * size(treble_image, 1)

    [i,r] = find(result == hi);

    box = make_bounding_box(i,r,[bbox_size bbox_size]);
    new_img = draw_rectangle(new_img,box(1),box(2),box(3),box(4));
    result(i,r) = -Inf;
end


end