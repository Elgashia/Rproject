#�ֻ���

roll <- function(){
  die <- 1:6
  dice <- sample(die, size=2, replace = TRUE, # repalce = TRUE�� ����ǥ�������� �Ѵ�.
  prob = c(1/8, 1/8, 1/8, 1/8, 1/8, 3/8))
  sum(dice)
}
roll()

library(ggplot2)

rolls <- replicate(10000, roll())
qplot(rolls, binwidth = 1)

#ī�����

names(die) <- c("one", "two", "three", "four", "five", "six")
die
names(die) <- NULL #�̸� �Ӽ� ����

hand1 <- c("ace", "king", "queen", "jack", "ten", "spades",
           "spades", "spades", "spades", "spades")

matrix(hand1, nrow = 5)
matrix(hand1, ncol = 2)
dim(hand1) <- c(5, 2)
hand1

hand2 <- c("ace", "spades", "king", "spades", "queen", "spades", "jack", "spades",
           "ten", "spades")

matrix(hand2, nrow = 5, byrow = TRUE)
matrix(hand2, ncol = 2, byrow = TRUE)

Sys.time() #���� �ð��� �˷���.

#����(FACTOR)
gender <- factor(c("male", "female", "female", "male"))
unclass(gender)
as.character(gender) #factor�� ���ڿ��� ��ȯ

card <- c("ace", "hearts", 1)
card

# ������ �ҷ�����
deck <- read.csv(file = "~/Rproj/deck.csv")
head(deck, 10)

write.csv(deck, file = "cards.csv", row.names = FALSE)

getwd()

# R ǥ���
# 1.���� ����
deal(deck)
new <- deck[c(1,1,1),c(1,2,3)]
deck[1:2, 1, drop = FALSE]

# 2. ���� ����
deck[-1, 1:3] # ù �� ���� ������
deck[-(2:52), 1:3] # ù�ุ

# 3. ��ĭ
deck[1, ] # 1���� ��ü ����������
deck[ , 1:3] #��� ���� 1:3�� ��������

# 4, ������ ����
deck[1, c(T, T, F)]
deck[T, ]

# 5. �̸�
deck[1, c("face", "suit", "value")]

# ī�� ���� �ֱ�

#������ �������� ù ���� �����ִ� �ڵ� �ۼ�
deal <- function(cards){
  cards[1, ]
}
deal(deck)

deck[c(2, 1, 3:52), ]

random <- sample(1:52, size = 52)
deck[random, ]

shuffle <- function(cards){
  random <- sample(1:52, size = 52)
  cards[random, ]
}
deck2 <- shuffle(deck)
deal(deck2)

# �޷� ��ȣ�� ���� ��ȣ
deck$value
mean(deck$value)
median(deck$value)

lst <- list(numbers = c(1, 2), logical = TRUE, strings = c("a", "b", "c"))
lst

sum(lst[1])
sum(lst$numbers)

# Tip) $�� ���� ����� ���� ǥ���(���ҵ��� �̸��� ���� ��� ���) [[]] <- ���� ��ȣ

sum(lst[[1]])

# ������ �����ϱ�
#1.�� �����ϱ�
vec <- c(0, 0, 0, 0, 0, 0)
vec[1] <- 1000
vec[7] <- 0
vec

deck2$new <- 1:52 # ������ ��Ʈ�� �� ���� �߰�
deck2$new <- NULL # data.frame�� ���� NULL�� �߰��ϸ� �� ��ü�� ����� ���� ����
deck2$value[c(13,26,39,52)] <- 14

sum(deck2$face == "ace") # deck2���� ace�� ����
deck2$value[deck2$face == "ace"] <- 14
deck2[deck2$face == "ace", ]

#��Ʈ����(��Ʈ ī��� �����̵��� ���� ������ ��� ī�尡 0�� ���̴�.)
deck3 <- deck
deck3$value <- 0

#��Ʈ ī�带 ã�Ƽ� 1�� �� �����ϱ�
deck3$value[deck3$suit == "hearts"] <- 1

#�����̵����� ã�� 13�� �� �����ϱ�
deck3[deck3$face == "queen" & deck3$suit == "spades", ][3] <- 13

#�����׽�Ʈ ����
#1. w�� ����ΰ�? w > 0
w <- c(-1, 0, 1)
#2. x�� 10���� ũ�� 20���� ������? 10 < x & x < 20
x <- c(5, 15)
#3. y ��ü�� �ܾ� February�� ���ϳ�? y == "February"
y <- "February"
#4. z���� ��� ���� ������ ���ϳ�? all(z %in% c("Monday", "Tuesday", "Wednesday", "Thursday",
# "Friday", "Saturday", "Sunday"))
z <- c("Monday", "Tuesday", "Friday")

#������(ŷ,��,�� = 10��, �� ���̽��� 11 or 1)
deck4 <- deck
facecard <- deck4$face %in% c("king", "queen", "jack")
deck4[facecard, ]
deck4$value[facecard] <- 10

#���̽��� ��� ���� ī���� ���� 21�� �ȵ� ��쿡�� 11�̴�.
deck4$value[deck4$face == "ace"] <- NA

#---------------------------
deal <- function(){
  card <- deck[1, ]
  assign("deck", deck[-1, ], envir = globalenv())
  card
}

shuffle <- function(){
  random <- sample(1:52, size = 52)
  assign("deck", deck[random, ], envir = globalenv())
}
#---------------------------
# setup �Լ��� ������ �� R�� ��ü���� ������ ��Ÿ�� ȯ���� �����Ѵ�.
setup <- function(deck){
  DECK <- deck
  
  DEAL <- function(){
    card <- deck[1, ]
    assign("deck", deck[-1, ], envir = parent.env(environment()))
    card
  }
  
  SHUFFLE <- function(){
    random <- sample(1:52, size = 52)
    assign("deck", DECK[random, ], envir = parent.env(environment()))
  }
  
  list(deal = DEAL, shuffle = SHUFFLE)
}

#Ŭ����(closure)
cards <- setup(deck)
deal <- cards$deal
shuffle <- cards$shuffle
# ���⼭ �̵�(deal, shuffle)�� �ٿ�ȯ���� setup�� ������ �� ��������� ��Ÿ�� ȯ���̴�.
#Tip> �Լ��� ������ �� R�� ������ ������ ���ο� ȯ��(runtime environment)�� �����.

#���ԸӽŸ����
# �� ���� �ɹ� ���� �̱�, �ɹ��� ���� ���� ���.

get_symbols <- function(){
  wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
  sample(wheel, size = 3, replace = TRUE,
         prob = c(0.03, 0.03, 0.06, 0.1, 0.25, 0.01, 0.52))
}

# if ��
#'���� �̰�(this)�� ���̸� ����(that)�� �϶�'�� R�� ���Ѵٸ�?'

if (this) {
  that
}
# �� �̷��� ǥ���� �� �ִ�.
# this�� TRUE, FALSE�� ���Ǵ� ���� �׽�Ʈ�ų� R ǥ�����̾�� �Ѵ�.
# this�� TRUE��� that�� �����Ѵ�.

# if���� �̿��� num ��ü�� �׻� ����� �ǵ��� �ϰ� �� �� �ִ�.
num <- -2

if(num < 0){
  num <- num*-1
}
num

# �Ǽ��� ���� ����� ������ �ݿø�.

a <- 3.14

dec <- a - trunc(a) #trunc�� ���ڸ� ���ؼ� �Ҽ��� ���ϸ� ������ ������(��, ����)�� �����ش�.
dec

if(dec>=0.5){
  a <- trunc(a)+1
} else {
  a <- trunc(a)
}
#if�� ���� �ΰ��� �ʿ��Ұ��
a <- 1
b <- 1
if(a>b){
  print("a wins")
} else if (a<b){
  print("b wins")
} else {
  print("tie")
}
