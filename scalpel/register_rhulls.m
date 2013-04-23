function A=register_rhulls(rhull1,rhull2);
% Timothee Cour, 06-Jun-2008 05:41:57 -- DO NOT DISTRIBUTE

xy1=rhull2rectangle(rhull1);
xy2=rhull2rectangle(rhull2);
A=registerPoints(xy1,xy2);
