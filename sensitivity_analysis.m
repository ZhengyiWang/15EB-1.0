D=[0,175,350]; %������ʼ���ڵ�����ȡֵ 
Q=[1,1.17,1.35];%���ɱ���
L=[11.8,15,19.68]; %���ɼ۸�����
S_D=[];%������¼���۵Ĵ���
N_D=[];%������¼�����Ĵ���
R_D=[];%������¼��صĴ���
F_D=[]; %���һ�յĴ���
Result=[];%��ֵ���
for i7=1:length(L)
    for j7=1:length(Q)
        for k7=1:length(D)
[result,S_Day,F_Day,N_Day,R_Day]=EB_Analyze(L(i7),Q(j7),D(k7));%�仯˳��D������ֵ->Q������ֵ->S������ֵ���ͱ��˳����ͬ
S_D=[S_D,S_Day];
N_D=[N_D,N_Day];
R_D=[R_D,R_Day];
Result=[Result,result];
F_D=[F_D,F_Day];
        end
    end
end
S_D=S_D';%ת�ƣ���������������
N_D=N_D';
R_D=R_D';
Result=Result';