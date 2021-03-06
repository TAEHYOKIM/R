## R-39일차(2018.2.21)

  #39-1. 연관분석
  #39-2. apriori()
  #39-3. network node graph 
  #39-1. 연관규칙(분석)
      #- 시리얼과 우유의 관계를 알아내는 대표적인 기계학습
      #- 시리얼 ------> 우유
        #: 이 규칙은 시리얼을 사면 우유도 함께 구매한다는 것을 알아내는
        #  알고리즘이다.

                            count(x)
1) 지지도 : support(x) = ---------------
                          N(DB 거래건수)

* count(x) : 시리얼의 거래건수

                                  support(x,y)
2) 신뢰도 : confidence(x --> y) = ------------ = P(y|x)
                                   support(x)

                             confidence(x -> y)        support(x,y)         P(y|x)
3) 향상도 : lift(x --> y) = ------------------- = ---------------------- = --------
                                 support(y)        support(x)*support(y)     P(y)

[※ 신뢰도 와 향상도가 클수록 연관관계가 높다.]
1 : 관계없다
1< : 양의관계
1> : 음의 관계

support(x,y) = n(x ∩ y) / N   ※ support(x∪y) 로 표현하기도 함
: 전체건수에서 x와 y가 모두 포함되어 있는 건수의 비 

confidence(x --> y) = support(x,y) / support(x)
: 항목 x를 포함하는 건수 중에 x와 y를 모두 포함하는 건수의 비

support(우유,시리얼) : 우유와 시리얼을 동시에 구매할 확률

confidence(우유 --> 시리얼) : 우유를 구매할 때 시리얼도 같이 구매할 조건부 확률


※ 용어
Cross Selling : 붙여팔기(ex.자전거+헬멧, 핸드폰+케이스)
Up Selling : 호갱만들기(업그레이드된 상품을 구매하도록 유도하는 판매활동)


#[문제239] 전체 판매에서 우유와 시리얼이 동시에 판매될 확률?
"  
거래번호 구매물품 
    1    우유, 버터, 시리얼
    2    우유, 시리얼 
    3    우유, 빵 
    4    버터, 맥주, 오징어
"
support = 2/4 = 50%


#[문제240] 우유를 샀을때 시리얼을 살 조건부 확률은?
  
  confidence = 2/3 = 66%


#[문제241] 시리얼을 샀을때 우유를 살 조건부 확률은?
  
  confidence = 2/2 = 100%

#우유 --> 시리얼(50%, 66%) : 지지도, 신뢰도
#시리얼 --> 우유(50%, 100%) : 지지도, 신뢰도
#∴ 결론으로 우리가 찾고자하는 연관규칙은 지지도와 신뢰도 둘다 최소한도 보다 높은 것을 의미함.

#x, y라는 항목의 조합의 수도 너무나도 다양하기 때문에 모든 경우의 수를 다 계산한다면 시간이 오래 걸린다. 
#그래서 최소 지지도 이상의 데이터를 찾아주는게 좋다.(거래 항목 중에 n건 이상 구매)
"
거래번호  아이템 
   1      A C D 
   2      B C E 
   3      A B C E 
   4      B E
"

#아이템 종류별 지지도
"
아이템 지지도 
   A      2 
   B      3 
   C      3 
   D      1 
   E      3
"

#지지도가 1보다 큰 것만 추출해서 정리하자.
"
아이템 지지도 
A      2 
B      3 
C      3 
E      3
"

#위 아이템을 조합해서 목록을 만든다.
"
아이템목록 지지도 
   A B        1 
   A C        2 
   A E        1 
   B C        2 
   B E        3 
   C E        2
"
# -> B C E 구매 지지도가 높다

#위 목록에서 지지도가 높은 품목을 조합하자.
"
아이템 목록 지지도 
   B C E      2
"
# ∴ 물건 진열시 B C E 같이 진열하자!!
  
#데이터 프레임으로 작성해 보자
x <- data.frame(beer = c(0,1,1,1,0),
                bread = c(1,1,0,1,1),
                cola = c(0,0,1,0,1),
                diapers = c(0,1,1,1,1),
                eggs = c(0,1,0,0,0),
                milk = c(1,0,1,1,1))
x


## 39-2. apriori(matrix) : 상관규칙 분석시 사용
install.packages("arules")
library(arules)

trans <- as.matrix(x, "Transaction")  # Transaction : 논리적으로 DML을 하나로 묶어서 처리하는 작업단위 

# supp, conf : 최소한의 값으로 알아서 정해라 
rules1 <- apriori(trans, parameter = list(supp = 0.2, conf = 0.6, target = "rules", minlen = 2))
inspect(rules1)  # 목록 출력 
inspect(sort(rules1))

#매트릭스 Transaction 하면 좋은점?
# : 0 의미없는 거는 분리해서 처리해주는 기능(메모리 활용효율 위해)
#0은 조작 안 한다
#apriori 사용시에는 무조건 매트릭스 Transaction
#minlen(maxlen) : 최소(대) 품목 갯수

1개 품목
lhs rhs             support confidence lift      count
[1] {} => {milk}    0.8     0.8000000  1.0000000 4
[2] {} => {bread}   0.8     0.8000000  1.0000000 4
[3] {} => {diapers} 0.8     0.8000000  1.0000000 4
[4] {} => {beer}    0.6     0.6000000  1.0000000 3

2개 품목
lhs  rhs                  support confidence lift      count
[5]  {eggs} => {beer}     0.2     1.0000000  1.6666667 1
[6]  {eggs} => {bread}    0.2     1.0000000  1.2500000 1
[7]  {eggs} => {diapers}  0.2     1.0000000  1.2500000 1
[8]  {cola} => {milk}     0.4     1.0000000  1.2500000 2
[9]  {cola} => {diapers}  0.4     1.0000000  1.2500000 2
[10] {beer} => {milk}     0.4     0.6666667  0.8333333 2
[11] {beer} => {bread}    0.4     0.6666667  0.8333333 2
[12] {beer} => {diapers}  0.6     1.0000000  1.2500000 3
[13] {diapers} => {beer}  0.6     0.7500000  1.2500000 3
[14] {milk} => {bread}    0.6     0.7500000  0.9375000 3
[15] {bread} => {milk}    0.6     0.7500000  0.9375000 3
[16] {milk} => {diapers}  0.6     0.7500000  0.9375000 3
[17] {diapers} => {milk}  0.6     0.7500000  0.9375000 3
[18] {bread} => {diapers} 0.6     0.7500000  0.9375000 3
[19] {diapers} => {bread} 0.6     0.7500000  0.9375000 3

3개 품목
lhs  rhs                       support confidence lift      count
[20] {beer,eggs} => {bread}    0.2     1.0000000  1.2500000 1
[21] {bread,eggs} => {beer}    0.2     1.0000000  1.6666667 1
[22] {beer,eggs} => {diapers}  0.2     1.0000000  1.2500000 1
[23] {diapers,eggs} => {beer}  0.2     1.0000000  1.6666667 1
[24] {bread,eggs} => {diapers} 0.2     1.0000000  1.2500000 1
[25] {diapers,eggs} => {bread} 0.2     1.0000000  1.2500000 1
[26] {beer,cola} => {milk}     0.2     1.0000000  1.2500000 1
[27] {beer,cola} => {diapers}  0.2     1.0000000  1.2500000 1
[28] {bread,cola} => {milk}    0.2     1.0000000  1.2500000 1
[29] {cola,milk} => {diapers}  0.4     1.0000000  1.2500000 2
[30] {cola,diapers} => {milk}  0.4     1.0000000  1.2500000 2
[31] {diapers,milk} => {cola}  0.4     0.6666667  1.6666667 2
[32] {bread,cola} => {diapers} 0.2     1.0000000  1.2500000 1
[33] {beer,milk} => {diapers}  0.4     1.0000000  1.2500000 2
[34] {beer,diapers} => {milk}  0.4     0.6666667  0.8333333 2
[35] {diapers,milk} => {beer}  0.4     0.6666667  1.1111111 2
[36] {beer,bread} => {diapers} 0.4     1.0000000  1.2500000 2
[37] {beer,diapers} => {bread} 0.4     0.6666667  0.8333333 2
[38] {bread,diapers} => {beer} 0.4     0.6666667  1.1111111 2
[39] {bread,milk} => {diapers} 0.4     0.6666667  0.8333333 2
[40] {diapers,milk} => {bread} 0.4     0.6666667  0.8333333 2
[41] {bread,diapers} => {milk} 0.4     0.6666667  0.8333333 2

t(trans)
trans

#이런 방법도 있다
b2 <- t(trans) %*% trans
b2

diag(b2)  # 대각행렬원소 보여줌(자기자신 보여줌)
diag(diag(b2))
b3 <- b2 - diag(diag(b2));b3

# Tools for Social Network Analysis 네트워크 그래프 그리는 용도
install.packages("sna")
library(sna)

# 3D visualization device system
install.packages("rgl")
library(rgl)


## 39-3. network node graph
gplot(b3, 
      displaylabels = T, # 노드레이블을 표시
      vertex.cex = sqrt(diag(b2)), # 노드크기
      vertex.col = "green", # 노드 색상
      edge.col = "blue", # 선의 색      
      boxed.labels = F,  # 노드레이블에 박스
      arrowhead.cex = .3,  # 화살촉 배수
      label.pos = 5,  # 노드 레이블 위치(0 ~ 5)
      label.col = "red",
      label.cex = 2,
      edge.lwd = b3  # 선의 폭지정 배수
)


#[문제242] 건물 상가에서 서로 연관이 있는 업종이 무엇인가?
  
#step.1 : 데이터 손질

building <- read.csv("c:/r/building.csv", header = T)
building <- building[-1]
building[is.na(building)] <- 0
building


#step.2 : 데이터 변환(->matrix)

b1 <- as.matrix(building, "Transaction");b1


#step.3 : 상관규칙 파악

ap1 <- apriori(b1, parameter = list(supp = 0.25, conf = 0.6, target = "rules", maxlen = 3))
inspect(sort(ap1))

b2 <- t(b1) %*% b1
b3 <- diag(diag(b2))
b4 <- b2-b3
b4

gplot(b4, 
      displaylabels = T,
      vertex.cex = sqrt(diag(b2)), # 노드크기
      vertex.col = "pink", # 노드 색상
      edge.col = "blue", # 선의 색      
      boxed.labels = F,  # 노드레이블에 박스
      arrowhead.cex = .3,  # 화살촉 배수
      label.pos = 5,  # 노드 레이블 위치(0 ~ 5)
      label.col = "black",
      label.cex = 1,
      
)


#[문제243] 영화.csv파일을 이용하여 연관분석을 하세요.

#step.1 데이터 확인

movie <- read.csv("c:/r/영화.csv")
movie


#step.2 데이터 변환

movie1 <- as.matrix(movie, "Transaction");movie1


#step.3 상관규칙 파악

movie2 <- apriori(movie1, parameter = list(supp = 0.3, conf = 0.6, target = "rules", minlen = 2))
inspect(sort(movie2))
# -> 영화 볼때 팝콘구매를 많이 하는 것을 통해 연관성이 매우 높다고 말할 수 있다.

movMat <- t(movie1) %*% movie1
movMat1 <- movMat - diag(diag(movMat))
movMat1

gplot(movMat1, 
      displaylabels = T, 
      vertex.cex = log(diag(movMat)),
      vertex.col = diag(movMat),
      boxed.labels = T,
      edge.lwd = movMat1,
      edge.col = "grey20",
      label.border = "blue")