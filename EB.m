miu=0.1891; %�껯������ 
sigma=0.4481; %�껯������
M=1000; %�������
day=658; %2016��3��31����2018��12��7�չ�678�������գ���һ��245�������ռ���,����2016��3��31�յ�2016��6��20�ջ�����ʼ�չ�51��������  
r1=0.065;%�ɽ���ծȯ�������ʣ���2016��3��31����Ϊ��׼�գ��������������ɽ�ծ����תծ���ʲ������������ȷ��
r2=0.045;%��ծȯ����
q=1.35; %���۵��컨�屶��������ʵ֤����ȷ��
price_floor=15; %���ɼ۸������
checkday=435;%��ʼ������޵���ʼ����
flag=0; %�����ж��Ƿ�������ۡ�ת�ɡ��������֮һ����ǰ����ѭ��
amount=600000000; %�����ܽ������Ԫ
firstprice=13.19; %2016��3��31�գ���׼�գ��ɼ�
exprice=19.69;%���ɼ۸�

price=zeros(M,day);%��������ռ�
price(:,1)=firstprice;%2016��3��31�չ�Ʊ��ʼ�۸�Ϊ13.10
pv=zeros(M,1); %�����洢��ֵ������
%���δ�ﵽ�컨�壬���ݲ�����ת�����ۣ��ں󣬣������ڣ�����գ����뵱��ת�ɣ���������������գ������ڵ�����Ȩ�����棬�����Ƿ񻻹ɡ������޸ģ�

j=2; %ʵ�����������ʼֵ 
E=[];%����һ�����ڼ�¼���л���ʱ���ɼ۸������ 0��ʾ������Ϊծȯ�ĵĽ�ֹ����,1��ʾ��ǰ���ۣ�2��ʾ�������ֹ������ת�ɣ��������ֱ�ʾ����ת�ɼ۸�
count=0; %������¼�������������ɻ��ɵĴ���
L=[];%������¼��������
 for i=1:M %����M��ʵ��
    while j<=day  %���ݼ��β����˶���ʽģ���Ʊ�۸񡣼���һ��245��������
        price(i,j)=price(i,j-1)*exp((miu-0.5*sigma^2)*(1/245)+sigma*(1/245)^0.5*normrnd(0,1));
        %����Ʊ�ĵ��յı䶯���ȿ�����-0.03%��0.16% Ƿ�ף������Ż�
        if price(i,j)>firstprice*exp(0.00160*j)||price(i,j)<firstprice*exp(-0.0003*j)
            j=j;
        else
            j=j+1;
        end
    end
    
    
    %��������������ѡһ
    %[exchangeprice,Exday] = Exchangeprice_Once(exprice,20,10,price(i,:),price_floor,checkday); %ֻ����һ��
    [exchangeprice,Exday] = Exchangeprice(exprice,20,10,price(i,:),price_floor,checkday);%���޶��
      %������������������D��ֻȡ��һ��ֵ��������������ļ��㷶Χ���̵���������ǰ�����������������D=678
      for k1=2:length(Exday) %���k1-1�� 
          [finalday1,flag1] = Redemption(exchangeprice(k1-1),30,15,price(i,:),Exday(k1-1),Exday(k1)-Exday(k1-1)+1);
          if flag1==3 %�������ĳ��������������ֹͣ��飬��¼���� 
              break;
          end
      end
      
%����������������
      tmp=find(Exday>(day-123));%�ҳ���123�������������޵������������е��±�
      Exday_tmp=day-123;%��ʼ�����ڼ��Ļ�����������
      Exprice_tmp=[];%���ڼ�¼�۸������
     for k2=1:length(tmp)
         Exday_tmp=[Exday_tmp,Exday(tmp(k2))];
         Exprice_tmp=[Exprice_tmp,exchangeprice(tmp(k2)-1)];
         end
    
     for k3=2:length(Exday_tmp) %���k3-1�� 
          [finalday2,flag2] = Sell_back(15,Exprice_tmp(k3-1),price(i,:),Exday_tmp(k3-1),Exday_tmp(k3)-Exday_tmp(k3-1)+1);
          if flag2==2 %�������ĳ��������������ֹͣ��飬��¼���� 
              break;
          end
     end
   
      
    %�ֶμ����D֮ǰ�Ƿ����ĳ�յĹɼ��Ƿ�����ĳ��������������ת��
    for k=2:length(Exday) %���k-1��
        for l= Exday(k-1):Exday(k)-1 %���ÿһ�ε�ÿһ���Ƿ�������أ�flag=3��������(flag=2)�Լ�ת��(flag=1)��������l������¼�ɽ�������%ʱ����ǰ����ǰ��һ�죨�޸ģ���
            if l<=finalday1 %�����ж��Ƿ�δ�������׷�Χ
                if(price(i,l)>=q*exchangeprice(k-1)) %��������жϵ���ļ۸��Ƿ񳬹����õı���
                    flag=1; %�������q*exchangeprice�򽫱�־λ��Ϊ1
                    E(i)=exchangeprice(k-1);%�����ճɽ��Ļ��ɼ۸��¼������
                    break; %������ѭ��
                end
              if flag2==2 %��������������
                  if l==finalday2 %������շ��������˻������������֮ǰû��ת�ɻ�������������أ���ѡ����ۣ�����ѭ��
                      flag=2;
                      break;
                  end
              end
            else %�������������ڵ��첻ִ��������Ͷ��������������ǰ��ɻ��� %���������Ӧ�û�ѡ��ת��������������
                l=finalday1;
                E(i)=exchangeprice(k-1);%�����յĳɽ����ɼ۸��¼��������ȥ �Ƿ�Ӧ�÷�����ؼ۸���ǻ��ɼ۸�
                flag=3;
                count=count+1;
                if l==day %���һ����ɽ���,��Ҫ��������
                    flag=0;
                    count=count-1;
                end
                break;
            end    
        end
        if (flag==1||flag==2||flag==3);%���������ۡ�����Լ����������е�����һ���ֹͣ�����һ�Σ���ʼ������������
            break
        end
    end
    
    %������ֵ����������ֵ˰�������ǻ����Ͷ����ģʽ������Ͷ����Ϊ�ϻ������ҵ����ӡ��˰������˰�ճﻮԭ�򣬲���������˰
    if (flag==1||flag==3) %����ڵ���ǰת�ɣ�����������������㵱������ ��Ϊ������ǰת�ɣ�ֻ�����Ǳ��Ȼ������������𣬼��㷽����ͬ
        L=[L,l];
       share_number=amount/exchangeprice(k-1); %����ת���Ĺ���
        if l<166
            pv(i)=(share_number*price(i,l)*(1-0.001)-(share_number*price(i,l)-amount)/1.06*0.06) /(1+r1)^(l/245); 
        elseif l>=166&&l<411
           pv(i)=(share_number*price(i,l)*(1-0.001)-(share_number*price(i,l)-amount)/1.06*0.06) /(1+r1)^(l/245)+amount*r2/1.06/(1+r1)^(166/245);
        else
            pv(i)=(share_number*price(i,l)*(1-0.001)-(share_number*price(i,l)-amount)/1.06*0.06) /(1+r1)^(l/245)+amount*r2/1.06/(1+r1)^(166/245)+amount*r2/1.06/(1+r1)^(411/245); 
        end
    end
    if flag==0 %��������һ�춼û������
        share_number=amount/exchangeprice(k-1); 
        pvx=(share_number*price(i,l)*(1-0.001)-(share_number*price(i,l)-amount)/1.06*0.06) /(1+r1)^(658/245)+amount*r2/1.06/(1+r1)^(166/245)+amount*r2/1.06/(1+r1)^(411/245); 
        %��������������,���ڵ�ծȯ����ֿ�������ֵ
        pvy=amount/(1+r1)^(658/245)+amount*r2/1.06/(1+r1)^(166/245)+amount*r2/1.06/(1+r1)^(411/245) +amount*r2/1.06/(1+r1)^(658/245);
        pv(i)=max(pvx,pvy);
        E(i)=0;
    end
    if flag==2 %�����ǰ���ۣ����û�3����Ϣ�ӱ�Ϣ
        pv(i)=amount/(1+r1)^(l/245)+amount*r2/1.06/(1+r1)^(166/245)+amount*r2/1.06/(1+r1)^(411/245)+amount*r2*(l-411)/245/1.06/(1+r1)^(l/245);
        E(i)=1;
    end
    flag=0; %����־λ��ԭ
    j=2;
 end
 result=mean(pv)
 
 %����ͳ��
 fprintf('�������۵Ĵ���Ϊ%d\n',length(find(E==1)))
 fprintf('���һ�콻�׵Ĵ���Ϊ%d\n',length(find(E==0)))
 fprintf('����ת�ɵĴ���Ϊ%d\n',M-length(find(E==1))-length(find(E==0))-count)
 fprintf('���������������ڵ��챻��ת�ɵĴ���Ϊ%d\n',count)
 %���������