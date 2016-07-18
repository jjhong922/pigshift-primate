library(PIGShift)
library(ape)

groups <- read.groups("../data/go/human/human-go-terms.txt")
primate.tree <- read.tree("../data/misc/brawand-et-al-primate-tree.tre")

data <- read.exp("../data/expression/primate/brawand-et-al/matrices/primate-female-br.tsv", primate.tree)
maxfile <- read.table("../waic_max-female-br-max.tsv", sep = "\t", header = TRUE)
	siggroups <- list()
	for (i in 1:nrow(maxfile)) {
		if (maxfile[i,]$max >= .98 && maxfile[i,]$maxcol != 9 && maxfile[i,]$maxcol != 1) {
			siggroups <- c(siggroups, row.names(maxfile[i,]))
		}
	}
	print(sprintf("%s plots to create for female-br-max", length(siggroups)))
	for (group in siggroups) {
		pdf(sprintf("../plots/primate-female-br-max/%s_plot.pdf", group))
		print(group)
		plot_logfoldchange(data, groups, group_name = group, main = sprintf("%s(V%s)", group, maxfile[group,]$maxcol))
		dev.off()
	}
