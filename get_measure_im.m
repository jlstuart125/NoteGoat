function bar_window = get_measure_im(stanza_notes,stanza_lines, measure_number)
    if(measure_number == length(stanza_lines))
        print("Invalid Measure number");
        exit;
    end

    measure_offset = 30;
    bar_window = stanza_notes(stanza_lines(measure_number).point1(2) - measure_offset:stanza_lines(measure_number).point2(2) + measure_offset, ...
        stanza_lines(measure_number).point1(1):stanza_lines(measure_number + 1).point1(1));
end