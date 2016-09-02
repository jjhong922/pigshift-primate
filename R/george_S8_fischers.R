library(PIGShift)
library(ape)

prevdir <- getwd()
setwd("/Users/jhong/Documents/Berkeley/Research/pigshift-primate/R")
seq_data <- read.table("../seq_data/george_TableS8.tsv", sep = "\t", fill = TRUE, row.names = NULL)
sigterms <- read.table("../sigGOterms.tsv", sep = "\t", fill = TRUE, stringsAsFactors = FALSE)
GOterms <- read.groups("../data/go/human/human-go-terms.txt")

pvals <- data.frame(group = character(nrow(sigterms)), nsiggenes = numeric(nrow(sigterms)), 
                    ngenes = numeric(nrow(sigterms)), pval = numeric(nrow(sigterms)), 
                    sig = logical(nrow(sigterms)), stringsAsFactors = FALSE)

#finding numbers for all humanGOterms
sigSeqTerms <- seq_data[seq_data$QVAL < 0.2,]$GENE_NAME
uniques <- unique(unlist(GOterms, use.names = FALSE))
sigUniques <- intersect(uniques, sigSeqTerms)
print(sprintf("%s significant genes out of %s total genes.", length(sigUniques), length(uniques)))

#for loop to find pvals for each term
for (i in 1:nrow(sigterms)) {
  genes <- GOterms[[sigterms[i,"GO_terms"]]]
  fmatrix <- matrix(nrow = 2, ncol = 2)
  fmatrix[1,] <- c(length(sigUniques), length(uniques))
  fmatrix[2,1] <- c(length(intersect(genes, sigSeqTerms)))
  fmatrix[2,2] <- c(length(genes))
  pvals[i,] <- c(sigterms[i,"GO_terms"], fmatrix[2,1], fmatrix[2,2],
                 fisher.test(fmatrix)[["p.value"]], sigterms[i,"sig"] == 1)
}

write.table(pvals, file = "../seq_data/george_S8_fischers_pvals.tsv", sep = "\t")
setwd(prevdir)
print("Script complete.")

