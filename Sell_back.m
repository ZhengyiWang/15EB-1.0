function flag = Sell_back( Dayrange,Duration,Exchangeprice,Price )
%�ڷ����˱��ڷ��еĿɽ���ծȯ����ǰ180���ڣ�
%�����Ĺ�Ʊ���κ�����15�������յ����̼۸���ڵ��ڻ��ɼ۵�80%ʱ��
%ծȯ��������Ȩ������еĿɽ���ծȯȫ���򲿷ְ���ֵ���ϵ���Ӧ����Ϣ�ļ۸���۸���˾�� 

%�ο�Exchaneprice������д����������15��ת������15������15������������

%�������壺 ExchangepriceΪ���ɼ۸�DayrangeΪ�ж������䣬��Ӧ��180��������
%DurationΪ��Ҫ�������������Ӧ15��������,priceΪ��Ʊ�۸����顣80%ֱ��д�뺯����

%��������������򷵻�2������������������򷵻�0

Length=length(Price);
count=0; %���ڼ�¼��������������
flag=0; %���ڱ���Ƿ���������

for i=Length-Dayrange:Duration
    if (Price(i)<Exchangeprice*0.8)
        count=count+1;
    end
end

if count==Duration
    flag=2;
    return;
end

for i=Duration+1:Length
    if (Price(i)<Exchangeprice*0.8)
        count=count+1;
    end
    if(Price(i-Duration)<Exchangeprice*0.8)
        count=count-1;
    end
    if count==Duration
        flag=2;
        break;
    end
end
end

