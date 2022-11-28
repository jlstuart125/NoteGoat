
%sheet = read_gray("test_data/mama.jpg");
sheet = read_gray("test_data/andante_sheet.png");
note_image = read_gray("note_head_temp.png");

%create n new sub windows from these clefs that capture the whole staff
% top should extend above the treble clef ; bottom beneath the bass clef
% on the top-most sub window, 
% MAYBE - create a window to the right of the treble
% clef to house the key signature (and time signature)

treble_image = read_gray('test_data/treble_bass.png');
scales = [1, 2, 3, 4, 5];

[subwindows, result] = detect_clefs(sheet, treble_image, scales);

figure(10); imshow(subwindows(:,:,2),[]);
[staff_lines, notes] = separate_lines(subwindows(:,:,2));

%figure(1);imshow(treble_image, []);
%figure(2);imshow(result, []);
%100 looks good but omits the bars on top 
% 400 keeps the bars for the eighth notes but also keeps some extra bars on
% top 

%{

kernel = strel("line",100,0);
%size(subwindows,3)
for i = 2:2 
    %figure(i); imshow(subwindows(:,:,i),[]);
    subInv = imcomplement(subwindows(:,:,i));
    subInv = imopen(subInv,kernel);
    subwindows(:,:,i) = imclose(subInv,kernel);
    figure(i + 5);imshow(imcomplement(subInv),[]);
    subCom = subwindows(:, :, i) ~= imcomplement(subInv);
    figure(i + 6); imshow(imcomplement(subCom),[]);
end
%}
for j = 1:1:  1200 - 20 
    window = subwindows(:, j : j + 20,1);
    window = imopen(window,ones(2,2));
    %imshow(window,[]);
end

% exclude the clefs and signatures from each subwindow and we begin
% reading notes?

% or begin by separating each subwindow into individual bars
% do this by using line fitting to find those lines that are straight up
% and down

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% HI LOOK HERE PLZ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% So this loop gets all the measures out of the second subwindow(the second from top stanza) 
%% What I want to happen is take one measure and do the correlation with a quarter note as the template
%% and then look at the results

lines = get_measure_lines(notes);
for i = 1: length(lines) - 1
    measure_image = get_measure_im(notes,lines,i);
    figure(i); imshow(measure_image,[]);
end

measure_image = get_measure_im(notes,lines,1);

%% Here is where I was trying to accomplish that 
[~,img]  = detect_notes(measure_image, note_image);
imshow(img,[]);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
BW = edge(notes,'canny');
%BW = imfill(BW,"holes");
%BW = imclose(BW,[0,1,0;0,1,0;0,1,0]);
figure(1); imshow(BW);

[H,T,R] = hough(BW);
%figure(2);imshow(H,[],'XData',T,'YData',R,...
           % 'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;

%The last parameter's coeffecient was adjusted from the original code,
% last value is the threshold that controls which peaks are accepted as
% lines
P  = houghpeaks(H,5,'threshold',ceil(0.1*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','white');

lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',150);
figure, imshow(subwindows(:,:,2),[]), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

measure_offset = 30;

 bar_window = subwindows(:,:,2);
 bar_window = bar_window(lines(2).point1(2) - measure_offset:lines(2).point2(2) + measure_offset,lines(2).point1(1):lines(3).point1(1));
 figure(100); imshow(bar_window,[]);

 %}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Let's Try the Radon transform
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for detecting lines

%{

theta = 85:95;             % IT seems we can specify the angles we are looking for, pretty sick 
[R,xp] = radon(BW,theta);

figure
imagesc(theta,xp,R)
colormap(hot)
xlabel("\theta (degrees)")
ylabel("x^{\prime} (pixels from center)")
title("R_{\theta} (x^{\prime})")
colorbar

R_sort = sort(unique(R),"descend");

[row_peak,col_peak] = find(ismember(R,R_sort(1:20)));
xp_peak_offset = xp(row_peak);
theta_peak = theta(col_peak);

centerX = ceil(size(subwindows(:,:,1),2)/2);
centerY = ceil(size(subwindows(:,:,1),1)/2);

figure
imshow(imcomplement(subInv),[]);
hold on
scatter(centerX,centerY,50,"bx",LineWidth=2)

[x1,y1] = pol2cart(deg2rad(0),100);
plot([centerX-x1 centerX+x1],[centerY+y1 centerY-y1],"r--",LineWidth=2)


for i=1:20
plot([centerX-x1 centerX+x1], ...
    [centerY+y1-xp_peak_offset(i) centerY-y1-xp_peak_offset(i)], ...
    "g",LineWidth=2)
end

%}

% Store the notes in some reasonable array that measures time along the x
% axis and signal for note sounding or note initiated

%  ---- 
