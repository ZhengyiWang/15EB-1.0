function [Sellday,flag] = Sell_back( Duration,Exchangeprice,Price,StartDay,Length )
%在发行人本期发行的可交换债券到期前180天内
%如果标的股票在任何连续15个交易日的收盘价格低于当期换股价的80%时，
%债券持有人有权将其持有的可交换债券全部或部分按面值加上当期应计利息的价格回售给公司。 

%参考Exchaneprice函数的写法，将连续15日转变成如果15日内有15日满足条件。

%参数含义： Exchangeprice为换股价格
%Duration为需要满足的条件，对应15个交易日，price为股票价格数组。80%直接写入函数中

%如果满足条件，则返回日期；如果不满足条件，则返回EB到期日
flag=0;
count=0; %用于记录满足条件的天数

for Sellday=StartDay:min(StartDay+Duration-1,658) %有一种低概率的逻辑错误：后15天下修，实际不会发生但程序可能会发生 
    if (Price(Sellday)<Exchangeprice*0.8)
        count=count+1;
    end
end

if count>=Duration
    flag=2;
    return;
end

for Sellday=min(StartDay+Duration,658):Length+StartDay-1
    if (Price(Sellday)<Exchangeprice*0.8)
        count=count+1;
    end
    if(Price(Sellday-Duration)<Exchangeprice*0.8)
        count=count-1;
    end
    if count>=Duration
        flag=2;
        return;
    end
end
end
