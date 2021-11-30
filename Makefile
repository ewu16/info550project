## report.html			: Generate final analysis report.
output/report.html: Rmd/report.Rmd figs/table1.png figs/table2.png figs/table3.png \
				 figs/kaplan_meier_plot.png figs/cox_regression_table.png
	Rscript -e "rmarkdown::render('Rmd/report.Rmd')"
	mv Rmd/report.html output/report.html

## crec.RData			: Clean raw_data/colorectal.csv 
data/crec.RData: R/clean_data.R raw_data/colorectal.csv
	Rscript R/clean_data.R


## table1.png		:(1) Patient Sociodemographics
figs/table1.png: R/make_table1.R data/crec.RData
	Rscript R/make_table1.R

## table2.png		:(2) Patient Cancer Types
figs/table2.png: R/make_table2.R data/crec.RData
	Rscript R/make_table2.R

## table3.png 		:(3) Cancer Treatment Received
figs/table3.png: R/make_table3.R data/crec.RData
	Rscript R/make_table3.R


## kaplan_meier_plot.png		: Kaplan Meier plot for overall cancer survival
figs/kaplan_meier_plot.png: R/plot_KM_curve.R data/crec.RData
	Rscript R/plot_KM_curve.R

## cox_regression_table.png	: Make table of hazard ratios from cox model
figs/cox_regression_table.png: R/fit_cox_model.R data/crec.RData
	Rscript R/fit_cox_model.R

## clean:		Remove compiled report, cleaned data, and figures
clean:
	rm output/report.html data/crec.RData figs/table1.png figs/table2.png figs/table3.png figs/kaplan_meier_plot.png figs/cox_regression_table.png

.PHONY: help
help: Makefile
	@sed -n 's/^##//p' $<