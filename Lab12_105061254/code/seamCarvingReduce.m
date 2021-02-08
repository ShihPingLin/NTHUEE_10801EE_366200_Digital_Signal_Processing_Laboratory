function output = seamCarvingReduce(image, newSize, vertical)
    % How many seam you need to delet from origin image
    reducesize = newSize;
    
    % Delet each seam 
    %%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE:
    %%%%%%%%%%%%%%%%%%
    % You can use a for loop to delet each seam
    % with your "energyRGB", "findOptSeam", "reduceImageByMask"
    if vertical == 1
        for num = 1:1:reducesize
            energy = energyRGB(image);
            image = reduceImageByMask(image, energy);
        end
    else
        for num = 1:1:reducesize
            energy = energyRGB(image);
            image = reduceImageByMask_horizontal(image, energy);
        end
    end
    
    %%%%%%%%%%%%%%%%%%
    % END OF YOUR CODE
    %%%%%%%%%%%%%%%%%%
        
    output = image;
end    