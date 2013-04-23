function A=registerPoints(xy1,xy2);
% Timothee Cour, 06-Jun-2008 05:41:57 -- DO NOT DISTRIBUTE

[n1,d1]=size(xy1);
[n2,d2]=size(xy2);
assert(d1==2 && d2==2 && n1==n2);

a1=[xy1,ones(n1,1)]\xy2(:,1);
a2=[xy1,ones(n1,1)]\xy2(:,2);
A=[a1';a2';0,0,1];
