# read csv of historical data
options(stringsAsFactors=FALSE)
library(forecast)
dat <- read.csv('./data/percent-of-men-with-full-beards.csv')

dat <- head(dat, -1)

y <- as.numeric(gsub('%','',dat[,2]))
# Bounds
a <- 0
b <- 100
# Transform data
y <- log((y-a)/(b-y))

time_series <- ts(data=y, start=min(as.numeric(dat[,1])), end=max(as.numeric(dat[,1])))

beard_model <- ets(time_series)

save(file='./data/beard_model.rda', list=c('beard_model'))
