library(PIGShift)
library(ape)

groups <- read.groups("../data/go/human/human-go-terms.txt")
primate.tree <- read.tree("../data/misc/brawand-et-al-primate-tree.tre")
sigterms <- read.table("../sigGOterms.tsv", sep = "\t")
organlist <- c("female-br", "female-cb", "female-ht", "female-kd", "male-br", "male-ht", "male-kd", "male-lv")
data <- list()
for (i in 1:length(organlist)) {
	data[[i]] <- read.exp(sprintf("../data/expression/primate/brawand-et-al/matrices/primate-%s.tsv", 
		sigterms[i,]$organ), primate.tree)
	print(i)
}

for (i in 1:nrow(sigterms)) {
	pdf(sprintf("../plots/sigplots/%s-%s_plot.pdf", sigterms[i,]$organ, sigterms[i,]$GO_terms))
	print(as.character(sigterms[i,]$GO_terms))
	print(as.character(sigterms[i,]$organ))
	plot_logfoldchange(data[[which(organlist == as.character(sigterms[i,]$organ))]], groups, group_name = as.character(sigterms[i,]$GO_terms), 
		main = sprintf("%s(%s)-%s", sigterms[i,]$GO_terms, sigterms[i,]$model,
		 sigterms[i,]$organ))
	dev.off()
}

print("script complete.")