

# extract R code
knitr::purl("vignettes/eatATA.Rmd", output = "data-raw/vignette_r_code.R")


## add unfeasible constraint
infeasible_constr <- itemValuesConstraint(nForms = nForms, nItems = nrow(items), itemValues = rep(1, nrow(items)),
                                          operator = "=", targetValue = nrow(items))

infeasible_gurobi_constr <- list(itemOverlap, mcItems, cmcItems, saItems, openItems,
                      Items1, Items2, Items3, Items4, Items5, excl_constraints,
                      av_time, infeasible_constr)

infeasible_gurobi_rdy <- prepareConstraints(infeasible_gurobi_constr, nForms = nForms, nItems = nItems)


infeas <- capture_output(solver_raw_unfeasible <- gurobi(infeasible_gurobi_rdy, params = list(TimeLimit = 30)))
feas <- capture_output(solver_raw <- gurobi(gurobi_rdy, params = list(TimeLimit = 30)))

## save to extData
saveRDS(feas, "inst/extdata/gurobi_out_feasible.RDS")
saveRDS(infeas, "inst/extdata/gurobi_out_infeasible.RDS")


## save to output to data
gurobiExample <- solver_raw
usethis::use_data(gurobiExample, overwrite = TRUE)
