# README #

### DESCRIPTION ###

### SETUP ###

We require [R](https://www.r-project.org/) and [Python]() to be installed. For R, we have the following dependencies:

1. [ape](https://cran.r-project.org/web/packages/ape/index.html)
2. [PIGShift](https://cran.r-project.org/web/packages/PIGShift/index.html)

### USAGE ###

1. Download and preprocess the required data files with:

        bash setup.sh

2. Run PIGShift on on each gender and organ from the Brawand, et al. data, with output stored in `output`:

        Rscript run.R

#### ABBREVIATIONS ####

The following abbreviations were used in the Brawand, et al. paper:

* **Species**: human (hsa), chimpanzee (ptr), gorilla (ggo), orangutan (ppy), rhesus monkey (mml), mouse (mmu), gga (chicken), and oan (platypus).
* **Organs**: brain (br), kidney (kd), heart (ht), liver (lv), cerebellum (cb)
