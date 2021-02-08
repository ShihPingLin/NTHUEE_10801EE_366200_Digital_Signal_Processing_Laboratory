function imageReduced = reduceImageByMask(image, seamMask)
    % Note that the type of the mask is logical and you 
    % can make use of this.
    
    %%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE:
    %%%%%%%%%%%%%%%%%%
    [optSeamMask, seamEnergy] = findOptSeam(seamMask);
    
    [rows,columns] = size(optSeamMask);

    reducedColorImage = zeros(rows, columns-1, 3);

    for i = 1:rows
        index = find(optSeamMask(i,:) == 0);
        if index == 1
            reducedColorImage(i, 1:columns-1, :) = image(i,2:columns,:);
        elseif index == columns
            reducedColorImage(i, 1:columns-1, :) = image(i,1:columns-1,:);
        else
            reducedColorImage(i, 1:index-1,:) = image(i,1:index-1,:);
            reducedColorImage(i,index:columns-1,:) = image(i,index+1:columns,:);
        end
    end
    imageReduced = uint8(reducedColorImage);
    %%%%%%%%%%%%%%%%%%
    % END OF YOUR CODE
    %%%%%%%%%%%%%%%%%%
end

