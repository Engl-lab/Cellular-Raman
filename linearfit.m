for n = 1:width(result1)
cvx_begin
A=[];
variable A(15, 1);
minimize( norm(result1(:,n) -library*A, 'fro') );
subject to
A >= 0;
cvx_end
params (:,n) = A;
end