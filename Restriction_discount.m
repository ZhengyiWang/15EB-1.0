function discount= Restriction_discount( S,T,r,sigma )
%S为基准日股票价格，T为期权限制时间，r为无风险利率，X为执行价格
X=S*(1+r)^T;
d1=(log(S/X)+(r+sigma^2/2)*T)/(sigma*sqrt(T));
d2=d1-(sigma*sqrt(T));
putprice=X*exp(-r*T)*normcdf(-d2)-S*normcdf(-d1);
discount=1-putprice/S;
end

