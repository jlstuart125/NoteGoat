function coords = get_measure_lines(stanza_notes)
    BW = edge(stanza_notes,'canny');
    [H,T,R] = hough(BW);
    
    %The last parameter's coeffecient was adjusted from the original code,
    % last value is the threshold that controls which peaks are accepted as
    % lines
    P  = houghpeaks(H,5,'threshold',ceil(0.1*max(H(:))));
    
    coords = houghlines(BW,T,R,P,'FillGap',5,'MinLength',150);
end