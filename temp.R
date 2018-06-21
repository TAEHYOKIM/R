install.packages("data.table")
library(data.table)

log_sample <- fread("/Users/hbk/Downloads/access_log_sample.log", header = FALSE, stringsAsFactors = FALSE)
log_sample
str(log_sample)

names(log_sample)

category <- fread("/Users/hbk/Downloads/category.csv", header = TRUE, stringsAsFactors = FALSE)
category

#grep(category$url[2],log_sample$V6)

#unlist(strsplit(log_sample$V6,split = ' '))

x <- c()
for(i in 1:length(log_sample$V6)){
  x[i] <- unlist(strsplit(log_sample$V6[i], split = ' '))[2]
}

log_sample$V9 <- x
str(log_sample)

help("merge")
merge_table <- merge(log_sample, category, by.x = 'V9', by.y = 'url')
str(merge_table)

merge_table$V9 <- NULL
str(merge_table)

help("aggregate")
aggr <- aggregate(V4~category, merge_table, length)
aggr

merge_table <- data.table(merge_table)

merge_table[, .N, by=.(category, V1)]
merge_table[, mean(V7), by=.(category)]

merge_table
res1 <- table(merge_table$V4, merge_table$category)
res2 <- xtabs(~V4+category, merge_table)


library(ggplot2) # local, global
#require(gglot2) : global
library(colorspace)

str(aggr)
class(aggr)
barplot(aggr$V4)
aggr

par(family = 'AppleGothic')
ggplot(aggr, aes(reorder(category, -V4), V4, fill = category)) + geom_bar(stat="identity")+
  theme(panel.background = element_blank(),
        plot.title = element_text(hjust=0.5),
        axis.line = element_line(color="black"))+
  labs(title="kkkkk", x="category", y="count")

require(ggplot2)
ggplot(aggr, aes(category, V4)) + geom_col()

ggplot(aggr)+
  geom_bar(aes(x = category, y = V4))

ggplot(melt(res2), aes(x = category, y = V4))+
  geom_jitter(aes(col = category))

Sys.setlocale('LC_ALL' , 'ko_KR.UTF-8')
# 한글 UTF-8 설정하기.

sessionInfo()
# 인코딩 확인하기.


install.packages("extrafont")
library(extrafont)
font_import()