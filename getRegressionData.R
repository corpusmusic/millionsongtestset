d <- read.csv('MSD_master_data.csv')

reg_d <- cbind(genre=as.character(d$genre),d[c(4:6,8:13)],topic=as.character(d$topic))
reg_d_noncat <- cbind(genre=as.character(d$genre),d[c(4,6,9:13)])

write.csv(reg_d,"Regression/MSD_regression_data.csv", row.names = FALSE)
write.csv(reg_d_noncat,"Regression/MSD_regression_data_noncat.csv", row.names = FALSE)
