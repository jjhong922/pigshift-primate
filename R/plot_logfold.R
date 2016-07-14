library(PIGShift, ape)

groups <- read.groups("/Users/jhong/Documents/Berkeley/Research/pigshift-primate/data/go/human/human-go-terms.txt")

for (name in c("female-br", "female-cb", "female-ht", "female-kd", "male-br", "male-ht", "male-kd", "male-lv")) {
	data <- read.table(sprintf("/Users/jhong/Documents/Berkeley/Research/pigshift-primate/data/expression/primate/brawand-et-al/matrices/primate-%s.tsv", name))
	maxfile <- read.table(sprintf("/Users/jhong/Documents/Berkeley/Research/pigshift-primate/output/primate-%s/waic_max-%s.tsv", name, name), sep="\t", header=TRUE)
	siggroups <- list()
	for (i in 1:nrow(maxfile)) {
		if (maxfile[i,]$max >= .98) {
			siggroups <- c(siggroups, row.names(maxfile[i,]))
		}
	}
	print(length(siggroups))
	for (group in siggroups) {
		pdf(sprintf("/Users/jhong/Documents/Berkeley/Research/pigshift-primate/plots/primate-%s/%s_plot.pdf", name, group))
		plot_logfoldchange(data, groups, group_name = group)
		dev.off()
	}
}	
