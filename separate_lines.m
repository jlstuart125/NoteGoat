function [staff_image, notes_image] = separate_lines(staff)
    kernel = strel("line",600,0);
    subInv = imcomplement(staff);
    subInv = imopen(subInv,kernel);
    subCom = staff ~= imcomplement(subInv);

    staff_image = imcomplement(subInv);
    notes_image = imcomplement(subCom);
end