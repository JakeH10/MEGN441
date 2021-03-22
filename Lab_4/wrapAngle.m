% wrapAngle: limit an angle value given in radians to values between 0 and
% 2*pi
%
%   [ang] = wrapAngle(ang_0)   Any angle above 2*pi has an equivalent angle
%   at the modulus of itself and 2*pi. Any angle less than 0, has an equivalent 
%   angle at + 2*pi. First, large angles are eliminated
%   using the modulus. Then, negative numbers are eliminated, if present,
%   by adding 2*pi
%
%   Parameters
%   ang_0 - the inital angle value in radians
%   
%   Returns
%   ang - the new bounded angle in radians
%
%   Author: Megan Shapiro
%   Date: 3/17/20

function ang = wrapAngle(ang_0)
ang = mod(ang_0, 2*pi); % Wrap to -2*pi to 2*pi
if ang < 0 
    ang = ang + 2*pi; % Wrap to 0 to 2*pi
end
end