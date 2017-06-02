function re = DandDk(ci,cj,ai,aj,isColor)

%   Eq. 11 And Eq. 12
t=1*10^(-6);
 a=(ci-cj)^2;
if isColor ==1
    a=a/(ai^2+aj^2+(1*10^(-10)));
elseif ai^2 > t
    a=a/ai^2;
else
    a=a/t;
end

re=a;

end

