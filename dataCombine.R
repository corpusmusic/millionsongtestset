## First set the working directory (Session menu) to where this file is located
## Then import data

msd <- read.csv('MSDSubset-extracted-data.csv', quote = '') # audio/musical data
top <- read.csv('MSDSubset-topics.csv') # results of a (preliminary) topic model of song lyrics

## View summaries of the datasets

summary(top)
summary(msd)

## View a list of the genre tags included in the topic model dataset
unique(top$genre)

## How many songs are tagged with each topic?

table(top[top$genre=='Rock',]$topic)

## Are the songs in the two datasets in the same order?
## We need to ensure correspondence between the datasets before we combine them.
## Look at just the Track IDs from the first 20 records.

msd$tid[1:20]
top$tid[1:20]

## Nope.
## Sort the records in each dataset by Track ID.

m <- msd[with(msd, order(tid)),]
t <- top[with(top, order(tid)),]

## Now do they correspond?

m$tid[1:20]
t$tid[1:20]

## The first 20 do, but what about that last Track ID in the list of "levels" at the end?
## And why does one dataset have one more level than the other?
## Check the length of each dataset to make sure they are the same size.

length(m$tid)
length(t$tid)

## The music dataset has one more record than the topic model results. Where is it?
## The beginning of the dataset is fine. Let's check the end.

m$tid[1260:1268]
t$tid[1260:1267]

## The last record in the music dataset isn't in the topic model dataset.
## Drop the last record from the music datset so they line up.

m <- m[1:1267,]

## Does the new length match?

length(m$tid)

## Check another random example just to be sure.

m$tid[1000]
t$tid[1000]

## Now combine the two datasets together using cbind().

d <- cbind(m,genre = t$genre, topic = t$topic)

## Check the summary of the new combined dataset.

summary(d)

## Save the new combined dataset to a CSV file.

write.csv(d, file = 'MSD_master_data.csv')

## Analysis

## If re-starting here, load the data from the file saved above. Otherwise, skip.

d <- read.csv('MSD_master_data.csv')

## List of all parameters in the dataset.

colnames(d)

## Now try some two-parameter plots. Depending on the nature of each data type,
## it will produce a different kind of plot.

## Plot various continues data types according to genre. (Box and whisker plot.)

plot(d$loudness~d$genre) 
plot(d$song_hotttnesss~d$genre)
plot(d$duration~d$genre)
plot(d$end_of_fade_in~d$genre)
plot(d$key~d$genre) # Since key is represented by number, R thinks it is continuous instead of categorical data. This plot is meaningless.
plot(d$tempo~d$genre)

## Plot the relationship of two categorical data types.

plot(d$genre~d$key)
plot(d$genre~d$topic)

## This data type requires some help to be meaningful.

plot(d$start_of_fade_out)

## Since songs are different length, it's not when the fade out begins relative to the *start* 
## of the song, but how far it is from the *end* of the song that matters. 
## So we can make an ad hoc parameter via a calculation.

plot(d$duration-d$start_of_fade_out)

## And plot it by genre.

plot((d$duration-d$start_of_fade_out)~d$genre)

## To compare two data parameters for association, there are three main types of test.
## Correlation is used when the two data streams are both *continuous* data.
## Chi-Squared test is used when the two data streams are both *categorical* data.
## ANoVA test is used when one stream is continuous and the other categorical.

## Correlation between two continuous data streams.

cor(d$duration, d$tempo)
cor(d$duration, d$end_of_fade_in)
cor(d$loudness, d$duration)

## Replace cor with plot to get a scatter/dot plot.

plot(d$duration, d$tempo)
plot(d$duration, d$end_of_fade_in)
plot(d$loudness, d$duration)

## Chi-Squared test between two categorical data streams.
## If the p-value is less than 0.05, there is a significant association.

chisq.test(d$genre, d$topic)
chisq.test(d$genre, d$key)
chisq.test(d$genre, d$mode)

## Simulate.p.value = TRUE can help get more appropriate results with some datasets.
## (R will give you an error and hint if you need it.)
## However, note that when data values are less than 5, 
## the Chi-Squared test will not always be reliable.

chisq.test(d$genre, d$topic, simulate.p.value = TRUE)
chisq.test(d$genre, d$key, simulate.p.value = TRUE)
chisq.test(d$genre, d$mode, simulate.p.value = TRUE)

## Replacing chisq.test() with plot() will give a box-and-whisker plot.

plot(d$genre, d$topic)
plot(d$genre, d$key)

## ANoVA (Analysis of Variance) test for one stream of continuous data
## and one stream of categorical data.
## Is there an effect of the categorical data on the continuous data?

## This takes a few more steps in R.
## Use aov() (not anova()) to generate a data fit analysis.
## This will produce some general statistics that can be viewed with summary().
## If the p-value (Pr(>F)) is less than 0.05, then there is a significant
## difference between *some pair* of categories.
## To know exactly which pairs exhibit a significant difference by
## category, run a post-hoc analysis with TukeyHSD().
## Then the tuk command will give a list of category pairs. The 'p adj'
## column provides the p-value for that pair. If it is less than 0.05,
## there is a significant difference between the test data averages
## between those two categories.
## Plotting the post-hoc analysis will give a visualization of this fit.
## Category pairs whose 95% confidence interval does *not* overlap with 0
## are those for which there is a significant difference.

## ANoVA test of the effect of genre on duration.

fit <- aov(d$duration ~ d$genre)
summary(fit)
tuk <- TukeyHSD(fit)
tuk
plot(tuk)

## ANoVA test of the effect of genre on year.

fit <- aov(d$year ~ d$genre)
summary(fit)
tuk <- TukeyHSD(fit)
tuk
plot(tuk)

## ANoVA test of the effect of genre on loudness.

fit <- aov(d$loudness ~ d$genre)
summary(fit)
tuk <- TukeyHSD(fit)
tuk
plot(tuk)
