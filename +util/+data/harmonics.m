function [v1x, v1y, v2x, v2y] = harmonics(logdata, sls)
% Read logdata and extract first and second harmonics in Volts.
% sls is the lockin sensitivity in V.

v1x = logdata.lockin.X;
v1y = logdata.lockin.Y;
v2x = sls*logdata.lockin.AUX1;
v2y = sls*logdata.lockin.AUX2;

end