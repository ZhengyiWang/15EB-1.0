function [finalday,flag] = Redemption( Exchangeprice,Dayrange,Duration,price,startday,Length)
%换股期内，当下述两种情形的任意一种出现时，发行人有权决定按照债券面值加当期应计利息的价格赎回全部或部分未换股的可交换债券：
%①在换股期内，如果标的股票在任何连续30个交易日中至少15个交易日的收盘价格不低于当期换股价格的130%（含130%）；
%②当本期可交换债券未换股余额不足3,000万元时。
%当期应计利息的计算公式为：IA=B×i×t/365  
%IA：指当期应计利息；B：指本期可交换债券持有人持有的可交换债券票面总金额；
%i：指可交换债券当年票面利率；t：指计息天数，即从上一个付息日起至本计息年度赎回日止的实际日历天数（算头不算尾）。
%若在前述30个交易日内发生过换股价格调整的情形，则在调整前的交易日按调整前的换股价格和收盘价计算，调整后的交易日按调整后的换股价格和收盘价计算。 
%不足3000万元时在考虑减持新规的时候需要考虑。
%需要返回最终的达成赎回条款的日期finalday

%参数含义： Exchangeprice为原转股价格，Dayrange为判定的区间，对应30个交易日
%Duration为需要满足的条件，对应15个交易日,price为股票价格数组
%为了避免使函数的参数过多，因此直接将130%写入函数中
%如果满足条件，则返回3；如果不满足条件，则返回0

finalday=startday;
flag=0;
count=0;

if Length<=Dayrange %如果两次下修的时间间隔小于30天（极端情况为前15天>1.3*exchangeprice,后10天<0.85exchangeprice）
    for finalday=startday:startday+Length-1 %检查整段时间
        if(price(finalday)>=1.3*Exchangeprice)
            count=count+1;
        end
    if(count>=Duration)
        flag=3;
        return %结束函数，并返回finalday
    end
    end
else  %如果两次下修的时间间隔大于30天
    for finalday=startday:Dayrange+startday-1 %检查前30天是否满足条件
        if(price(finalday)>=1.3*Exchangeprice)
            count=count+1;
        end
    end
    if(count>=Duration)
        flag=3;
        return;
    end

    for finalday=Dayrange+startday:Length+startday-1 %检查第二段
        if(price(finalday)>=1.3*Exchangeprice)
            count=count+1;
        end
        if(price(finalday-Dayrange)>=1.3*Exchangeprice)%如果前31天满足条件则将该次计数清除
            count=count-1;
        end
        if(count>=Duration)
            flag=3;
        return;
        end
    end
end
end

