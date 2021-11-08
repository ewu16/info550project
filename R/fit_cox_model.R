here::i_am("R/fit_cox_model.R")

library(survival)
library(gtsummary)

load(here::here("data", "crec.RData"))

#multivariate Cox model
model <- coxph(Surv(time, vstatus) ~ 
                 age + sex + tnm_stage_combined + hist_type + cea_baseline + chemotherapy + surgery + radiotherapy,
               data = crec)

#table of estimated hazard ratios 
model_table <- tbl_regression(model, exponentiate = TRUE)

gt::gtsave(as_gt(model_table), "cox_regression_table.png", path = here::here("figs"))