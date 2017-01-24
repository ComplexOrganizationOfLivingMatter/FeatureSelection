function [ xintersect, yintersect ] = intersectTwoLines( line1, line2 )
%INTERSECTTWOLINES Summary of this function goes here
%   Detailed explanation goes here
    slope = @(line) (line(2,2) - line(1,2))/(line(2,1) - line(1,1));
    m1 = slope(line1)
    m2 = slope(line2)
    
    intercept = @(line,m) line(1,2) - m*line(1,1);
    b1 = intercept(line1,m1)
    b2 = intercept(line2,m2)
    xintersect = (b2-b1)/(m1-m2)
    yintersect = m1*xintersect + b1

end

