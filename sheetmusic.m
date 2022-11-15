
sheet = read_gray("andante_sheet.png");

%Template match a treble clef
% and a bass clef 
%  - hope that the highest n results indicate the beginning of a staff
treble_image = read_gray('treb_shot2.png');
figure();imshow(treble_image);
bbox_size = 50;

norm_corr = normalized_correlation(sheet,treble_image);

new_img = sheet;

figure();imshow(norm_corr,[]);

for j = 1:100
    hi = max(max(norm_corr));

    [i,r] = find(norm_corr == hi);

    box = make_bounding_box(i,r,[bbox_size bbox_size]);
    new_img = draw_rectangle1(new_img,box(1),box(2),box(3),box(4));
    norm_corr(i,r) = -Inf;
end

figure();imshow(new_img,[]);
%create n new sub windows from these clefs that capture the whole staff
% top should extend above the treble clef ; bottom beneath the bass clef
% on the top-most sub window, create a window to the right of the treble
%   clef to house the key signature (and time signature)

% now exclude the clefs and signatures from each subwindow and we begin
% reading notes

% Store the notes in some reasonable array that measures time along the x
% axis and signal for note sounding or note initiated

%  ---- 
