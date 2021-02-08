function [xs,ns] = Seqshift(x, nx, n0)
%   Seqshift function
%
%   [xs,ns] = Seqshift(x, nx, n0)
%   xs(n) = x(n - n0)
%   shift the sequence x(location vector = nx)
%   with n0 units(>0 => right shift; <0 => left shift)
%   get the resulting sequence xs(location vector = ns)
%
%   2019/7/28 Shih Ping Lin
xs = x;
ns = nx + n0;