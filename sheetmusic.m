
%sheet = read_gray("test_data/mama.jpg");
sheet = read_gray("test_data/andante_sheet.png");
treble_image = read_gray('test_data/treble_bass.png');
scales = [1, 2, 3, 4, 5];

[subwindows, result] = detect_clefs(sheet, treble_image, scales);

%figure(1);imshow(treble_image, []);
%figure(2);imshow(result, []);

for i = 1: size(subwindows,3)
    figure(i);imshow(subwindows(:,:,i),[]);
end

%create n new sub windows from these clefs that capture the whole staff
% top should extend above the treble clef ; bottom beneath the bass clef
% on the top-most sub window, create a window to the right of the treble
%   clef to house the key signature (and time signature)

% now exclude the clefs and signatures from each subwindow and we begin
% reading notes

% Store the notes in some reasonable array that measures time along the x
% axis and signal for note sounding or note initiated

%  ---- 
