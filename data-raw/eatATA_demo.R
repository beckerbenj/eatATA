

# https://cran.r-project.org/web/packages/prioritizr/vignettes/gurobi_installation.html
# install.packages("C:/gurobi811/win64/R/gurobi_8.1-1.zip", repos = NULL)
# devtools::install_github("beckerbenj/eatATA")
library(gurobi)
library(eatATA)

# old
items <- as.data.frame(readxl::read_excel(path = "T:/Pauline Kohrt/ATA in VERA3/V3_Pilot19_ZO_Blockbesetzungstabelle_190325.xlsm",
                                          skip = 13), stringsAsFactors = FALSE)

### new (20 minutes per block)
#items <- as.data.frame(readxl::read_excel(path = "T:/Pauline Kohrt/ATA in VERA3/Blockbesetzung_Pilo2021/Blockbesetzungstabelle_blanco_EM_GM.xlsm", skip = 13), stringsAsFactors = FALSE)
#items <- as.data.frame(readxl::read_excel(path = "T:/Pauline Kohrt/ATA in VERA3/Blockbesetzung_Pilo2021/Blockbesetzungstabelle_blanco_EM_MS.xlsm", skip = 13), stringsAsFactors = FALSE)

## Prepare
# ----------------------------------------------------------------
for(ty in c(1:5, "MC", "CMC (MC)", "KA2", "offen")){
  items[, ty] <- ifelse(is.na(items[, ty]), yes = 0, no = 1)
}

n_items <- nrow(items)
f <- 14 ## number of blocks
#N <- 5 ## number of items per tet form
M <- n_items*f+1



## Set constraints
# ----------------------------------------------------------------
# no item overlap,
ItemOverlap <- noItemOverlapConstraint(f, nItems = n_items, sign =0) ## 0 means complete item pool usage

# item types
mcItems <- singleParameterConstraint(nForms = f, nItems = n_items, itemValues = items$MC, tolerance = 0.5)
cmcItems <- singleParameterConstraint(nForms = f, nItems = n_items, itemValues = items$`CMC (MC)`, tolerance = 0.5)
kaItems <- singleParameterConstraint(nForms = f, nItems = n_items, itemValues = items$KA2, tolerance = 0.5)
offenItems <- singleParameterConstraint(nForms = f, nItems = n_items, itemValues = items$offen, tolerance = 0.5)

# difficulty categories
Items1 <- singleParameterConstraint(nForms = f, nItems = n_items, itemValues = items$`1`, tolerance = 0.5)
Items2 <- singleParameterConstraint(nForms = f, nItems = n_items, itemValues = items$`2`, tolerance = 0.5)
Items3 <- singleParameterConstraint(nForms = f, nItems = n_items, itemValues = items$`3`, tolerance = 0.5)
Items4 <- singleParameterConstraint(nForms = f, nItems = n_items, itemValues = items$`4`, tolerance = 0.5)
Items5 <- singleParameterConstraint(nForms = f, nItems = n_items, itemValues = items$`5`, tolerance = 0.5)

# number of items per test form
noItems <- singleParameterConstraint(nForms = f, nItems = n_items, itemValues = rep(1, nrow(items)), tolerance = 0.5)

# item exclusions
items2 <- tidyr::separate(items, col = "Aufgabe", into = c("ID", "name"), sep = "_")
exclusionTuples <- itemExclusionTuples(items2, idCol = "ID", exclusions = "Unverträglichkeiten")
excl_constraints <- itemExclusionConstraint(nForms = 14, exclusionTuples = exclusionTuples, itemIDs = items2$ID)

# optimize average time
av_time <- targetConstraint(f, nItems = n_items, itemValues = matrix(items$`Zeit Aufg.`, nrow = 1), targetValues = 10,
                            thetaPoints = matrix(c(0)))

## Tranfsorm constraints
# ----------------------------------------------------------------
#gurobi_constr <- list(ItemOverlap = ItemOverlap, mcItems = mcItems, av_time = av_time)
#gurobi_constr <- list(ItemOverlap = ItemOverlap, excl_constraints = excl_constraints, av_time = av_time)
gurobi_constr <- list(ItemOverlap = ItemOverlap, mcItems = mcItems, cmcItems, kaItems, offenItems,
                      Items1, Items2, Items3, Items4, Items5, noItems,
                      excl_constraints = excl_constraints,
                      av_time = av_time)
gurobi_rdy <- prepareConstraints(gurobi_constr, M = M, n_items = n_items, f = f)


## Optimization
# --------------------------------------------------------------------------------------------------------
### Set control parameters: minimization problem; integer tolerance is set to 0.1;
### absolute MIP gap is set to 0.01; relative MIP gap is set to 0.05
# -> how to do this in gurobi?

### d) Objective function and solve
solver_raw <- gurobi(gurobi_rdy, params = list(TimeLimit = 30))

solver_raw$objval
length(solver_raw$x)



## Inspect solution (add solution to item properties)
# --------------------------------------------------------------------------------------------------------
processGurobiOutput(gurobiObj = solver_raw, items = items[, c("Aufgabe", "Zeit Aufg.",
                                                              "MC", "CMC (MC)", "KA2", "offen", 1:5)],
                    nForms = f, nItems = n_items, output = "list")

new_items <- processGurobiOutput(gurobiObj = solver_raw, items = items[, c("Aufgabe", "Zeit Aufg.",
                                                                           "MC", "CMC (MC)", "KA2", "offen", 1:5)],
                    nForms = f, nItems = n_items, output = "data.frame")


## save solution (for reimporting into data base)
# --------------------------------------------------------------------------------------------------------
new_items[, paste("Block", 1:f, sep = "_")][new_items[, paste("Block", 1:f, sep = "_")] == 0] <- NA

eatAnalysis::write_xlsx(new_items, filePath = "T:/Pauline Kohrt/ATA in VERA3/eatATA_out3.xlsx",
                        row.names = FALSE)






