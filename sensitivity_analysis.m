D=[0,175,350]; %下修起始日期的所有取值 
Q=[1,1.17,1.35];%换股倍数
L=[11.8,15,19.68]; %换股价格下限
S_D=[];%用来记录回售的次数
N_D=[];%用来记录正常的次数
R_D=[];%用来记录赎回的次数
F_D=[]; %最后一日的次数
Result=[];%估值结果
for i7=1:length(L)
    for j7=1:length(Q)
        for k7=1:length(D)
[result,S_Day,F_Day,N_Day,R_Day]=EB_Analyze(L(i7),Q(j7),D(k7));%变化顺序：D的所有值->Q的所有值->S的所有值，和表格顺序相同
S_D=[S_D,S_Day];
N_D=[N_D,N_Day];
R_D=[R_D,R_Day];
Result=[Result,result];
F_D=[F_D,F_Day];
        end
    end
end
S_D=S_D';%转制，行向量变列向量
N_D=N_D';
R_D=R_D';
Result=Result';