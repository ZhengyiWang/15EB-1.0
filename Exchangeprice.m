function [newExchangeprice,Day] = Exchangeprice( Exchangeprice,Dayrange,Duration,price)
%在本期可交换债券换股期内，当标的股票在任意连续20个交易日中至少10个交易日的收盘价低于当期换股价格的85%时，
%发行人董事会有权决定换股价格是否向下修正。
%%假设当发行方认为股票在将来无法到达换股价格时，且确实存在下修意愿时，进行下修。认为无法达到换股价格的标准可以设置为当在一定时间后股价依旧没有到达一定的金额，比如下修条款的上限
%修正后的换股价格应不低于董事会决议签署日前1个交易日标的股票收盘价的90%以及前20个交易日收盘价均价的90%.
%若在前述20个交易日内发生过换股价格调整的情形，则在换股价格调整日前的交易日按调整前的换股价格和收盘价计算
%在换股价格调整日及之后的交易日按调整后的换股价格和收盘价计算。

%参数含义： Exchangeprice为原转股价格，Dayrange为判定的区间，对应20个交易日
%Duration为需要满足的条件，对应10个交易日，price为股票价格数组
%为了避免使函数的参数过多，因此直接将90%、85%写入函数中
%由于估值的开始日期为3月31日，转股开始日期为6月20日，所以在检查是否满足转股条件时需要从第52天开始

sum=0; %用于计算20个交易日的收盘均价
count=0;%满足条件的交易日数
Length=length(price); %记录总共的模拟天数
newExchangeprice=Exchangeprice; %用来记录各转股价格
Day=[];%开辟数组，用来记录转股价格的变化日期
checkday=400; %D，开始准备下修的日期  %checckday,price_floor重构时应在主函数中设置
price_floor=11.8; %l,下修价格的下限

%设置换股价格为19.69肯定是基于一个长远的打算的定价。
%对于一个年化收益率将近30%的股票，长度为3年的EB产品，前期股票价格低于转股价格属正常情况，这时发行方一般不会选择下修（实证分析验证）
%通过对蒙特卡罗模拟的实验结果分析可以发现，第一次到达16元（近似为启动下修条款的上限）的所有数据的箱线图的上边缘大约需350天左右（超过上、下边缘的数据可以认为是异常值）。
%因此我假设从350天后如果股价依旧没有超过这个价格，则发行方将预期大概率难以转股，若其存在下修意图（EB偏股性），则应决定进行下修。
%另一方面，我们认为对于转股价格应该有一个下限,本次选择11.8（从实证分析，EB下修平均幅度为23%，最低幅度为40%，本模型选择价格下限为下修40%）。一方面，发行方应该不会同意无限制的进行下修；另一方面，其手中持有的可质押股票数量也制约了其下修能力的能力

for i=checkday:checkday+Dayrange-1 %由于后面要计算i-20，所以先检查前20日的股价
    if price(i)<Exchangeprice*0.85
        count=count+1;
    end
        sum=sum+price(i);
end
   if(count>=Duration)
         newExchangeprice=[newExchangeprice,max(max(sum/Dayrange*0.9,price(i)*0.9),price_floor)];
          Day=[Day,i];
          count=0; %下调换股价格后便清零计数
   end

    
for i=checkday+Dayrange:Length %检查后一段时间，始终保持Dayrange内的计数和价格总和（通过减除Dayrange前数据的方式实现）
    if price(i)<Exchangeprice*0.85
        count=count+1;
    end
    if(price(i-Dayrange)<Exchangeprice*0.85)
        count=count-1;
    end
        sum=sum+price(i);
        sum=sum-price(i-Dayrange);
    if(count>=Duration)
          newExchangeprice=[newExchangeprice,max(max(sum/Dayrange*0.9,price(i)*0.9),price_floor)];
          Day=[Day,i];
          count=0;
    end
end
Day=[51,Day,Length]; %由于前51天不发生转股行为，所以初始日期应该从51开始计算？
end

