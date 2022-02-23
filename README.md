# uw-workshop
Repository for workshop given at UW CSDE in February 2022

This repository contains materials for a workshop on __tidycensus__ given at the University of Washington's [Center for Studies in Demography and Ecology](https://csde.washington.edu/) on February 24, 2022.  

To use the workshop materials, you should do one of the following: 

- Users new to R and RStudio should use the pre-built RStudio Cloud environment available at https://rstudio.cloud/project/3626443.  

- Advanced users familiar with R and RStudio should clone the repository to their computers with the command `git clone https://github.com/walkerke/uw-workshop.git`.  They should then install the following R packages, if not already installed:

```r
pkgs <- c("tidycensus", "tidyverse", "tmap", "mapview", "crsuggest")
install.packages(pkgs)
```

Other packages used will be picked up as dependencies of these packages on installation. 
