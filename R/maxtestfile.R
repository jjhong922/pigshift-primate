library(PIGShift)
library(ape)


file <- read.table("../primate-female-brain.tsv", sep = "\t", header = TRUE)
file$max <- apply(file, 1, max)
file$maxcol <- apply(file, 1, which.max)
file[,10:11] <- data.frame(lapply(file[,10:11], as.character), stringsAsFactors = FALSE)
write.table(file, file = "../waic_max-female-br-max.tsv", sep = "\t")