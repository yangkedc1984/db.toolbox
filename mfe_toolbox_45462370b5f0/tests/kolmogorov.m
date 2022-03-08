function [stat,pval,H]=kolmogorov(x,alpha,dist,varargin)
% Performs a Kolmogorov-Smirnov test that the data are from a specified distribution
%
% USAGE:
%   [STAT,PVAL,H] = kolmogorov(X,ALPHA,DIST,VARARGIN)
%
%
% INPUTS:
%   X        -  A set of random variable to be tested for distributional correctness
%   ALPHA    -  [OPTIONAL] The size for the test or use for computing H.  0.05 if not entered or
%                 empty.
%   DIST     -  [OPTIONAL] A char string of the name of the CDF, i.e. 'normcdf' for the normal,
%                 'stdtcdf' for standardized Student's T, etc.  If not provided or empty, data are
%                 assumed to have a uniform distribution (i.e. that data have already been fed
%                 through a probability integral transform)   
%   VARARGIN -  [OPTIONAL] Arguments passed to the CDF, such as the mean and variance for a normal
%                 or a d.f. for T.  The VARARGIN should be such that DIST(X,VARARGIN) is a valid
%                 function with the correct inputs.  
%
% OUTPUTS:
%   STAT     - The KS statistic 
%   PVAL     - The asymptotic probability of significance
%   H        - 1 for reject the null that the distribution is correct, using the size provided (or
%                .05 if not), 0 otherwise 
%
% EXAMPLES:
% Test data for uniformity
%     stat = kolmogorov(x);
% Test standard normal data 
%     [stat,pval] = kolmogorov(x,[],'normcdf');
% Test normal mean 1, standard deviation 2 data 
%     [stat,pval] = kolmogorov(x,[],'normcdf',1,2);
%
% COMMENTS:
%
% See also BERKOWITZ

%%%%%%%%%%%%%%%%%%%
% PARAMETER CHECK
%%%%%%%%%%%%%%%%%%%
switch nargin
    case 1
        alpha=.05;
        dist=[];
        varargin=[];
    case 2
        dist=[];
        varargin=[];
    case 3
        varargin=[];
    case 0
        error('1 or more inputs required.')
end
if isempty(alpha)
    alpha=.05;
end
if min(size(x))~=1 || ndims(x)~=2
    error('X must be a column vector of data')
end
if size(x,2)~=1
    x=x';    
end

if isempty(dist)
    if any(x>=1) || any(x<=0)
        error('If DIST is not input, X must satisfy 0<X<1')
    end
else
    if ~ischar(dist)
        error('DIST much be a character string')
    end
end
if ~isscalar(alpha) || alpha<=0 || alpha>=1
    error('ALPHA must be a scalar between 0 and 1')
end
%%%%%%%%%%%%%%%%%%%
% PARAMETER CHECK
%%%%%%%%%%%%%%%%%%%


x=sort(x);
if ~isempty(dist)
    try
        if isempty(varargin)
            cdfvals=feval(dist,x);
        else
            cdfvals=feval(dist,x,varargin{:});
        end
    catch ME
        error('There was an error calling the DIST function with the VARARGIN provided.')
    end
else
    cdfvals=x;
end
n=length(x);
S=(1:n)'/(n+1);
alpha=alpha/2;

d=max(abs(cdfvals-S));
stat=d;
crit=kscritical(n,alpha);
H=stat>crit;

k = (n^(0.5) + 0.12 + 0.11/n^(0.5))*stat ;
tol=1;
pval=2*exp(-2*k*k);
s=-1;
i=2;
while tol >1e-10
    old=pval;
    pval=pval+2*s/exp(2*k*k*i*i);
    i=i+1;
    s=s*(-1);
    tol=abs(pval-old);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function crit=kscritical(n,pvalue)
% This is a helper function for kolmorgorov that returns the appropriate critical value.
% Uses a table from (1956) and asymptotic values Miller (1956) JASA


if n<=100
    alpha=[.1 .05 .025 .01 .005];
    lookuptable= ...
        [0.9000    0.9500    0.9750    0.9900    0.9950
        0.6838    0.7764    0.8419    0.9000    0.9293
        0.5648    0.6360    0.7076    0.7846    0.8290
        0.4926    0.5652    0.6239    0.6889    0.7342
        0.4470    0.5094    0.5633    0.6272    0.6685
        0.4104    0.4680    0.5193    0.5774    0.6166
        0.3815    0.4361    0.4834    0.5384    0.5758
        0.3583    0.4096    0.4543    0.5065    0.5418
        0.3391    0.3875    0.4300    0.4796    0.5133
        0.3226    0.3687    0.4093    0.4566    0.4889
        0.3083    0.3524    0.3912    0.4367    0.4677
        0.2958    0.3382    0.3754    0.4192    0.4491
        0.2847    0.3255    0.3614    0.4036    0.4325
        0.2748    0.3142    0.3489    0.3897    0.4176
        0.2659    0.3040    0.3376    0.3771    0.4042
        0.2578    0.2947    0.3273    0.3657    0.3920
        0.2504    0.2863    0.3180    0.3553    0.3809
        0.2436    0.2785    0.3094    0.3457    0.3706
        0.2374    0.2714    0.3014    0.3368    0.3612
        0.2316    0.2647    0.2941    0.3287    0.3524
        0.2262    0.2586    0.2872    0.3210    0.3443
        0.2212    0.2528    0.2809    0.3139    0.3367
        0.2165    0.2475    0.2749    0.3073    0.3295
        0.2120    0.2424    0.2693    0.3010    0.3229
        0.2079    0.2377    0.2640    0.2952    0.3166
        0.2040    0.2332    0.2591    0.2896    0.3106
        0.2003    0.2290    0.2544    0.2844    0.3050
        0.1968    0.2250    0.2499    0.2794    0.2997
        0.1935    0.2212    0.2457    0.2747    0.2947
        0.1903    0.2176    0.2417    0.2702    0.2899
        0.1873    0.2141    0.2379    0.2660    0.2853
        0.1845    0.2109    0.2342    0.2619    0.2809
        0.1817    0.2077    0.2308    0.2580    0.2768
        0.1791    0.2047    0.2274    0.2543    0.2728
        0.1766    0.2019    0.2243    0.2507    0.2690
        0.1742    0.1991    0.2212    0.2473    0.2653
        0.1719    0.1965    0.2183    0.2440    0.2618
        0.1697    0.1939    0.2154    0.2409    0.2584
        0.1675    0.1915    0.2127    0.2379    0.2552
        0.1655    0.1891    0.2101    0.2349    0.2521
        0.1635    0.1869    0.2076    0.2321    0.2490
        0.1616    0.1847    0.2052    0.2294    0.2461
        0.1597    0.1826    0.2028    0.2268    0.2433
        0.1580    0.1805    0.2006    0.2243    0.2406
        0.1562    0.1786    0.1984    0.2218    0.2380
        0.1546    0.1767    0.1963    0.2194    0.2354
        0.1530    0.1748    0.1942    0.2172    0.2330
        0.1514    0.1730    0.1922    0.2149    0.2306
        0.1499    0.1713    0.1903    0.2128    0.2283
        0.1484    0.1696    0.1884    0.2107    0.2260
        0.1470    0.1680    0.1866    0.2086    0.2239
        0.1456    0.1664    0.1848    0.2067    0.2217
        0.1442    0.1648    0.1831    0.2047    0.2197
        0.1429    0.1633    0.1814    0.2029    0.2177
        0.1416    0.1619    0.1798    0.2011    0.2157
        0.1404    0.1604    0.1782    0.1993    0.2138
        0.1392    0.1591    0.1767    0.1976    0.2120
        0.1380    0.1577    0.1752    0.1959    0.2102
        0.1369    0.1564    0.1737    0.1943    0.2084
        0.1357    0.1551    0.1723    0.1927    0.2067
        0.1346    0.1538    0.1709    0.1911    0.2051
        0.1336    0.1526    0.1696    0.1896    0.2034
        0.1325    0.1514    0.1682    0.1881    0.2018
        0.1315    0.1503    0.1669    0.1867    0.2003
        0.1305    0.1491    0.1657    0.1853    0.1988
        0.1295    0.1480    0.1644    0.1839    0.1973
        0.1286    0.1469    0.1632    0.1825    0.1958
        0.1277    0.1459    0.1620    0.1812    0.1944
        0.1268    0.1448    0.1609    0.1799    0.1930
        0.1259    0.1438    0.1598    0.1786    0.1917
        0.1250    0.1428    0.1586    0.1774    0.1903
        0.1241    0.1418    0.1576    0.1762    0.1890
        0.1233    0.1409    0.1565    0.1750    0.1878
        0.1225    0.1399    0.1554    0.1738    0.1865
        0.1217    0.1390    0.1544    0.1727    0.1853
        0.1209    0.1381    0.1534    0.1716    0.1841
        0.1201    0.1372    0.1524    0.1704    0.1829
        0.1194    0.1364    0.1515    0.1694    0.1817
        0.1186    0.1355    0.1505    0.1683    0.1806
        0.1179    0.1347    0.1496    0.1673    0.1795
        0.1172    0.1339    0.1487    0.1663    0.1784
        0.1165    0.1331    0.1478    0.1653    0.1773
        0.1158    0.1323    0.1469    0.1643    0.1763
        0.1151    0.1315    0.1461    0.1633    0.1752
        0.1144    0.1307    0.1452    0.1624    0.1742
        0.1138    0.1300    0.1444    0.1614    0.1732
        0.1131    0.1292    0.1436    0.1605    0.1722
        0.1125    0.1285    0.1427    0.1596    0.1713
        0.1119    0.1278    0.1419    0.1587    0.1703
        0.1113    0.1271    0.1412    0.1579    0.1694
        0.1106    0.1264    0.1404    0.1570    0.1685
        0.1101    0.1257    0.1397    0.1562    0.1676
        0.1095    0.1251    0.1389    0.1553    0.1667
        0.1089    0.1244    0.1382    0.1545    0.1658
        0.1083    0.1238    0.1375    0.1537    0.1649
        0.1078    0.1231    0.1368    0.1529    0.1641
        0.1072    0.1225    0.1361    0.1521    0.1632
        0.1067    0.1219    0.1354    0.1514    0.1624
        0.1061    0.1213    0.1347    0.1506    0.1616
        0.1056    0.1207    0.1340    0.1499    0.1608];
    
    crit=interp1(alpha,lookuptable(n,:),pvalue);
else
    A=0.09037*((-1*log10(pvalue)))^(3/2) + 0.01515*(log10(pvalue))^(2) - .08467*pvalue - .11143;
    crit= sqrt(log(1/pvalue)/(2*n))- .16693/n - A*n^(-3/2);
end
