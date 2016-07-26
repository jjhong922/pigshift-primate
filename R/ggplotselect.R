library(PIGShift)
library(ape)
library(ggplot2)

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

for (i in 1:nrow(sigterms)) {
	curdat <- data[[which(organlist == sigterms[i,]$organ)]]
	curdat <- data.frame(t(curdat[,which(colnames(curdat)%in%groups[[sigterms[i,]$GO_terms]])]))
	curdat <- stack(curdat)
	
	print(sigterms[i,]$GO_terms)
	
	ggplot(curdat[curdat$ind != "human",], aes(x=values)) + 
		geom_density(aes(group = ind, colour = ind)) + 
		scale_x_continuous(limits = c(-20, 20)) +
		ggtitle(sprintf("%s(%s)-%s", sigterms[i,]$GO_terms, sigterms[i,]$model, sigterms[i,]$organ)) +
		labs(x = "log fold change", colour = "Species Legend") +
		theme_minimal()

	ggsave(sprintf("../plots/sig_ggplots/%s-%s_plot.png", sigterms[i,]$organ, sigterms[i,]$GO_terms))
}

print("script complete.")