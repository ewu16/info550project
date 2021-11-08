here::i_am("R/clean_data.R")

library(tidyverse)
library(janitor)
library(lubridate)
library(labelled)


#colorectal data previously downloaded from "https://data.mendeley.com/public-files/datasets/vvzw3wkx93/files/bbb9836d-8f6e-473d-8b10-f55685cedc2a/file_downloaded"
colorectal <- read.csv(here::here("raw_data", "colorectal.csv"), sep = ";")


#clean up data
crec <- colorectal %>% 
  
  #format variable names
  janitor::clean_names() %>%
  
  #variables I want to keep
  select(age, sex, m_status, edu_status, region,
         hist_type, location, tnm_stage, clinical_stage, cea_baseline, 
         chemotherapy, surgery, radiotherapy, 
         date_dx, date_death, vstatus) %>%
  
  #calculate time from diagnosis to death/censoring
  mutate(date_dx = lubridate::as_date(date_dx, format = "%m/%d/%Y"),
         date_death = lubridate::as_date(date_death, format = "%m/%d/%Y"),
         time = round(as.duration(date_dx %--% date_death) / dmonths(1))) %>%
  
  #create variable to describe overall treatment
  mutate(treatment_type = case_when(
    chemotherapy == 1 & surgery == 1 & radiotherapy == 1 ~ "Surgery and Chemotherapy and Radiotherapy",
    chemotherapy == 1 & surgery == 1 & radiotherapy == 0 ~ "Surgery and Chemotherapy only",
    chemotherapy == 1 & surgery == 0 & radiotherapy == 1 ~ "Chemotherapy and Radiotheraapy  only",
    chemotherapy == 1 & surgery == 0 & radiotherapy == 0 ~ "Chemotherapy only",
    chemotherapy == 0 & surgery == 1 & radiotherapy == 1 ~ "Surgery and Radiotheraapy  only",
    chemotherapy == 0 & surgery == 1 & radiotherapy == 0 ~ "Surgery only",
    chemotherapy == 0 & surgery == 0 & radiotherapy == 1 ~ "Radiotheraapy  only",
    chemotherapy == 0 & surgery == 0 & radiotherapy == 0 ~ "No treatment"
  ),
  
  treatment_cat = fct_collapse(factor(treatment_type), 
                               no_surg = c("No treatment", "Chemotherapy only"),
                               surg = c("Surgery only", "Surgery and Radiotheraapy  only"),
                               chemo_plus_surg = c("Surgery and Chemotherapy only", 
                                                   "Surgery and Chemotherapy and Radiotherapy")) %>%
                  fct_relevel("no_surg", "surg", "chemo_plus_surg")) %>%
  
  mutate(region = ifelse(region == "Addis Ababa", 1, 0)) %>%
  
  #label variables and values for better printed outputs with gtsummary tables
  set_variable_labels(
    age = "Age",
    sex = "Sex", 
    m_status = "Marital Status",
    edu_status = "Educational Status",
    region = "Residence Region",
    hist_type = "Histologic Type", 
    location = "Tumor Location",
    tnm_stage = "Tumor Stage",
    clinical_stage = "Clinical Stage",
    cea_baseline = "Baseline CEA", 
    chemotherapy = "Chemotherapy", 
    surgery = "Surgery", 
    radiotherapy = "Radiotherapy",
    treatment_type = "Treatment Received") %>%
  
  set_value_labels(
    sex = c(Male = 0, Female = 1),
    m_status = c(Single = 1, Married = 2, Widowed = 3, Divorced = 4),
    edu_status = c("No formal education" = 1, "Primary Level" = 2, "Secondary" = 3, "Higher education" = 4),
    region = c("Addis Ababa" = 1, "Out of Addis Ababa" = 0),
    location = c(Colon = 1, "Recto-sigmoid junction" = 2, Rectum = 3, Anorectal = 4),
    tnm_stage = c(T1 = 1, T2 = 2, T3 = 3, T4 = 4),
    clinical_stage = c("Localized" = 1, "Locally advanced" = 2, "Metastasis" = 3),
    hist_type = c("Adenocarcinoma NOS" = 1, "Mucinous/Signet-ring cell carcinoma" = 2),
    cea_baseline = c("Not Elevated (<5 ng/ml)" = 0, "Elevated (>=5 ng/ml)" = 1),
    chemotherapy = c(No = 0, Yes = 1),
    surgery  = c(No = 0, Yes = 1),
    radiotherapy = c(No = 0, Yes = 1)) %>%
  
  #convert certain variables to factors
  mutate_at(vars(c(sex, m_status, edu_status, region, hist_type, location, tnm_stage, clinical_stage,  cea_baseline, chemotherapy, surgery, radiotherapy)), to_factor) %>%
  
  #only 5 stage 1 cancers, so combine stage 1 and 2 cancers for later analysis
  mutate(tnm_stage_combined = fct_collapse(tnm_stage, "T1 and T2" = c("T1","T2")))

save(crec, file = here::here("data", "crec.RData"))
