# ---- Load ----
library(tidyverse)
library(sf)
library(rmapshaper)
library(lobstr)
library(devtools)

# Load package
load_all(".")

# Set query url
query_url <-
  query_urls %>%
  filter(data_set == "soa") %>%
  pull(query_url)

soa <-
  read_sf(query_url) %>%
  st_transform(crs = 4326)

# Select and rename vars
soa <-
  soa %>%
  select(
    soa_name = SOA_LABEL,
    soa_code = SOA_CODE,
    geometry
  )

# Make sure geometries are valid
soa <- st_make_valid(soa)

# Simplify shape to reduce file size
soa <- ms_simplify(soa)

# Check geometry types are homogenous
if (soa %>%
  st_geometry_type() %>%
  unique() %>%
  length() > 1) {
  stop("Incorrect geometry types")
}

if (soa %>%
  st_geometry_type() %>%
  unique() != "MULTIPOLYGON") {
  stop("Incorrect geometry types")
}

# Check object is below 50Mb GitHub warning limit
if (obj_size(soa) > 50000000) {
  stop("File is too large")
}

# Rename
boundaries_soa <- soa

# Save output to data/ folder
usethis::use_data(boundaries_soa, overwrite = TRUE)