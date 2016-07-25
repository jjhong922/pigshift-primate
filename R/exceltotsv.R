sigterms <- read.table("../sigGOterms.tsv", sep = "\t")
colnames(sigterms) <- unlist(sigterms[1,])
sigterms <- sigterms[-1,]
write.table(sigterms, file = "../sigGOterms.tsv", sep = "\t")