%Q，D,L这三个数组内的间距尽可能取的小一点（我写的作为一个参考，经验上比较好的取值)，result的结果单独用一个csv,excel，mat这种用于存储数据的格式保存。谢谢
%如果有时间，也帮我研究一下怎么取切片会比较美观，不像一个长方形。
D=[0:10:350]; %下修起始日期的 
Q=[1:0.05:1.5];%换股倍数 
L=[11.8:0.1:19.68]; %换股价格下限
result=[]; %估值结果
for i7=1:length(L)
    for j7=1:length(Q)
        for k7=1:length(D)
result(i7,j7,k7)=EB_Analyze(L(i7),Q(j7),D(k7));
        end
    end
end
[Q1,L1,D1]=meshgrid(Q,L,D);
colorbar;
slice(Q1,L1,D1,result,[1.17,1.35],[15,18],[50,350])
