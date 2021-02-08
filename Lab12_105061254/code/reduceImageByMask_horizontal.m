function imageReduced = reduceImageByMask_horizontal(image, seamMask)
    % Note that the type of the mask is logical and you 
    % can make use of this.
    
    %%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE:
    %%%%%%%%%%%%%%%%%%
    [optSeamMask, seamEnergy] = findOptSeam_horizontal(seamMask);
    
    [rows,columns] = size(optSeamMask);

    reducedColorImage = zeros(rows-1, columns, 3);

    for i = 1:columns
        index = find(optSeamMask(:,i) == 0);
        if index == 1
            reducedColorImage(1:rows-1, i, :) = image(2:rows, i,:);
        elseif index == rows
            reducedColorImage(1:rows-1, i, :) = image(1:rows-1, i, :);
        else
            reducedColorImage(1:index-1, i, :) = image(1:index-1, i, :);
            reducedColorImage(index:rows-1, i, :) = image(index+1:rows, i,:);
        end
    end
    imageReduced = uint8(reducedColorImage);
    %%%%%%%%%%%%%%%%%%
    % END OF YOUR CODE
    %%%%%%%%%%%%%%%%%%
end

