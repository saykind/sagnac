% To execute the tests, run:
%   results = run(test.util.coarse.grid)
%   or
%   runtests('test.util.coarse.grid')

function tests = grid
    tests = functiontests(localfunctions);
end

function test_dx_zero(testCase)
    dx = 0;
    xmin = [1 2 3 4 5];
    expected_output = xmin;
    actual_output = util.coarse.grid(dx, xmin);
    verifyEqual(testCase, actual_output, expected_output, 'AbsTol', 1e-12);
end

function test_positive_dx(testCase)
    dx = 0.5;
    xmin = 1;
    xmax = 3;
    expected_output = [0.75, 1.25, 1.75, 2.25, 2.75, 3.25];
    actual_output = util.coarse.grid(dx, xmin, xmax);
    verifyEqual(testCase, actual_output, expected_output, 'AbsTol', 1e-12);
end

function test_negative_dx(testCase)
    dx = -1;
    xmin = 0.5;
    xmax = 1.5;
    expected_output = [0.5, 1.5];
    actual_output = util.coarse.grid(dx, xmin, xmax);
    verifyEqual(testCase, actual_output, expected_output, 'AbsTol', 1e-12);
end

function test_single_input(testCase)
    dx = 1;
    xmin = [0.5, 1.5];
    expected_output = [0, 1, 2];
    actual_output = util.coarse.grid(dx, xmin);
    verifyEqual(testCase, actual_output, expected_output, 'AbsTol', 1e-12);
end
