function [finalday,flag] = Redemption( Exchangeprice,Dayrange,Duration,price,startday,Length)
%�������ڣ��������������ε�����һ�ֳ���ʱ����������Ȩ��������ծȯ��ֵ�ӵ���Ӧ����Ϣ�ļ۸����ȫ���򲿷�δ���ɵĿɽ���ծȯ��
%���ڻ������ڣ������Ĺ�Ʊ���κ�����30��������������15�������յ����̼۸񲻵��ڵ��ڻ��ɼ۸��130%����130%����
%�ڵ����ڿɽ���ծȯδ��������3,000��Ԫʱ��
%����Ӧ����Ϣ�ļ��㹫ʽΪ��IA=B��i��t/365  
%IA��ָ����Ӧ����Ϣ��B��ָ���ڿɽ���ծȯ�����˳��еĿɽ���ծȯƱ���ܽ�
%i��ָ�ɽ���ծȯ����Ʊ�����ʣ�t��ָ��Ϣ������������һ����Ϣ����������Ϣ��������ֹ��ʵ��������������ͷ����β����
%����ǰ��30���������ڷ��������ɼ۸���������Σ����ڵ���ǰ�Ľ����հ�����ǰ�Ļ��ɼ۸�����̼ۼ��㣬������Ľ����հ�������Ļ��ɼ۸�����̼ۼ��㡣 
%����3000��Ԫʱ�ڿ��Ǽ����¹��ʱ����Ҫ���ǡ�
%��Ҫ�������յĴ��������������finalday

%�������壺 ExchangepriceΪԭת�ɼ۸�DayrangeΪ�ж������䣬��Ӧ30��������
%DurationΪ��Ҫ�������������Ӧ15��������,priceΪ��Ʊ�۸�����
%Ϊ�˱���ʹ�����Ĳ������࣬���ֱ�ӽ�130%д�뺯����
%��������������򷵻�3������������������򷵻�0

finalday=startday;
flag=0;
count=0;

if Length<=Dayrange %����������޵�ʱ����С��30�죨�������Ϊǰ15��>1.3*exchangeprice,��10��<0.85exchangeprice��
    for finalday=startday:startday+Length-1 %�������ʱ��
        if(price(finalday)>=1.3*Exchangeprice)
            count=count+1;
        end
    if(count>=Duration)
        flag=3;
        return %����������������finalday
    end
    end
else  %����������޵�ʱ��������30��
    for finalday=startday:Dayrange+startday-1 %���ǰ30���Ƿ���������
        if(price(finalday)>=1.3*Exchangeprice)
            count=count+1;
        end
    end
    if(count>=Duration)
        flag=3;
        return;
    end

    for finalday=Dayrange+startday:Length+startday-1 %���ڶ���
        if(price(finalday)>=1.3*Exchangeprice)
            count=count+1;
        end
        if(price(finalday-Dayrange)>=1.3*Exchangeprice)%���ǰ31�����������򽫸ôμ������
            count=count-1;
        end
        if(count>=Duration)
            flag=3;
        return;
        end
    end
end
end

