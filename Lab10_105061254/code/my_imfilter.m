function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% See 'help imfilter' or 'help conv2'. While terms like "filtering" and
% "convolution" might be used interchangeably, and they are indeed nearly
% the same thing, there is a difference:
% from 'help filter2'
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.
% Your function should work for color images. Simply filter each color
% channel independently.
% Your function should work for filters of any width and height
% combination, as long as the width and height are odd (e.g. 1, 7, 9). This
% restriction makes it unambigious which pixel in the filter is the center
% pixel.
% Boundary handling can be tricky. The filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% you look at 'help conv2' and 'help imfilter' you see that they have
% several options to deal with boundaries. You should simply recreate the
% default behavior of imfilter -- pad the input image with zeros, and
% return a filtered image which matches the input resolution. A better
% approach is to mirror the image content over the boundaries for padding.
% % Uncomment if you want to simply call imfilter so you can see the desired
% % behavior. When you write your actual solution, you can't use imfilter,
% % filter2, conv2, etc. Simply loop over all the pixels and do the actual
% % computation. It might be slow.
% output = imfilter(image, filter);

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%
[height, width, channel] = size(image);
[filterHeight, filterWidth, channel2] = size(filter);
result = zeros(height, width, 3);

for x = 1:width
    for y = 1:height
        red = 0.0;
        green = 0.0;
        blue = 0.0;
        
        for filterY = 1:filterHeight
            for filterX = 1:filterWidth
                imageX = floor(x - filterWidth/2 + filterX);
                imageY = floor(y - filterHeight/2 + filterY);
                
                if imageX >= 1 && imageY >= 1 && imageX <= width && imageY <= height
                    red = red + image(imageY, imageX, 1)*filter(filterY, filterX);
                    green = green + image(imageY, imageX, 2)*filter(filterY, filterX);
                    blue = blue + image(imageY, imageX, 3)*filter(filterY, filterX);
                end
            end
        end
        result(y, x, 1) = min(red, 1);
        result(y, x, 2) = min(green, 1);
        result(y, x, 3) = min(blue, 1);
    end
end
output = result;
%%%%%%%%%%%%%%%%
% Your code end
%%%%%%%%%%%%%%%%
