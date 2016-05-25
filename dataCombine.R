msd <- read.csv('MSDSubset-extracted-data.csv', quote = '')
top <- read.csv('MSDSubset-topics.csv')
summary(top)
summary(msd)
unique(top$genre)
table(top[top$genre=='Rock',]$topic)

msd$tid[1:20]
top$tid[1:20]

m <- msd[with(msd, order(tid)),]
t <- top[with(top, order(tid)),]
m$tid[1:20]
t$tid[1:20]

length(m$tid)
length(t$tid)
m$tid[1260:1268]
t$tid[1260:1267]

m <- m[1:1267,]
m$tid[1000]
t$tid[1000]

d <- cbind(m,genre = t$genre, topic = t$topic)
summary(d)

write.csv(d, file = 'MSD_master_data.csv')

## Analysis

d <- read.csv('MSD_master_data.csv')
sort(unique(d$genre))
colnames(d)
plot(d$loudness~d$genre)
plot(d$song_hotttnesss~d$genre)
plot(d$duration~d$genre)
plot(d$end_of_fade_in~d$genre)
plot(d$key~d$genre)
plot(d$genre~d$key)
plot(d$start_of_fade_out)
plot((d$duration-d$start_of_fade_out)~d$genre)
plot(d$tempo~d$genre)
plot(d$genre~d$topic)

sum(is.na(d$song_hotttnesss))
summary(d)
class(d$duration)

chisq.test(d$genre, d$topic)
chisq.test(d$genre, d$key)
chisq.test(d$genre, d$mode)
chisq.test(d$genre, d$topic, simulate.p.value = TRUE)
chisq.test(d$genre, d$key, simulate.p.value = TRUE)
chisq.test(d$genre, d$mode, simulate.p.value = TRUE)

cor(d$duration, d$tempo)
cor(d$duration, d$end_of_fade_in)
cor(d$loudness, d$duration)

fit <- aov(d$duration ~ d$genre)
summary(fit)
tuk <- TukeyHSD(fit)
tuk
plot(tuk)

fit <- aov(d$year ~ d$genre)
summary(fit)
tuk <- TukeyHSD(fit)
tuk
plot(tuk)

fit <- aov(d$loudness ~ d$genre)
summary(fit)
tuk <- TukeyHSD(fit)
tuk
plot(tuk)

#Creating .csv's for PCA Analysis
colnames(d)
pcaPrepNG <- cbind(d$end_of_fade_in, d$mode, d$time_signature, d$key, d$start_of_fade_out, d$year, d$duration, d$loudness, d$tempo, d$topic)
pcaPrepWG <- cbind(d$end_of_fade_in, d$mode, d$time_signature, d$key, d$start_of_fade_out, d$year, d$duration, d$loudness, d$tempo, d$topic, d$genre)
pcaPrepCont <- cbind(d$end_of_fade_in, d$time_signature, d$start_of_fade_out, d$year, d$duration, d$loudness, d$tempo)

write.csv(pcaPrepNG, file="PCANoGenre.csv")
write.csv(pcaPrepWG, file="PCAWithGenre.csv")
write.csv(pcaPrepCont, file="PCACont.csv")
