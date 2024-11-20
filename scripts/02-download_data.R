#### Preamble ####
# Purpose: Downloads and saves the data from Federal Reserve of US government 
# Author: Wen Han Zhao
# Date: 1 December 2024 
# Contact: youna.zhao@mail.utoronto.ca
# License: MIT
# Pre-requisites: None


#### Workspace setup ####
library(tidyverse)
library(haven)
library(arrow)

#### Define a function to download the file ####
scf_dta_import <-
  function(this_url) {
    this_tf <- tempfile()
    
    download.file(this_url , this_tf , mode = 'wb')
    
    this_tbl <- read_dta(this_tf)
    
    this_df <- data.frame(this_tbl)
    
    file.remove(this_tf)
    
    names(this_df) <- tolower(names(this_df))
    
    this_df
  }

#### Download data ####
raw_scf_data <- scf_dta_import("https://www.federalreserve.gov/econres/files/scfp2022s.zip")

#### Save data ####
write_parquet(raw_scf_data, "data/01-raw_data/raw_data.parquet") 

         
