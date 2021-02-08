function res = energyRGB(I)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sum up the energy for each channel 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% res = 
res_r = energyGrey(I(:,:,1));
res_g = energyGrey(I(:,:,2));
res_b = energyGrey(I(:,:,3));

res = res_r + res_g + res_b;
end

function res = energyGrey(I)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% returns energy of all pixelels
% e = |dI/dx| + |dI/dy|
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% res = 
filterx = [-1,0,1];
filtery = [-1;0;1];
gradientx = conv2(I, filterx, 'same');
gradienty = conv2(I, filtery, 'same');
res = abs(gradientx) + abs(gradienty);
end

