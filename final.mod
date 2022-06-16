param n ,integer,>0;
param fn;
set F;
set FO;
set M;
set N  := 0..n-1;
set NO;
set E,within N cross N;
param s{f in F};
param D{l in M ,f in F};
param d{f in F};
param c{(i,j)in E};
param AB;
param ReqCpus{fo in FO};
param ReqMems{fo in FO};
param L{i in F};
var x{(i,j)in E, f in F},binary;
var y{i in N,l in M,f in F};
param NodeCpus{i in NO};
param NodeMems{i in NO};
param b{i in N , l in M};
minimize coast : sum{f in F, i in N , j in N} c[i,j]*L[f]*x[i,j,f] 
                 + sum{f in F , i in N , l in M} L[f]*y[i,l,f]
;
#  C1: The path from source to destination should be connected. 
s.t. C1{i in N , f in F} : sum{j in N}x[j,i,f]+ (if i == s[f] then 1)
							= sum{r in N} x[i ,r,f] + ( if i == d[f] then 1);
#  C2: The path should not include any loop.
s.t. C21{j in N , f in F}: sum{i in M}x[i,j,f]<=1;
s.t. C22{i in N , f in F}: sum{j in M}x[i ,j,f]<=1;
# C3: Limited Bandwidth in links
s.t. C3{i in N , j in N}:sum{f in F}L[f]*x[i ,j,f]<= AB;
#  C4: The requested resources (vCPU, Mem) in each node should be 
# less than the available resources.
s.t. C41{i in NO, l in M, fo in FO}:sum{f in F}y[i,l,f]*ReqCpus[fo] <= NodeCpus[i];
s.t. C42{i in NO, l in M, fo in FO}:sum{f in F}y[i,l,f]*ReqMems[fo] <= NodeMems[i];
# C5: vNF for each flow should be instantiated in a path the flow is 
# traveling.
s.t. C5{i in N ,l in M , f in F}: sum{j in N} x[i,j,f]-y[i,l,f]>=0;

# C6: The number of vNF placements should be the same as requested 
# vNFs
s.t. C6{l in M , f in F}:sum{i in N}y[i,l,f] = D[l , f];
solve;


data;
# set FLOW_P :=  S D RB VNF1 VNF2 VNF3;
set F:= G1FLOW1 G1FLOW2;
set M:= 1;
# 1. The number of network nodes
param n:= 36;
set FO:= vNF1 vNF2 vNF3;
# 2. Available bandwidth in each link
param AB:=8;

# 3. The number of flows
param fn:=2;

# 4. The number of requested vNF for each flow
param D:
	G1FLOW1 G1FLOW2:=
1 	2		2
;
# 5. The requested bandwidth for each flow
param L:=
G1FLOW1 6
G1FLOW2 3
;
# 6. The source and destination nodes for each flow
param s:=

G1FLOW1  0
G1FLOW2  3
;
param d:=
G1FLOW1  10
G1FLOW2  14
;
# 7. The number of required vCPU for each vNF
param ReqCpus:=
vNF1 2
vNF2 1
vNF3 3
;

# 8. The number of required vMEM for each vNF
param ReqMems:=
vNF1 1
vNF2 2
vNF3 3
;
set NO:= 0 1 2 3 4 5 6 7 8 9 10
			11 12 13 14 15 16 17 18 19 20
			21 22 23 24 25 26 27 28 29 30
			31 32 33 34 35;
# 9. The number of available vCPU in each node
param NodeCpus :=
	0	4
	1	7
	2	9
	3	4
	4	4
	5	5
	6	3
	7	7
	8	5
	9	3
	10	5
	11	4
	12	6
	13	6
	14	5
	15	4
	16	4
	17	8
	18	2
	19	9
	20	7
	21	6
	22	3
	23	2
	24	2
	25	6
	26	6
	27	4
	28	7
	29	9
	30	2
	31	4
	32	8
	33	5
	34	3
	35	7
;
# 10. The number of available vMEM in each node
param NodeMems:=
0		4
1		3
2		2
3		5
4		4
5		5
6		3
7		2
8		3
9		3
10		5
11		4
12		5
13		6
14		6
15		7
16		4
17		4
18		9
19		8
20		9
21		9
22		2
23		7
24		9
25		3
26		3
27		2
28		5
29		6
30		4
31		7
32		3
33		3
34		4
35		2
;



param :E:c:=
0 0 3.0E-6
0 1 3.0E-6
0 2 3.0E-6
0 3 3.0E-6
0 4 3.0E-6
0 5 3.0E-6
0 6 3.0E-6
0 7 3.0E-6
0 8 3.0E-6
0 9 3.0E-6
0 10 3.0E-6
0 11 3.0E-6
0 12 3.0E-6
0 13 3.0E-6
0 14 3.0E-6
0 15 3.0E-6
0 16 78.0
0 17 3.0E-6
0 18 3.0E-6
0 19 3.0E-6
0 20 3.0E-6
0 21 3.0E-6
0 22 3.0E-6
0 23 3.0E-6
0 24 3.0E-6
0 25 3.0E-6
0 26 3.0E-6
0 27 3.0E-6
0 28 3.0E-6
0 29 3.0E-6
0 30 3.0E-6
0 31 3.0E-6
0 32 3.0E-6
0 33 3.0E-6
0 34 3.0E-6
0 35 3.0E-6
1 0 3.0E-6
1 1 3.0E-6
1 2 3.0E-6
1 3 3.0E-6
1 4 3.0E-6
1 5 3.0E-6
1 6 3.0E-6
1 7 3.0E-6
1 8 3.0E-6
1 9 3.0E-6
1 10 3.0E-6
1 11 3.0E-6
1 12 3.0E-6
1 13 3.0E-6
1 14 3.0E-6
1 15 3.0E-6
1 16 64.0
1 17 3.0E-6
1 18 3.0E-6
1 19 3.0E-6
1 20 3.0E-6
1 21 3.0E-6
1 22 3.0E-6
1 23 3.0E-6
1 24 3.0E-6
1 25 3.0E-6
1 26 3.0E-6
1 27 3.0E-6
1 28 3.0E-6
1 29 3.0E-6
1 30 3.0E-6
1 31 3.0E-6
1 32 3.0E-6
1 33 3.0E-6
1 34 3.0E-6
1 35 3.0E-6
2 0 3.0E-6
2 1 3.0E-6
2 2 3.0E-6
2 3 3.0E-6
2 4 3.0E-6
2 5 3.0E-6
2 6 3.0E-6
2 7 3.0E-6
2 8 3.0E-6
2 9 3.0E-6
2 10 3.0E-6
2 11 3.0E-6
2 12 3.0E-6
2 13 3.0E-6
2 14 3.0E-6
2 15 3.0E-6
2 16 3.0E-6
2 17 25.0
2 18 3.0E-6
2 19 3.0E-6
2 20 3.0E-6
2 21 3.0E-6
2 22 3.0E-6
2 23 3.0E-6
2 24 3.0E-6
2 25 3.0E-6
2 26 3.0E-6
2 27 3.0E-6
2 28 3.0E-6
2 29 3.0E-6
2 30 3.0E-6
2 31 3.0E-6
2 32 3.0E-6
2 33 3.0E-6
2 34 3.0E-6
2 35 3.0E-6
3 0 3.0E-6
3 1 3.0E-6
3 2 3.0E-6
3 3 3.0E-6
3 4 3.0E-6
3 5 3.0E-6
3 6 3.0E-6
3 7 3.0E-6
3 8 3.0E-6
3 9 3.0E-6
3 10 3.0E-6
3 11 3.0E-6
3 12 3.0E-6
3 13 3.0E-6
3 14 3.0E-6
3 15 3.0E-6
3 16 3.0E-6
3 17 84.0
3 18 3.0E-6
3 19 3.0E-6
3 20 3.0E-6
3 21 3.0E-6
3 22 3.0E-6
3 23 3.0E-6
3 24 3.0E-6
3 25 3.0E-6
3 26 3.0E-6
3 27 3.0E-6
3 28 3.0E-6
3 29 3.0E-6
3 30 3.0E-6
3 31 3.0E-6
3 32 3.0E-6
3 33 3.0E-6
3 34 3.0E-6
3 35 3.0E-6
4 0 3.0E-6
4 1 3.0E-6
4 2 3.0E-6
4 3 3.0E-6
4 4 3.0E-6
4 5 3.0E-6
4 6 3.0E-6
4 7 3.0E-6
4 8 3.0E-6
4 9 3.0E-6
4 10 3.0E-6
4 11 3.0E-6
4 12 3.0E-6
4 13 3.0E-6
4 14 3.0E-6
4 15 3.0E-6
4 16 3.0E-6
4 17 3.0E-6
4 18 25.0
4 19 3.0E-6
4 20 3.0E-6
4 21 3.0E-6
4 22 3.0E-6
4 23 3.0E-6
4 24 3.0E-6
4 25 3.0E-6
4 26 3.0E-6
4 27 3.0E-6
4 28 3.0E-6
4 29 3.0E-6
4 30 3.0E-6
4 31 3.0E-6
4 32 3.0E-6
4 33 3.0E-6
4 34 3.0E-6
4 35 3.0E-6
5 0 3.0E-6
5 1 3.0E-6
5 2 3.0E-6
5 3 3.0E-6
5 4 3.0E-6
5 5 3.0E-6
5 6 3.0E-6
5 7 3.0E-6
5 8 3.0E-6
5 9 3.0E-6
5 10 3.0E-6
5 11 3.0E-6
5 12 3.0E-6
5 13 3.0E-6
5 14 3.0E-6
5 15 3.0E-6
5 16 3.0E-6
5 17 3.0E-6
5 18 66.0
5 19 3.0E-6
5 20 3.0E-6
5 21 3.0E-6
5 22 3.0E-6
5 23 3.0E-6
5 24 3.0E-6
5 25 3.0E-6
5 26 3.0E-6
5 27 3.0E-6
5 28 3.0E-6
5 29 3.0E-6
5 30 3.0E-6
5 31 3.0E-6
5 32 3.0E-6
5 33 3.0E-6
5 34 3.0E-6
5 35 3.0E-6
6 0 3.0E-6
6 1 3.0E-6
6 2 3.0E-6
6 3 3.0E-6
6 4 3.0E-6
6 5 3.0E-6
6 6 3.0E-6
6 7 3.0E-6
6 8 3.0E-6
6 9 3.0E-6
6 10 3.0E-6
6 11 3.0E-6
6 12 3.0E-6
6 13 3.0E-6
6 14 3.0E-6
6 15 3.0E-6
6 16 3.0E-6
6 17 3.0E-6
6 18 3.0E-6
6 19 81.0
6 20 3.0E-6
6 21 3.0E-6
6 22 3.0E-6
6 23 3.0E-6
6 24 3.0E-6
6 25 3.0E-6
6 26 3.0E-6
6 27 3.0E-6
6 28 3.0E-6
6 29 3.0E-6
6 30 3.0E-6
6 31 3.0E-6
6 32 3.0E-6
6 33 3.0E-6
6 34 3.0E-6
6 35 3.0E-6
7 0 3.0E-6
7 1 3.0E-6
7 2 3.0E-6
7 3 3.0E-6
7 4 3.0E-6
7 5 3.0E-6
7 6 3.0E-6
7 7 3.0E-6
7 8 3.0E-6
7 9 3.0E-6
7 10 3.0E-6
7 11 3.0E-6
7 12 3.0E-6
7 13 3.0E-6
7 14 3.0E-6
7 15 3.0E-6
7 16 3.0E-6
7 17 3.0E-6
7 18 3.0E-6
7 19 66.0
7 20 3.0E-6
7 21 3.0E-6
7 22 3.0E-6
7 23 3.0E-6
7 24 3.0E-6
7 25 3.0E-6
7 26 3.0E-6
7 27 3.0E-6
7 28 3.0E-6
7 29 3.0E-6
7 30 3.0E-6
7 31 3.0E-6
7 32 3.0E-6
7 33 3.0E-6
7 34 3.0E-6
7 35 3.0E-6
8 0 3.0E-6
8 1 3.0E-6
8 2 3.0E-6
8 3 3.0E-6
8 4 3.0E-6
8 5 3.0E-6
8 6 3.0E-6
8 7 3.0E-6
8 8 3.0E-6
8 9 3.0E-6
8 10 3.0E-6
8 11 3.0E-6
8 12 3.0E-6
8 13 3.0E-6
8 14 3.0E-6
8 15 3.0E-6
8 16 3.0E-6
8 17 3.0E-6
8 18 3.0E-6
8 19 3.0E-6
8 20 38.0
8 21 3.0E-6
8 22 3.0E-6
8 23 3.0E-6
8 24 3.0E-6
8 25 3.0E-6
8 26 3.0E-6
8 27 3.0E-6
8 28 3.0E-6
8 29 3.0E-6
8 30 3.0E-6
8 31 3.0E-6
8 32 3.0E-6
8 33 3.0E-6
8 34 3.0E-6
8 35 3.0E-6
9 0 3.0E-6
9 1 3.0E-6
9 2 3.0E-6
9 3 3.0E-6
9 4 3.0E-6
9 5 3.0E-6
9 6 3.0E-6
9 7 3.0E-6
9 8 3.0E-6
9 9 3.0E-6
9 10 3.0E-6
9 11 3.0E-6
9 12 3.0E-6
9 13 3.0E-6
9 14 3.0E-6
9 15 3.0E-6
9 16 3.0E-6
9 17 3.0E-6
9 18 3.0E-6
9 19 3.0E-6
9 20 88.0
9 21 3.0E-6
9 22 3.0E-6
9 23 3.0E-6
9 24 3.0E-6
9 25 3.0E-6
9 26 3.0E-6
9 27 3.0E-6
9 28 3.0E-6
9 29 3.0E-6
9 30 3.0E-6
9 31 3.0E-6
9 32 3.0E-6
9 33 3.0E-6
9 34 3.0E-6
9 35 3.0E-6
10 0 3.0E-6
10 1 3.0E-6
10 2 3.0E-6
10 3 3.0E-6
10 4 3.0E-6
10 5 3.0E-6
10 6 3.0E-6
10 7 3.0E-6
10 8 3.0E-6
10 9 3.0E-6
10 10 3.0E-6
10 11 3.0E-6
10 12 3.0E-6
10 13 3.0E-6
10 14 3.0E-6
10 15 3.0E-6
10 16 3.0E-6
10 17 3.0E-6
10 18 3.0E-6
10 19 3.0E-6
10 20 3.0E-6
10 21 72.0
10 22 3.0E-6
10 23 3.0E-6
10 24 3.0E-6
10 25 3.0E-6
10 26 3.0E-6
10 27 3.0E-6
10 28 3.0E-6
10 29 3.0E-6
10 30 3.0E-6
10 31 3.0E-6
10 32 3.0E-6
10 33 3.0E-6
10 34 3.0E-6
10 35 3.0E-6
11 0 3.0E-6
11 1 3.0E-6
11 2 3.0E-6
11 3 3.0E-6
11 4 3.0E-6
11 5 3.0E-6
11 6 3.0E-6
11 7 3.0E-6
11 8 3.0E-6
11 9 3.0E-6
11 10 3.0E-6
11 11 3.0E-6
11 12 3.0E-6
11 13 3.0E-6
11 14 3.0E-6
11 15 3.0E-6
11 16 3.0E-6
11 17 3.0E-6
11 18 3.0E-6
11 19 3.0E-6
11 20 3.0E-6
11 21 48.0
11 22 3.0E-6
11 23 3.0E-6
11 24 3.0E-6
11 25 3.0E-6
11 26 3.0E-6
11 27 3.0E-6
11 28 3.0E-6
11 29 3.0E-6
11 30 3.0E-6
11 31 3.0E-6
11 32 3.0E-6
11 33 3.0E-6
11 34 3.0E-6
11 35 3.0E-6
12 0 3.0E-6
12 1 3.0E-6
12 2 3.0E-6
12 3 3.0E-6
12 4 3.0E-6
12 5 3.0E-6
12 6 3.0E-6
12 7 3.0E-6
12 8 3.0E-6
12 9 3.0E-6
12 10 3.0E-6
12 11 3.0E-6
12 12 3.0E-6
12 13 3.0E-6
12 14 3.0E-6
12 15 3.0E-6
12 16 3.0E-6
12 17 3.0E-6
12 18 3.0E-6
12 19 3.0E-6
12 20 3.0E-6
12 21 3.0E-6
12 22 84.0
12 23 3.0E-6
12 24 3.0E-6
12 25 3.0E-6
12 26 3.0E-6
12 27 3.0E-6
12 28 3.0E-6
12 29 3.0E-6
12 30 3.0E-6
12 31 3.0E-6
12 32 3.0E-6
12 33 3.0E-6
12 34 3.0E-6
12 35 3.0E-6
13 0 3.0E-6
13 1 3.0E-6
13 2 3.0E-6
13 3 3.0E-6
13 4 3.0E-6
13 5 3.0E-6
13 6 3.0E-6
13 7 3.0E-6
13 8 3.0E-6
13 9 3.0E-6
13 10 3.0E-6
13 11 3.0E-6
13 12 3.0E-6
13 13 3.0E-6
13 14 3.0E-6
13 15 3.0E-6
13 16 3.0E-6
13 17 3.0E-6
13 18 3.0E-6
13 19 3.0E-6
13 20 3.0E-6
13 21 3.0E-6
13 22 25.0
13 23 3.0E-6
13 24 3.0E-6
13 25 3.0E-6
13 26 3.0E-6
13 27 3.0E-6
13 28 3.0E-6
13 29 3.0E-6
13 30 3.0E-6
13 31 3.0E-6
13 32 3.0E-6
13 33 3.0E-6
13 34 3.0E-6
13 35 3.0E-6
14 0 3.0E-6
14 1 3.0E-6
14 2 3.0E-6
14 3 3.0E-6
14 4 3.0E-6
14 5 3.0E-6
14 6 3.0E-6
14 7 3.0E-6
14 8 3.0E-6
14 9 3.0E-6
14 10 3.0E-6
14 11 3.0E-6
14 12 3.0E-6
14 13 3.0E-6
14 14 3.0E-6
14 15 3.0E-6
14 16 3.0E-6
14 17 3.0E-6
14 18 3.0E-6
14 19 3.0E-6
14 20 3.0E-6
14 21 3.0E-6
14 22 3.0E-6
14 23 22.0
14 24 3.0E-6
14 25 3.0E-6
14 26 3.0E-6
14 27 3.0E-6
14 28 3.0E-6
14 29 3.0E-6
14 30 3.0E-6
14 31 3.0E-6
14 32 3.0E-6
14 33 3.0E-6
14 34 3.0E-6
14 35 3.0E-6
15 0 3.0E-6
15 1 3.0E-6
15 2 3.0E-6
15 3 3.0E-6
15 4 3.0E-6
15 5 3.0E-6
15 6 3.0E-6
15 7 3.0E-6
15 8 3.0E-6
15 9 3.0E-6
15 10 3.0E-6
15 11 3.0E-6
15 12 3.0E-6
15 13 3.0E-6
15 14 3.0E-6
15 15 3.0E-6
15 16 3.0E-6
15 17 3.0E-6
15 18 3.0E-6
15 19 3.0E-6
15 20 3.0E-6
15 21 3.0E-6
15 22 3.0E-6
15 23 52.0
15 24 3.0E-6
15 25 3.0E-6
15 26 3.0E-6
15 27 3.0E-6
15 28 3.0E-6
15 29 3.0E-6
15 30 3.0E-6
15 31 3.0E-6
15 32 3.0E-6
15 33 3.0E-6
15 34 3.0E-6
15 35 3.0E-6
16 0 78.0
16 1 64.0
16 2 3.0E-6
16 3 3.0E-6
16 4 3.0E-6
16 5 3.0E-6
16 6 3.0E-6
16 7 3.0E-6
16 8 3.0E-6
16 9 3.0E-6
16 10 3.0E-6
16 11 3.0E-6
16 12 3.0E-6
16 13 3.0E-6
16 14 3.0E-6
16 15 3.0E-6
16 16 3.0E-6
16 17 3.0E-6
16 18 3.0E-6
16 19 3.0E-6
16 20 3.0E-6
16 21 3.0E-6
16 22 3.0E-6
16 23 3.0E-6
16 24 84.0
16 25 95.0
16 26 3.0E-6
16 27 3.0E-6
16 28 3.0E-6
16 29 3.0E-6
16 30 3.0E-6
16 31 3.0E-6
16 32 3.0E-6
16 33 3.0E-6
16 34 3.0E-6
16 35 3.0E-6
17 0 3.0E-6
17 1 3.0E-6
17 2 25.0
17 3 84.0
17 4 3.0E-6
17 5 3.0E-6
17 6 3.0E-6
17 7 3.0E-6
17 8 3.0E-6
17 9 3.0E-6
17 10 3.0E-6
17 11 3.0E-6
17 12 3.0E-6
17 13 3.0E-6
17 14 3.0E-6
17 15 3.0E-6
17 16 3.0E-6
17 17 3.0E-6
17 18 3.0E-6
17 19 3.0E-6
17 20 3.0E-6
17 21 3.0E-6
17 22 3.0E-6
17 23 3.0E-6
17 24 30.0
17 25 89.0
17 26 3.0E-6
17 27 3.0E-6
17 28 3.0E-6
17 29 3.0E-6
17 30 3.0E-6
17 31 3.0E-6
17 32 3.0E-6
17 33 3.0E-6
17 34 3.0E-6
17 35 3.0E-6
18 0 3.0E-6
18 1 3.0E-6
18 2 3.0E-6
18 3 3.0E-6
18 4 25.0
18 5 66.0
18 6 3.0E-6
18 7 3.0E-6
18 8 3.0E-6
18 9 3.0E-6
18 10 3.0E-6
18 11 3.0E-6
18 12 3.0E-6
18 13 3.0E-6
18 14 3.0E-6
18 15 3.0E-6
18 16 3.0E-6
18 17 3.0E-6
18 18 3.0E-6
18 19 3.0E-6
18 20 3.0E-6
18 21 3.0E-6
18 22 3.0E-6
18 23 3.0E-6
18 24 3.0E-6
18 25 3.0E-6
18 26 32.0
18 27 92.0
18 28 3.0E-6
18 29 3.0E-6
18 30 3.0E-6
18 31 3.0E-6
18 32 3.0E-6
18 33 3.0E-6
18 34 3.0E-6
18 35 3.0E-6
19 0 3.0E-6
19 1 3.0E-6
19 2 3.0E-6
19 3 3.0E-6
19 4 3.0E-6
19 5 3.0E-6
19 6 81.0
19 7 66.0
19 8 3.0E-6
19 9 3.0E-6
19 10 3.0E-6
19 11 3.0E-6
19 12 3.0E-6
19 13 3.0E-6
19 14 3.0E-6
19 15 3.0E-6
19 16 3.0E-6
19 17 3.0E-6
19 18 3.0E-6
19 19 3.0E-6
19 20 3.0E-6
19 21 3.0E-6
19 22 3.0E-6
19 23 3.0E-6
19 24 3.0E-6
19 25 3.0E-6
19 26 76.0
19 27 66.0
19 28 3.0E-6
19 29 3.0E-6
19 30 3.0E-6
19 31 3.0E-6
19 32 3.0E-6
19 33 3.0E-6
19 34 3.0E-6
19 35 3.0E-6
20 0 3.0E-6
20 1 3.0E-6
20 2 3.0E-6
20 3 3.0E-6
20 4 3.0E-6
20 5 3.0E-6
20 6 3.0E-6
20 7 3.0E-6
20 8 38.0
20 9 88.0
20 10 3.0E-6
20 11 3.0E-6
20 12 3.0E-6
20 13 3.0E-6
20 14 3.0E-6
20 15 3.0E-6
20 16 3.0E-6
20 17 3.0E-6
20 18 3.0E-6
20 19 3.0E-6
20 20 3.0E-6
20 21 3.0E-6
20 22 3.0E-6
20 23 3.0E-6
20 24 3.0E-6
20 25 3.0E-6
20 26 3.0E-6
20 27 3.0E-6
20 28 99.0
20 29 63.0
20 30 3.0E-6
20 31 3.0E-6
20 32 3.0E-6
20 33 3.0E-6
20 34 3.0E-6
20 35 3.0E-6
21 0 3.0E-6
21 1 3.0E-6
21 2 3.0E-6
21 3 3.0E-6
21 4 3.0E-6
21 5 3.0E-6
21 6 3.0E-6
21 7 3.0E-6
21 8 3.0E-6
21 9 3.0E-6
21 10 72.0
21 11 48.0
21 12 3.0E-6
21 13 3.0E-6
21 14 3.0E-6
21 15 3.0E-6
21 16 3.0E-6
21 17 3.0E-6
21 18 3.0E-6
21 19 3.0E-6
21 20 3.0E-6
21 21 3.0E-6
21 22 3.0E-6
21 23 3.0E-6
21 24 3.0E-6
21 25 3.0E-6
21 26 3.0E-6
21 27 3.0E-6
21 28 23.0
21 29 31.0
21 30 3.0E-6
21 31 3.0E-6
21 32 3.0E-6
21 33 3.0E-6
21 34 3.0E-6
21 35 3.0E-6
22 0 3.0E-6
22 1 3.0E-6
22 2 3.0E-6
22 3 3.0E-6
22 4 3.0E-6
22 5 3.0E-6
22 6 3.0E-6
22 7 3.0E-6
22 8 3.0E-6
22 9 3.0E-6
22 10 3.0E-6
22 11 3.0E-6
22 12 84.0
22 13 25.0
22 14 3.0E-6
22 15 3.0E-6
22 16 3.0E-6
22 17 3.0E-6
22 18 3.0E-6
22 19 3.0E-6
22 20 3.0E-6
22 21 3.0E-6
22 22 3.0E-6
22 23 3.0E-6
22 24 3.0E-6
22 25 3.0E-6
22 26 3.0E-6
22 27 3.0E-6
22 28 3.0E-6
22 29 3.0E-6
22 30 98.0
22 31 32.0
22 32 3.0E-6
22 33 3.0E-6
22 34 3.0E-6
22 35 3.0E-6
23 0 3.0E-6
23 1 3.0E-6
23 2 3.0E-6
23 3 3.0E-6
23 4 3.0E-6
23 5 3.0E-6
23 6 3.0E-6
23 7 3.0E-6
23 8 3.0E-6
23 9 3.0E-6
23 10 3.0E-6
23 11 3.0E-6
23 12 3.0E-6
23 13 3.0E-6
23 14 22.0
23 15 52.0
23 16 3.0E-6
23 17 3.0E-6
23 18 3.0E-6
23 19 3.0E-6
23 20 3.0E-6
23 21 3.0E-6
23 22 3.0E-6
23 23 3.0E-6
23 24 3.0E-6
23 25 3.0E-6
23 26 3.0E-6
23 27 3.0E-6
23 28 3.0E-6
23 29 3.0E-6
23 30 58.0
23 31 63.0
23 32 3.0E-6
23 33 3.0E-6
23 34 3.0E-6
23 35 3.0E-6
24 0 3.0E-6
24 1 3.0E-6
24 2 3.0E-6
24 3 3.0E-6
24 4 3.0E-6
24 5 3.0E-6
24 6 3.0E-6
24 7 3.0E-6
24 8 3.0E-6
24 9 3.0E-6
24 10 3.0E-6
24 11 3.0E-6
24 12 3.0E-6
24 13 3.0E-6
24 14 3.0E-6
24 15 3.0E-6
24 16 84.0
24 17 30.0
24 18 3.0E-6
24 19 3.0E-6
24 20 3.0E-6
24 21 3.0E-6
24 22 3.0E-6
24 23 3.0E-6
24 24 3.0E-6
24 25 3.0E-6
24 26 3.0E-6
24 27 3.0E-6
24 28 3.0E-6
24 29 3.0E-6
24 30 3.0E-6
24 31 3.0E-6
24 32 63.0
24 33 57.0
24 34 3.0E-6
24 35 3.0E-6
25 0 3.0E-6
25 1 3.0E-6
25 2 3.0E-6
25 3 3.0E-6
25 4 3.0E-6
25 5 3.0E-6
25 6 3.0E-6
25 7 3.0E-6
25 8 3.0E-6
25 9 3.0E-6
25 10 3.0E-6
25 11 3.0E-6
25 12 3.0E-6
25 13 3.0E-6
25 14 3.0E-6
25 15 3.0E-6
25 16 95.0
25 17 89.0
25 18 3.0E-6
25 19 3.0E-6
25 20 3.0E-6
25 21 3.0E-6
25 22 3.0E-6
25 23 3.0E-6
25 24 3.0E-6
25 25 3.0E-6
25 26 3.0E-6
25 27 3.0E-6
25 28 3.0E-6
25 29 3.0E-6
25 30 3.0E-6
25 31 3.0E-6
25 32 3.0E-6
25 33 3.0E-6
25 34 27.0
25 35 84.0
26 0 3.0E-6
26 1 3.0E-6
26 2 3.0E-6
26 3 3.0E-6
26 4 3.0E-6
26 5 3.0E-6
26 6 3.0E-6
26 7 3.0E-6
26 8 3.0E-6
26 9 3.0E-6
26 10 3.0E-6
26 11 3.0E-6
26 12 3.0E-6
26 13 3.0E-6
26 14 3.0E-6
26 15 3.0E-6
26 16 3.0E-6
26 17 3.0E-6
26 18 32.0
26 19 76.0
26 20 3.0E-6
26 21 3.0E-6
26 22 3.0E-6
26 23 3.0E-6
26 24 3.0E-6
26 25 3.0E-6
26 26 3.0E-6
26 27 3.0E-6
26 28 3.0E-6
26 29 3.0E-6
26 30 3.0E-6
26 31 3.0E-6
26 32 3.0E-6
26 33 55.0
26 34 52.0
26 35 3.0E-6
27 0 3.0E-6
27 1 3.0E-6
27 2 3.0E-6
27 3 3.0E-6
27 4 3.0E-6
27 5 3.0E-6
27 6 3.0E-6
27 7 3.0E-6
27 8 3.0E-6
27 9 3.0E-6
27 10 3.0E-6
27 11 3.0E-6
27 12 3.0E-6
27 13 3.0E-6
27 14 3.0E-6
27 15 3.0E-6
27 16 3.0E-6
27 17 3.0E-6
27 18 92.0
27 19 66.0
27 20 3.0E-6
27 21 3.0E-6
27 22 3.0E-6
27 23 3.0E-6
27 24 3.0E-6
27 25 3.0E-6
27 26 3.0E-6
27 27 3.0E-6
27 28 3.0E-6
27 29 3.0E-6
27 30 3.0E-6
27 31 3.0E-6
27 32 25.0
27 33 3.0E-6
27 34 3.0E-6
27 35 53.0
28 0 3.0E-6
28 1 3.0E-6
28 2 3.0E-6
28 3 3.0E-6
28 4 3.0E-6
28 5 3.0E-6
28 6 3.0E-6
28 7 3.0E-6
28 8 3.0E-6
28 9 3.0E-6
28 10 3.0E-6
28 11 3.0E-6
28 12 3.0E-6
28 13 3.0E-6
28 14 3.0E-6
28 15 3.0E-6
28 16 3.0E-6
28 17 3.0E-6
28 18 3.0E-6
28 19 3.0E-6
28 20 99.0
28 21 23.0
28 22 3.0E-6
28 23 3.0E-6
28 24 3.0E-6
28 25 3.0E-6
28 26 3.0E-6
28 27 3.0E-6
28 28 3.0E-6
28 29 3.0E-6
28 30 3.0E-6
28 31 3.0E-6
28 32 3.0E-6
28 33 3.0E-6
28 34 42.0
28 35 94.0
29 0 3.0E-6
29 1 3.0E-6
29 2 3.0E-6
29 3 3.0E-6
29 4 3.0E-6
29 5 3.0E-6
29 6 3.0E-6
29 7 3.0E-6
29 8 3.0E-6
29 9 3.0E-6
29 10 3.0E-6
29 11 3.0E-6
29 12 3.0E-6
29 13 3.0E-6
29 14 3.0E-6
29 15 3.0E-6
29 16 3.0E-6
29 17 3.0E-6
29 18 3.0E-6
29 19 3.0E-6
29 20 63.0
29 21 31.0
29 22 3.0E-6
29 23 3.0E-6
29 24 3.0E-6
29 25 3.0E-6
29 26 3.0E-6
29 27 3.0E-6
29 28 3.0E-6
29 29 3.0E-6
29 30 3.0E-6
29 31 3.0E-6
29 32 33.0
29 33 78.0
29 34 3.0E-6
29 35 3.0E-6
30 0 3.0E-6
30 1 3.0E-6
30 2 3.0E-6
30 3 3.0E-6
30 4 3.0E-6
30 5 3.0E-6
30 6 3.0E-6
30 7 3.0E-6
30 8 3.0E-6
30 9 3.0E-6
30 10 3.0E-6
30 11 3.0E-6
30 12 3.0E-6
30 13 3.0E-6
30 14 3.0E-6
30 15 3.0E-6
30 16 3.0E-6
30 17 3.0E-6
30 18 3.0E-6
30 19 3.0E-6
30 20 3.0E-6
30 21 3.0E-6
30 22 98.0
30 23 58.0
30 24 3.0E-6
30 25 3.0E-6
30 26 3.0E-6
30 27 3.0E-6
30 28 3.0E-6
30 29 3.0E-6
30 30 3.0E-6
30 31 3.0E-6
30 32 28.0
30 33 3.0E-6
30 34 3.0E-6
30 35 58.0
31 0 3.0E-6
31 1 3.0E-6
31 2 3.0E-6
31 3 3.0E-6
31 4 3.0E-6
31 5 3.0E-6
31 6 3.0E-6
31 7 3.0E-6
31 8 3.0E-6
31 9 3.0E-6
31 10 3.0E-6
31 11 3.0E-6
31 12 3.0E-6
31 13 3.0E-6
31 14 3.0E-6
31 15 3.0E-6
31 16 3.0E-6
31 17 3.0E-6
31 18 3.0E-6
31 19 3.0E-6
31 20 3.0E-6
31 21 3.0E-6
31 22 32.0
31 23 63.0
31 24 3.0E-6
31 25 3.0E-6
31 26 3.0E-6
31 27 3.0E-6
31 28 3.0E-6
31 29 3.0E-6
31 30 3.0E-6
31 31 3.0E-6
31 32 3.0E-6
31 33 95.0
31 34 29.0
31 35 3.0E-6
32 0 3.0E-6
32 1 3.0E-6
32 2 3.0E-6
32 3 3.0E-6
32 4 3.0E-6
32 5 3.0E-6
32 6 3.0E-6
32 7 3.0E-6
32 8 3.0E-6
32 9 3.0E-6
32 10 3.0E-6
32 11 3.0E-6
32 12 3.0E-6
32 13 3.0E-6
32 14 3.0E-6
32 15 3.0E-6
32 16 3.0E-6
32 17 3.0E-6
32 18 3.0E-6
32 19 3.0E-6
32 20 3.0E-6
32 21 3.0E-6
32 22 3.0E-6
32 23 3.0E-6
32 24 63.0
32 25 3.0E-6
32 26 3.0E-6
32 27 25.0
32 28 3.0E-6
32 29 33.0
32 30 28.0
32 31 3.0E-6
32 32 3.0E-6
32 33 3.0E-6
32 34 3.0E-6
32 35 3.0E-6
33 0 3.0E-6
33 1 3.0E-6
33 2 3.0E-6
33 3 3.0E-6
33 4 3.0E-6
33 5 3.0E-6
33 6 3.0E-6
33 7 3.0E-6
33 8 3.0E-6
33 9 3.0E-6
33 10 3.0E-6
33 11 3.0E-6
33 12 3.0E-6
33 13 3.0E-6
33 14 3.0E-6
33 15 3.0E-6
33 16 3.0E-6
33 17 3.0E-6
33 18 3.0E-6
33 19 3.0E-6
33 20 3.0E-6
33 21 3.0E-6
33 22 3.0E-6
33 23 3.0E-6
33 24 57.0
33 25 3.0E-6
33 26 55.0
33 27 3.0E-6
33 28 3.0E-6
33 29 78.0
33 30 3.0E-6
33 31 95.0
33 32 3.0E-6
33 33 3.0E-6
33 34 3.0E-6
33 35 3.0E-6
34 0 3.0E-6
34 1 3.0E-6
34 2 3.0E-6
34 3 3.0E-6
34 4 3.0E-6
34 5 3.0E-6
34 6 3.0E-6
34 7 3.0E-6
34 8 3.0E-6
34 9 3.0E-6
34 10 3.0E-6
34 11 3.0E-6
34 12 3.0E-6
34 13 3.0E-6
34 14 3.0E-6
34 15 3.0E-6
34 16 3.0E-6
34 17 3.0E-6
34 18 3.0E-6
34 19 3.0E-6
34 20 3.0E-6
34 21 3.0E-6
34 22 3.0E-6
34 23 3.0E-6
34 24 3.0E-6
34 25 27.0
34 26 52.0
34 27 3.0E-6
34 28 42.0
34 29 3.0E-6
34 30 3.0E-6
34 31 29.0
34 32 3.0E-6
34 33 3.0E-6
34 34 3.0E-6
34 35 3.0E-6
35 0 3.0E-6
35 1 3.0E-6
35 2 3.0E-6
35 3 3.0E-6
35 4 3.0E-6
35 5 3.0E-6
35 6 3.0E-6
35 7 3.0E-6
35 8 3.0E-6
35 9 3.0E-6
35 10 3.0E-6
35 11 3.0E-6
35 12 3.0E-6
35 13 3.0E-6
35 14 3.0E-6
35 15 3.0E-6
35 16 3.0E-6
35 17 3.0E-6
35 18 3.0E-6
35 19 3.0E-6
35 20 3.0E-6
35 21 3.0E-6
35 22 3.0E-6
35 23 3.0E-6
35 24 3.0E-6
35 25 84.0
35 26 3.0E-6
35 27 53.0
35 28 94.0
35 29 3.0E-6
35 30 58.0
35 31 3.0E-6
35 32 3.0E-6
35 33 3.0E-6
35 34 3.0E-6
35 35 3.0E-6

;









end;