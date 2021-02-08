% input1---source image: I
% input2---flip direction: type (0: horizontal, 1: vertical, 2: both)
% output---flipped image: I_flip

function I_flip = flip(I, type);

% RGB channel
R = I(:, :, 1);
G = I(:, :, 2);
B = I(:, :, 3);

% get height, width, channel of image
[height, width, channel] = size(I);

%%  horizontal flipping
if type == 0
    % initial r, g, b array for flipped image using zeros()
    R_flip = zeros(height, width);
    G_flip = zeros(height, width);
    B_flip = zeros(height, width);
    
    % assign pixels from R, G, B to R_flip, G_flip, B_flip
    %%% your code here %%%
    for i = 1:width
        R_flip(:, i) = R(:, width + 1 - i);
        G_flip(:, i) = G(:, width + 1 - i);
        B_flip(:, i) = B(:, width + 1 - i);
    end
    
    % save R_flip, G_flip, B_flip to output image
    I_flip(:, :, 1) = uint8(R_flip);
    I_flip(:, :, 2) = uint8(G_flip);
    I_flip(:, :, 3) = uint8(B_flip);
end

%% vertical flipping
if type == 1
    % initial r, g, b array for flipped image using zeros()
    R_flip = zeros(height, width);
    G_flip = zeros(height, width);
    B_flip = zeros(height, width);
    
    % assign pixels from R, G, B to R_flip, G_flip, B_flip
    for i = 1:height
        R_flip(i, :) = R(height + 1 - i, :);
        G_flip(i, :) = G(height + 1 - i, :);
        B_flip(i, :) = B(height + 1 - i, :);
    end
    
    % save R_flip, G_flip, B_flip to output image
    I_flip(:, :, 1) = uint8(R_flip);
    I_flip(:, :, 2) = uint8(G_flip);
    I_flip(:, :, 3) = uint8(B_flip);
end

%%  horizontal + vertical flipping
if type == 2
    I_flip = flip(I, 0);        %first, do horizontal flipping
    I_flip = flip(I_flip, 1);   %second, do vertical flipping
end