function varargout=size_pq(image);
%{
% Timothee Cour, 30-Jul-2008 10:54:48 -- DO NOT DISTRIBUTE

pq=size_pq(image);
[p,q]=size_pq(image);
%}
[p,q,k]=size(image);
if nargout==1
    pq=[p,q];
    varargout{1}=pq;
elseif nargout==2
    varargout{1}=p;
    varargout{2}=q;
else
    assert(0);
end
