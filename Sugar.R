library(rvest)
library(ggplot2)
library(dplyr)
library(scales)
library(maps)
library(magrittr)
library(reshape2)
library(varhandle)

setwd("~/Desktop/learning/Wechat")

url <- "https://en.wikipedia.org/wiki/Sugar#Consumption"
sugar <- read_html(url)
sugar %<>%
  html_nodes(xpath = '//*[@id="mw-content-text"]/div/table[2]') %>%
  .[[1]] %>%
  html_table(fill = T)
str(sugar) # 查看数据集的基本数据结构
DT::datatable(sugar)
# first remember the names
n <- sugar$Country

# transpose all but the first column (name)
sugar <- as.data.frame(t(sugar[,-1]))
colnames(sugar) <- n

write.csv(sugar, "sugar.csv")

sugar1 <- read.csv("sugar.csv", stringsAsFactors=FALSE)
sugar1
sugar1$Country <- as.factor(sugar1$Country)
str(sugar1)

ggplot(sugar1, aes(x = Date, y = Total, fill= Country)) + 
  geom_bar(stat = "identity", position = 'dodge') + labs(title = "World sugar consumption (1000 metric tons)", x = "Years", y = "Sugar consumption") + 
  theme_bw()
