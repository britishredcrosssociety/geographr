# ---- Load ----
library(tidyverse)
library(devtools)

# Load package
load_all(".")

# Set query url
query_url <-
  query_urls %>%
  filter(data_set == "lsoa_msoa") %>%
  pull(query_url)

lsoa_msoa <-
  read_csv(query_url)

# Select and rename vars
lsoa_msoa <-
  lsoa_msoa %>%
  select(
    lsoa_name = LSOA11NM,
    lsoa_code = LSOA11CD,
    msoa_name = MSOA11NM,
    msoa_code = MSOA11CD
  ) %>%
  distinct()

# Rename
lookup_lsoa_msoa <- lsoa_msoa

# Save output to data/ folder
usethis::use_data(lookup_lsoa_msoa, overwrite = TRUE)
