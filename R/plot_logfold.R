library(PIGShift)
library(ape)

groups <- read.groups("../data/go/human/human-go-terms.txt")
primate.tree <- read.tree("../data/misc/brawand-et-al-primate-tree.tre")

for (name in c("female-br", "female-cb", "female-ht", "female-kd", "male-br", "male-ht", "male-kd", "male-lv")) {
	data <- read.exp(sprintf("../data/expression/primate/brawand-et-al/matrices/primate-%s.tsv", name), primate.tree)
	maxfile <- read.table(sprintf("../output/primate-%s/waic_max-%s.tsv", name, name), sep = "\t", header = TRUE)
	siggroups <- list()
	for (i in 1:nrow(maxfile)) {
		if (maxfile[i,]$max >= .98 && maxfile[i,]$maxcol != 9 && maxfile[i,]$maxcol != 1) {
			siggroups <- c(siggroups, row.names(maxfile[i,]))
		}
	}
	print(sprintf("%s plots to create for %s", length(siggroups), name))
	for (group in siggroups) {
		pdf(sprintf("../plots/primate-%s/%s_plot.pdf", name, group))
		print(group)
		plot_logfoldchange(data, groups, group_name = group, main = sprintf("%s(V%s)", group, maxfile[group,]$maxcol))
		dev.off()
	}
}	
