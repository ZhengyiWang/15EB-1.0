function [Sellday,flag] = Sell_back( Duration,Exchangeprice,Price,StartDay,Length )
%�ڷ����˱��ڷ��еĿɽ���ծȯ����ǰ180����
%�����Ĺ�Ʊ���κ�����15�������յ����̼۸���ڵ��ڻ��ɼ۵�80%ʱ��
%ծȯ��������Ȩ������еĿɽ���ծȯȫ���򲿷ְ���ֵ���ϵ���Ӧ����Ϣ�ļ۸���۸���˾�� 

%�ο�Exchaneprice������д����������15��ת������15������15������������

%�������壺 ExchangepriceΪ���ɼ۸�
%DurationΪ��Ҫ�������������Ӧ15�������գ�priceΪ��Ʊ�۸����顣80%ֱ��д�뺯����

%��������������򷵻����ڣ�����������������򷵻�EB������
flag=0;
count=0; %���ڼ�¼��������������

for Sellday=StartDay:min(StartDay+Duration-1,658) %��һ�ֵ͸��ʵ��߼����󣺺�15�����ޣ�ʵ�ʲ��ᷢ����������ܻᷢ�� 
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
