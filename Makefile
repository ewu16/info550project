## report.html			: Generate final analysis report.
report.html: Rmd/report.Rmd figs/table1.png figs/table2.png figs/table3.png \
							figs/kaplan_meier_plot.png figs/cox_regression_table.png
	Rscript -e "rmarkdown::render('Rmd/report.Rmd')"

## crec.RData			: Clean raw_data/colorectal.csv 
data/crec.RData: R/clean_data.R raw_data/colorectal.csv
	Rscript R/clean_data.R

# rule for making descriptive tables
figs/%.png: make_%.R data/crec.RData
	Rscript R/$*.R

## descriptive_tables		: Make three descriptive tables.
## 	table1.png		(1) Patient Sociodemographics, 
## 	table2.png 		(2) Patient Cancer Types
## 	table3.png 		(3) Cancer Treatment Received
# PHONY rule for all descriptive tables
.PHONY: descriptive_tables
	descriptive_tables: table1.png table2.png table3.png

## kaplan_meier_plot.png		: Kaplan Meier plot for overall cancer survival
figs/kaplan_meier_plot.png: R/plot_KM_curve.R data/crec.RData
	Rscript R/plot_KM_curve.R

## cox_regression_table.png	: Make table of hazard ratios from cox model
figs/cox_regression_table.png: R/fit_cox_model.R data/crec.RData
	Rscript R/fit_cox_model.R

.PHONY: help
help: Makefile
	@sed -n 's/^##//p' $<