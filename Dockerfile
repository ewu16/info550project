FROM rocker/tidyverse


# install R packages like this
# put as close to top of script as possible to make best 
# use of caching and speed up builds

RUN R -e "install.packages('janitor', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "install.packages('lubridate', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "install.packages('survival', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "install.packages('survminer', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "install.packages('gtsummary', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "install.packages('labelled', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "install.packages('webshot', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "install.packages('here', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "webshot::install_phantomjs()"


# make a project directory in the container
# we will mount our local project directory to this directory
RUN mkdir /project


# copy contents of local folder to project folder in container
COPY ./ /project/

WORKDIR /project
RUN R -e "renv::deactivate()"

# make R scripts executable
RUN chmod +x /project/R/*.R

# make container entry point bash
CMD make output/report.html 