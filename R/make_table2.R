here::i_am("R/make_table2.R")

load(here::here("data", "crec.RData"))

library(gtsummary)

# table of pathological/clinical characteristics of patients
# with mean (sd) for continuous variables and n (%) for categorical variables
table2  <- crec %>% 
  select(hist_type, location, tnm_stage, clinical_stage) %>% 
  tbl_summary(                                           
    statistic = list(all_continuous() ~ "{mean} ({sd})",        # stats and format for continuous columns
                     all_categorical() ~ "{n} ({p}%)"),         # stats and format for categorical columns
    digits = all_continuous() ~ 1,                              # rounding for continuous columns
    type   = all_categorical(dichotomous = FALSE) ~ "categorical"                  # force all categorical levels to display
  ) 

gt::gtsave(as_gt(table2), "table2.png", path = here::here("figs"))

