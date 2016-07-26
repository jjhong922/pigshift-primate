library(PIGShift)
library(ape)
library(ggplot2)

dmode <- function(x) {
    den <- density(x, kernel=c("gaussian"))
    den$x[which.max(den$y)]   
}  

groups <- read.groups("../data/go/human/human-go-terms.txt")
primate.tree <- read.tree("../data/misc/brawand-et-al-primate-tree.tre")
sigterms <- read.table("../sigGOterms.tsv", sep = "\t", stringsAsFactors = FALSE)

organlist <- c("female-br", "female-cb", "female-ht", "female-kd", "male-br", "male-ht", "male-kd", "male-lv")
data <- list()
for (i in 1:length(organlist)) {
	data[[i]] <- read.exp(sprintf("../data/expression/primate/brawand-et-al/matrices/primate-%s.tsv", 
		organlist[[i]]), primate.tree)
	print(sprintf("%s matrix read.", organlist[[i]]))
}

stats <- data.frame(group = character(nrow(sigterms)), chimp_mode = numeric(nrow(sigterms)), chimp_mean = numeric(nrow(sigterms)), 
	gorilla_mode = numeric(nrow(sigterms)), gorilla_mean = numeric(nrow(sigterms)), 
	orangutan_mode = numeric(nrow(sigterms)), orangutan_mean = numeric(nrow(sigterms)), 
	monkey_mode = numeric(nrow(sigterms)), monkey_mean = numeric(nrow(sigterms)),
	stringsAsFactors = FALSE)

for (i in 1:nrow(sigterms)) {
	curdat <- data[[which(organlist == sigterms[i,]$organ)]]
	curdat <- data.frame(t(curdat[,which(colnames(curdat)%in%groups[[sigterms[i,]$GO_terms]])]))
	print(sigterms[i,]$GO_terms)
	stats[i,1] <- sigterms[i,]$GO_terms
	for (j in 2:ncol(curdat)) {
		stats[i,2*j-2] <- dmode(curdat[,j])
		stats[i,2*j-1] <- mean(curdat[,j])
	}
}

write.table(stats, file = "../stats.tsv", sep = "\t")

print("script complete.")
