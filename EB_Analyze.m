function [result,Sellback_Day,Finally_Day,Normal_Day,Redemption_Day] = EB_Analyze(price_floor,q,checkday)
%将EB script转化成functionn,用于进行敏感性的检验
%已将折扣删除
miu=0.2921; %年化收益率 
sigma=0.5009; %年化波动率
day=678; %2016年3月31日至2018年12月7日共678个交易日，按一年245个交易日计算,其中2016年3月31日到2016年6月20日换股起始日共51个交易日  
r1=0.065;%可交换债券的折现率，以2016年3月31日作为基准日，根据类似评级可交债及可转债利率并考虑自身风险确定
r2=0.045;%本债券利率
%q=1.35; %抛售的天花板倍数，根据实证分析确定（存疑）
%price_floor=19.69; %换股价格的下限
%checkday=350;%开始检查下修的起始日期

flag=0; %用于判断是否满足回售、转股、赎回条款之一，提前结束循环
amount=600000000; %发行总金额：人民币元
firstprice=13.1; %2016年3月31日（基准日）股价
M=500;%实验次数

price=zeros(M,day);%开辟数组空间
price(:,1)=firstprice;%2016年3月31日股票初始价格为13.10
pv=zeros(M,1); %用来存储现值的数组

%如果未达到天花板，则暂不进行转股抛售；期后，（若存在）赎回日，则须当日转股；（若不存在赎回日），则在到期日权衡收益，决定是否换股。（新修改）

j=2; %实验次数计数初始值 
E=[];%开辟一个用于记录进行换股时换股价格的数组 0表示交易日为债券的的截止日期,1表示提前回售，2表示在赎回终止日正常转股，其余数字表示最终转股价格
count=0; %用来记录在赎回条款日完成换股的次数

 for i=1:M %进行M次实验
    while j<=day  %依据几何布朗运动公式模拟股票价格。假设一年245个交易日，所以直接将⊿t定义为1/245
        price(i,j)=price(i,j-1)*exp((miu-0.5*sigma^2)*(1/245)+sigma*(1/245)^0.5*normrnd(0,1));
    %如果最终的股价高于初始价格的3倍或者1/3，则认为该价格超出合理区间，回滚到上一日重新进行计算（根据实证分析的股市波动率及个股波动率，放大后确定了可采信波动范围）
    %欠妥，后期可以根据论文将模拟的过程更加严谨化
        if (price(i,j)>3*firstprice||price(i,j)<1/3*firstprice) 
            j=j;
        else
            j=j+1;
        end
    end
    
    [exchangeprice,Exday] = Exchangeprice(19.69,20,10,price(i,:),price_floor,checkday); %计算出各段的转股价格和转股日期
      
      %计算赎回条款发生的日期D，只取第一个值。即将最终收益的计算范围缩短到赎回条款发生前。如果赎回条款不触发则D=678
      for k1=2:length(Exday) %检查k1-1段 %由于这段是后加的，为避免循环变量重名带来混乱，所以用了k1
          [finalday,flag1] = Redemption(exchangeprice(k1-1),30,15,price(i,:),Exday(k1-1),Exday(k1)-Exday(k1-1));
          if flag1==3 %如果发现某天满足赎回条款，则停止检查，记录天数  为避免和下面的flag冲突，命名为flag1？
              break;
          end
      end
      
    %分段检查在D之前是否存在某日的股价是否满足某项特殊条款或可以转股
    for k=2:length(Exday) %检查k-1段
        for l= Exday(k-1):Exday(k)-1 %检查每一段的每一天是否满足赎回（flag=3）、回售(flag=2)以及转股(flag=1)的条件，l用来记录成交的日期%时间往前均提前了一天（修改）？
            if l<=finalday %首先判断是否未超过交易范围
                if(price(i,l)>=q*exchangeprice(k-1)) %如果是则判断当天的价格是否超过设置的倍数
                    flag=1; %如果高于q*exchangeprice则将标志位设为1
                    E(i)=exchangeprice(k-1);%将最终成交的换股价格记录数组中
                    break; %跳出内循环
                end
                if l==day-123%当剩余天数满足回售条款时，根据当前的换股价格计算回售条款发生的日期，没有则日期最终变为摘牌日 修改成123？
                    %存在一个小bug,如果在最后123天内再次发生下修，则需要在大循环外单独写一段计算回售的日期，接着在本循环内验证是否满足（当然，回售可能性极小）。能否完善？
                    Sellday=Sell_back(123,15,exchangeprice(k-1),price(i,:));
                end
              if(l>day-123&&l<day) %在回售条款期间
                  if l==Sellday %如果该日发生满足了回售条款，且在这之前没有转股或者满足条款赎回，则选择回售，跳出循环
                      flag=2;
                      break;
                  end
              end
            else %如果超过则假设在当天不执行赎回条款，投资者在赎回条款触发前完成换股 %正常情况下应该会选择转股来规避赎回条款
                l=finalday;
                E(i)=exchangeprice(k-1);%将最终的成交换股价格记录到数组中去 是否应该放入赎回价格而非换股价格？
                flag=3;
                count=count+1;
                if l==day %最后一天完成交易,需要另作讨论
                    flag=0;
                    count=count-1;
                end
                break;
            end    
        end
        if (flag==1||flag==2||flag==3);%如果满足回售、赎回以及换股条款中的任意一项，则停止检查下一段，开始计算最终收益
            break
        end
    end
    
    %计算现值
    if (flag==1||flag==3) %如果在到期前转股，或者在赎回条款满足当天抛售 因为都是提前转股，只不过是被迫或者主动的区别，计算方法相同
       n=amount/exchangeprice(k-1); %计算转换的股数
       payoff=n*price(i,l)*(1-0.001)+fix(l/245+113/365)*amount*r2; %计算最后的总收入（股票扣除印花税，不扣所得税）
       pv(i)=payoff/(1+r1)^(l/245); 
    end
    if flag==0 %如果到最后一天都没有抛售
        n=amount/exchangeprice(k-1); 
        payoff=n*price(i,l)*(1-0.001)+fix(l/245+113/365)*amount*r2; %计算最后的总收入,各期的债券收入未分开计算现值
        pvx=payoff/(1+r1)^(l/245);
        pvy=amount*(1+3*r2)/(1+r1)^(3-113/365);
        pv(i)=max(pvx,pvy);
        E(i)=0;
    end
    if flag==2 %如果提前回售，则拿回3个利息加本息
        pv(i)=(amount*r2*(l/245)+amount)/(1+r1)^(l/245);
        E(i)=1;
    end
    flag=0; %将标志位复原
    j=2;
 end
 result=mean(pv);
 Sellback_Day=length(find(E==1));
 Finally_Day=length(find(E==0));
 Normal_Day=M-length(find(E==1))-length(find(E==0))-count;
Redemption_Day=count;  
end

