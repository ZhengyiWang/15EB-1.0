function discount= Restriction_discount( S,T,r,sigma )
%SΪ��׼�չ�Ʊ�۸�TΪ��Ȩ����ʱ�䣬rΪ�޷������ʣ�XΪִ�м۸�
X=S*(1+r)^T;
d1=(log(S/X)+(r+sigma^2/2)*T)/(sigma*sqrt(T));
d2=d1-(sigma*sqrt(T));
putprice=X*exp(-r*T)*normcdf(-d2)-S*normcdf(-d1);
discount=1-putprice/S;
end

