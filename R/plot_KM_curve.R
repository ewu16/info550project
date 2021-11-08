here::i_am("R/plot_KM_curve.R")

library(survival)
library(survminer)

load(here::here("data", "crec.RData"))

#plot overall survival curve
kmfit <- survfit(Surv(time, vstatus) ~ 1, data = crec)

kmplot <- survminer::ggsurvplot(
                    fit = kmfit , 
                    #risk.table = TRUE,
                    xlab = "Months", 
                    ylab = "Overall Survival probability")

ggsave(here::here("figs", "kaplan_meier_plot.png"), width = 4, height = 4)