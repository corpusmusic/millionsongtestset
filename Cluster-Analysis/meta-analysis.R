d <- read.csv('test06.csv')
summary(d)
#remove flawed data
dmod <- d[!d$year %in% c(0,1,.102,.328),]
summary(dmod)
#more data clean up
dmod1 <-dmod[!dmod$mode %in% c(2008,2005),]
#remove NA values
dmod2 <- na.omit(dmod1)
summary(dmod2$key)
summary(dmod2$artist_hotttnesss)
str(d) #view data types
View(d)
#create data frame for cluster analysis, needs to be all numeric values
dnumeric <- data.frame(dmod2$year,dmod2$artist_hotttnesss,dmod2$loudness,dmod2$song_hotttnesss,dmod2$tempo,dmod2$time_signature,dmod2$start_of_fade_out,dmod2$end_of_fade_in)
str(dnumeric)
summary(dnumeric)
summary(dmod2$year)
d1 <- d$year
#remove '0 or 1'year values
plot(tempo ~ year,data=dmod) #shows most songs are recent(sampling issue?)
boxplot(tempo ~ year,data=dmod)
#The following code was modified or created using this tutorial https://www.youtube.com/watch?v=5eDqRysaico
#Would like to thank Bharatendra Raj for a fine demonstration
#normalize the data with a z scale
#raw data values are of varying scales, larger values would dominate otherwise
z <- dnumeric[,-c(1,1)]
m <- apply(z,2,mean) #'2' signifies the column. If row , put '1'.
s <- apply(z,2,sd)
z <- scale(z,m,s)
summary(dmod2$key)
#Euclidean distance
#In principle,the larger the distance,the more contrast between data points.
#sample of 100 objects, dendrogram impossible to view otherwise
z1 <- z[1:100,] #This could be a sampling issue(i.e Randomness)
z2 <- z[500:1000,]
distance <- dist(z)
distance1 <- dist(z1)
print(distance,digits = 3)
#Cluser Dendrogram with Complete Linkage
hc.c <- hclust(distance)
hc.c1 <- hclust(distance1)
plot(hc.c,cex=.3)
plot(hc.c1,cex=.3) #Better visual,but smaller dataset used.
#Each branch can be viewed as a cluser


#Cluster Dendrogram with Average Linkage
hc.a <-hclust(distance,method = "average")
hc.a1 <-hclust(distance1,method = "average")
plot(hc.a1,hang=-1,cex=.4)
#Cluster Members table
#Matrix of members compared to cluser method
#If member.a[3] = member.c[3], then there is a match in num of clusters
member.c <- cutree(hc.c,15) #15 clusters
member.a <- cutree(hc.a,15)
table(member.a,member.c)

#Cluster Means
#Helpful in visualizing which field influences the cluster data

#Normalized averages
aggregate(z,list(member.c),mean)
#Average values that are not scaled,better visualization
aggregate(dnumeric[,-c(1,1)],list(member.c),mean)

#Silhouette Plot of sample size 100 w/15 cluster grouping
library(cluster)
#Values that are close to 1 are considered close to eachother
#Values that are negative are considered outliers
plot(silhouette(cutree(hc.c1,15),distance1),cex=.1)

#Scree Plot
#Gives insight on how many clusters to use
#Sum of squares formula
wss <- (nrow(z)-1)*sum(apply(z,2,var))
for (i in 2:20) {
  wss[i] <- sum(kmeans(z,centers = i)$withinss)
}
plot(1:20,wss,type = "b",xlab = "Number of Clusters",ylab = "Within Group Sum of Squares")

#K-Means Clustering
kclust <- kmeans(z,12)
kclust
kclust$centers #averages
#Some plots to test K-means cluster
plot(tempo~loudness,data = d,col = kclust$cluster)
plot(tempo~year,data = dmod2,col = kclust$cluster)
plot(loudness~year,data=dmod2,col=kclust$cluster)
plot(time_signature~tempo,data=dmod2,col=kclust$cluster)
plot(time_signature~loudness,data=dmod2,col=kclust$cluster)
plot(start_of_fade_out~end_of_fade_in,data=dmod2,col=kclust$cluster)
plot(song_hotttnesss~artist_hotttnesss,data=dmod2,col=kclust$cluster)
plot(start_of_fade_out~year,data=dmod2,col=kclust$cluster)
plot(end_of_fade_in~year,data=dmod2,col=kclust$cluster)

#Some correlation tests
cor(dmod2$loudness,dmod2$year)
cor(dmod2$time_signature,dmod2$tempo)
cor(dmod2$time_signature,dmod2$loudness)
cor(dmod2$start_of_fade_out,dmod2$end_of_fade_in)
cor(dmod2$artist_hotttnesss,dmod2$song_hotttnesss)
cor(dmod2$year,dmod2$end_of_fade_in)
cor(dmod2$year,dmod2$start_of_fade_out)
