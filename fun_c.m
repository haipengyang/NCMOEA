function f=fun_c(Maxtrix,lable,degree1)
sum_v_in=0;
sum_v_out=0;
comm_num = 0;
t=max(lable);
for i=1:t
    index=find(lable==i);
    if length(index)>0
        comm_num = comm_num + 1;
        m=Maxtrix(index,index);
        edges_in=(sum(sum(m))-sum(diag(m)))/2+sum(diag(m));
        edges_out=sum(degree1(index))-edges_in*2;
        n=length(index);
        sum_v_in=edges_in/n+sum_v_in;
        sum_v_out=edges_out/n+sum_v_out;
    end
end
f(1)=2*(length(degree1)-comm_num)-sum_v_in*2;
% f(1)=-sum_v_in*2;
f(2)=sum_v_out;
end
























