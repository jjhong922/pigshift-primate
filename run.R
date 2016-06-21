library(PIGShift);
library(ape);
primate.tree = read.tree('data/misc/brawand-et-al-primate-tree.tre');
human.GO = read.groups('data/go/human/human-go-terms.txt');
for (name in c("female-br", "female-cb", "female-ht", "female-kd", "male-br", "male-ht", "male-kd", "male-lv")){
    exp = read.exp(sprintf('data/expression/primate/brawand-et-al/matrices/primate-%s.tsv', name), primate.tree, normalize=0);
    human.GO.pruned = good.groups(colnames(exp), human.GO, 10);
    results = test.groups(primate.tree, exp, human.GO[human.GO.pruned], print_names=T);
    write.table(results$wAIC, sprintf('output/primate-%s/waic.tsv',name));
    write.table(results$alpha, sprintf('output/primate-%s/alpha.tsv',name));
    write.table(results$beta, sprintf('output/primate-%s/beta.tsv',name));
    write.table(results$shift, sprintf('output/primate-%s/shift.tsv',name));
}
