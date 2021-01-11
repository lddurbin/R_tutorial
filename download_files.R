library("tidyverse")
library("rvest")

BNB_page <- read_html("https://www.bl.uk/collection-metadata/new-bnb-records")

BNB_urls_hashed <- BNB_page %>% 
  html_nodes("li") %>% 
  html_nodes("a") %>% 
  html_attr("href") %>% 
  str_subset("/bnbrdf_n")

BNB_urls_truncated <- BNB_urls_hashed %>% 
  str_replace("(?<=.zip).*$","")

target_urls <- c("https://www.bl.uk/britishlibrary/~/media/bl/global/services/collection%20metadata/pdfs/bnb%20records%20rdf/bnbrdf_n3618.zip?la=en&hash=AA432EC232641BA593846EB29440A29F", "https://www.bl.uk/britishlibrary/~/media/bl/global/services/collection%20metadata/pdfs/bnb%20records%20rdf/bnbrdf_n3619.zip?la=en&hash=425EF29835CA284A9F7C980BF443E4E8", "https://www.bl.uk/britishlibrary/~/media/bl/global/services/collection%20metadata/pdfs/bnb%20records%20rdf/bnbrdf_n3620.zip?la=en&hash=DC5A0A827772208859EAFF59B8FB3128")
target_files <- basename(target_urls) %>% str_replace("(?<=.zip).*$","")
download.file(target_urls, destfile = paste0("raw data/zipped/", target_files), method = "libcurl")

zipped_files <- list.files("raw data/zipped", pattern = ".zip$", full.names = TRUE)
map_chr(zipped_files, unzip, exdir = "raw data/zipped") %>% 
  map_chr(R.utils::gzip, ext = "gz")
