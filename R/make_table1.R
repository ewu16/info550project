here::i_am("R/make_table1.R")

load(here::here("data", "crec.RData"))

library(gtsummary)

# table of sociodemographic characteristics of patients (age, sex, marital status, region of residence)
# with mean (sd) for continuous variables and n (%) for categorical variables
table1 <- crec %>% 
  select(age, sex, edu_status, m_status, region) %>% 
  tbl_summary(                                                 
    statistic = list(all_continuous() ~ "{mean} ({sd})",        # stats and format for continuous columns
                     all_categorical() ~ "{n} ({p}%)"),         # stats and format for categorical columns
    digits = all_continuous() ~ 1,                              # rounding for continuous columns
    type   = all_categorical(dichotomous = FALSE) ~ "categorical"                  # force all categorical levels to display
  ) 

gt::gtsave(as_gt(table1), "table1.png", path = here::here("figs"))

