function [X, Y] = adjustPhase(x, y, angle)
    % Rotates data in the complex plane by a given angle.
    %
    % Syntax: [X_new, Y_new] = rotateInComplexPlane(X, Y, angle)
    %
    % Inputs:
    %   x     - Array of X coordinates.
    %   z     - Array of Y coordinates.
    %   angle - Rotation angle in degrees.
    %
    % Outputs:
    %   X - Array of X coordinates after rotation.
    %   Y - Array of Y coordinates after rotation.

    % Create a complex number representation of the input data
    z = x + 1i * y;
    
    % Perform the rotation in the complex plane
    Z = z * exp(1i * deg2rad(angle));
    
    % Extract the real and imaginary parts as the rotated X and Y data
    X = real(Z);
    Y = imag(Z);
end
