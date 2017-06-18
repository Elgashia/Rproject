install.packages("KoNLP")
install.packages("wordcloud")
require(httr)
require(XML)
# ���¼� �м��� �� �ּ� a1�� ����.
a1 <- sapply(1:10, function(x) {
  paste("http://movie.naver.com/movie/bi/mi/pointWriteFormList.nhn?code=153964&type=after&isActualPointWriteExecute=false&isMileageSubscriptionAlready=false&isMileageSubscriptionReject=false&page=", 
        x, sep = "")
})

# ũ�Ѹ�
res <- sapply(1, function(x) {
  b <- xmlRoot(htmlTreeParse(file = a1[x], useInternalNodes = T, encoding = "UTF-8")) 
  res <- xpathSApply(doc = b, path = "//div[@class = 'score_reple']/p",xmlValue)
})

#matrix�� vector�� ��ȯ
ares <- as.vector(res)
require(KoNLP) # package loading (���¼� �м�)
useSejongDic() # ���� ������ ����Ѵ�.
require(wordcloud) # wordcloud pakcage loading

# === ���ʿ��� ���� ���� ===

# . ����
res1 <-gsub("[.]", "", res)
# ??
res1 <- gsub("[:punc:]", "", res1)
# BEST ����
res1 <- gsub("BEST","",res1)

# ���忡�� ���¼� �и�
res2 <- sapply(res1, extractNoun)
# names�� NULL �ʱ�ȭ. ��, ����������� ���� ���ŵ� ���·� ���¼Ҹ� ���.
names(res2) <- NULL
# list ���� ���� - ���ڵ��̱� ������ character������ ��ȯ.
res2 <- unlist(res2)
# ���� �ܾ���� Ƚ�� ����
res2 <- tapply(res2,res2,length)

# Plots �ٹ̱�
# ���� set ����
palete <- brewer.pal(8, "Set1")
# min.freq = (�ܾ��), random.color - palete���� ������ ���� �������� �ο�.
wordcloud(words = names(res2), freq = res2, min.freq = 3, random.color = T, scale = c(4,0.5), ordered.colors = F, random.order = T, color = palete)