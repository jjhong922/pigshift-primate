library(PIGShift)
library(ape)

modellist <- vector(mode = "list", length = 9)
modellist[[1]] <- "Human-to-anc"
modellist[[2]] <- "Chimp-to-anc"
modellist[[3]] <- "HCanc-to-anc"
modellist[[4]] <- "Gorilla-to-anc"
modellist[[5]] <- "HCGanc-to-anc"
modellist[[6]] <- "Orang-to-anc"
modellist[[7]] <- "HCGOanc-to-anc"
modellist[[8]] <- "Monkey-to-anc"
modellist[[9]] <- "OU"

which.model <- function(colindex) {
    modellist[[colindex]]
}

for (name in c("female-br", "female-cb", "female-ht", "female-kd", "male-br", "male-ht", "male-kd", "male-lv")) {
    file <- read.table(sprintf("../output/primate-%s/waic.tsv", name), sep = "\t", header = TRUE)
    file$max <- apply(file, 1, max)
    file$maxcol <- apply(file, 1, which.max)
    file$model <- lapply(file$maxcol, which.model)
    file[,10:12] <- data.frame(lapply(file[,10:12], as.character), stringsAsFactors = FALSE)
    write.table(file, file = sprintf("../output/primate-%s/waic_max-%s.tsv", name, name), sep = "\t")
}

