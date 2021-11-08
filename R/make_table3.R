here::i_am("R/make_table3.R")

load(here::here("data", "crec.RData"))

library(gtsummary)

# table of treatments received by patients
table3 <- crec %>% 
  select(treatment_type) %>% 
  tbl_summary(                                            
    statistic = list(all_continuous() ~ "{mean} ({sd})",        # stats and format for continuous columns
                     all_categorical() ~ "{n} ({p}%)"),         # stats and format for categorical columns
    digits = all_continuous() ~ 1,                              # rounding for continuous columns
    type   = all_categorical(dichotomous = FALSE) ~ "categorical"                  # force all categorical levels to display
    
  ) 

gt::gtsave(as_gt(table3), "table3.png", path = here::here("figs"))

