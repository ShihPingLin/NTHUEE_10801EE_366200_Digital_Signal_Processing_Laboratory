function [optSeamMask, seamEnergy] = findOptSeam_horizontal(energy)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Following paper by Avidan and Shamir `07
% Finds optimal seam by the given energy of an image
% Returns mask with 0 mean a pixel is in the seam
% You only need to implement vertical seam. For
% horizontal case, just using the same function by 
% giving energy for the transpose image I'.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Find M for vertical seams
    % Add one element of padding in vertical dimension 
    % to avoid handling border elements
    M = padarray(energy, [1 0], realmax('double'));
    sz = size(M);
    rows = sz(1);
    columns = sz(2);
    % For all rows starting from second row, fill in the minimum 
    % energy for all possible seam for each (i,j) in M, which
    % M[i, j] = e[i, j] + min(M[i - 1, j - 1], M[i - 1, j], M[i - 1, j + 1]).     
    
    %%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE:
    %%%%%%%%%%%%%%%%%%
    
    % For horizontal
    for j = 2: columns
        for i = 2: rows-1
            M(i, j) = energy(i-1, j) + min([M(i-1,j-1), M(i,j-1), M(i+1,j-1)]);
        end
        %M(i,1) = energy(i,1) + min([M(i-1,1), M(i-1,2)]);
        %M(i,columns) = energy(i,columns-1) + min([M(i-1,columns), M(i-1,columns-1)]);
    end
    
    % For horizontal
    %M(:,1) = energy(:,1);
    %for j = 2: columns
    %    for i = 2: rows-1   
    %        M(i,j) = energyImage(i,j) + min([M(i-1,j-1), M(i,j-1), M(i+1,j-1)]);
    %    end
    %    M(1,j) = energyImage(1,j) + min([M(1,j-1), M(2,j-1)]);
    %    M(rows,j) = energyImage(rows,j) + min([M(rows-1,j-1), M(rows,j-1)]);
    %end
    
    %%%%%%%%%%%%%%%%%%
    % END OF YOUR CODE
    %%%%%%%%%%%%%%%%%%

    % Find the minimum element in the last raw of M
    [val, idx] = min(M(:, columns));
    seamEnergy = val;
    fprintf('Optimal energy: %f\n',seamEnergy);
    
    % Initial for optimal seam mask
    optSeamMask = zeros(size(energy), 'uint8');
    
    % Traverse back the path of seam with minimum energy
    % and update optimal seam mask, which (i,j) value of 
    % a seam should be set to 1 here
    % (Aware the size of mask and the M is different)
    
    %%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE:
    %%%%%%%%%%%%%%%%%%
    optSeamMask(idx-1, columns) = 1;
    for i = columns-1:-1:1
        minimum = min(M(idx-1:idx+1, i));
        if minimum == M(idx-1, i)
            idx = idx - 1;
        elseif minimum == M(idx, i)
            idx = idx;
        else
            idx = idx + 1;
        end
        optSeamMask(idx-1, i) = 1;
    end
    
    %%%%%%%%%%%%%%%%%%
    % END OF YOUR CODE
    %%%%%%%%%%%%%%%%%%
    
    % convert the mask to logical
    optSeamMask = ~optSeamMask; 
    
end
