#!/usr/bin/env Rscript
library(dplyr)

# connecting to SQL takes <20 min compared to 
# API which takes >4 hours
bety_src <- src_postgres(
  dbname = "bety",
  password = 'DelchevskoOro',
  host = 'localhost',
  user = 'viewer',
  port = 5432
)
## if using docker
# bety_src <- src_postgres(
#   dbname = "bety",
#   password = 'bety',
#   host = 'localhost',
#   user = 'bety',
#   port = 5433
#   )

traitsview <- tbl(bety_src, 'traits_and_yields_view')

setwd("~/dev/terraref-dryad/")

seasons <- c("Season 4", "Season 6")
traits <- list(`Season 4` =
  c(
    "aboveground_biomass_moisture",
    "aboveground_dry_biomass",
    "aboveground_fresh_biomass",
    "absorbance_420",
    "absorbance_530",
    "absorbance_605",
    "absorbance_650",
    "absorbance_730",
    "absorbance_850",
    "absorbance_880",
    "absorbance_940",
    "ambient_humidity",
    "anthocyanin_index",
    "canopy_cover",
    "canopy_height",
    "chlorophyll_index",
    "dry_matter_fraction",
    "ECSt",
    "emergence_count",
    "flag_leaf_emergence_time",
    "flavonol_index",
    "flowering_time",
    "FmPrime",
    "FoPrime",
    "Fs",
    "FvP/FmP",
    "gH+",
    "grain_stage_time",
    "harvest_lodging_rating",
    "leaf_angle_alpha",
    "leaf_angle_beta",
    "leaf_angle_chi",
    "leaf_angle_clamp_position",
    "leaf_angle_mean",
    "leaf_desiccation_present",
    "leaf_length",
    "leaf_stomatal_conductance",
    "leaf_temperature",
    "leaf_temperature_differential",
    "leaf_thickness",
    "leaf_width",
    "LEF",
    "light_intensity_PAR",
    "lodging_present",
    "NBI_nitrogen_balance_index",
    "NPQt",
    "panicle_count",
    "panicle_height",
    "panicle_surface_area",
    "panicle_volume",
    "Phi2",
    "PhiNO",
    "PhiNPQ",
    "pitch",
    "plant_basal_tiller_number",
    "planter_seed_drop",
    "proximal_air_temperature",
    "qL",
    "qP",
    "relative_chlorophyll",
    "RFd",
    "roll",
    "seedling_emergence_rate",
    "SPAD_420",
    "SPAD_530",
    "SPAD_605",
    "SPAD_650",
    "SPAD_730",
    "SPAD_850",
    "SPAD_880",
    "stalk_diameter_fixed_height",
    "stalk_diameter_major_axis",
    "stalk_diameter_minor_axis",
    "stand_count",
    "stem_elongated_internodes_number",
    "vH+"),
  `Season 6` =
    c(
    "aboveground_biomass_moisture",
    "aboveground_dry_biomass",
    "aboveground_fresh_biomass",
    "canopy_cover",
    "canopy_height",
    "emergence_count",
    "leaf_angle_alpha",
    "leaf_angle_beta",
    "leaf_angle_chi",
    "leaf_angle_mean",
    "leaf_length",
    "leaf_width",
    "panicle_count",
    "panicle_surface_area",
    "panicle_volume",
    "stalk_diameter_fixed_height"
    ))

sensor_methods <-
  c(
    "Green Canopy Cover Estimation from Field Scanner RGB images",
    "3D scanner to 98th quantile height",
    "Scanner 3d ply data to height",
    "Stereo RGB data to emergence count",
    "3D scanner to leaf angle distribution",
    "3D scanner to leaf length and width",
    "3D scanner to panicle count faster_rcnn + roughness threshold + convex hull",
    "Mean temperature from infrared images"
  )

getcsv <- function(onetrait, oneseason, sensor_methods) {
  season_string <- tolower(gsub(" ", "_", oneseason))
  tmp <- traitsview %>%
    dplyr::filter(grepl(oneseason, sitename) &
                    trait == onetrait &
                    checked >= 0 & access_level >= 2) %>%
    dplyr::select(
      plot = sitename,
#      lat,
#      lon,
      scientificname,
      genotype = cultivar,
      treatment,
      date,
#      time,
#      year,
#      month,
      trait,
      method = method_name,
      mean,
      checked,
#      notes,
      author
    ) %>%
    collect() %>% 
    # rename https://stackoverflow.com/a/45472543/199217
    # dplyr::rename(!!trait := mean) %>%
    dplyr::mutate(
      season = oneseason,
      date = lubridate::ymd(date),
      method_type = if_else(method %in% sensor_methods, 'sensor', 'manual')
    )

  
  for(m in unique(tmp$method_type)){
    tmp2 <- tmp %>% filter(method_type == m)
    if(nrow(tmp2 > 0)){
      readr::write_csv(x = tmp2,
                       path = file.path(
                         'data', 
                         paste0(season_string, "_traits"),
                         paste0(season_string, "_",
                                gsub('/', '_', t), "_",
                                m, '.csv')
                       ))
      
    }
  }
}


for (s in seasons) {
  tr <- traits[[s]]
  for(t in tr){
    print(paste('getting', s, t))
    dt <- system.time(
      getcsv(t, s, sensor_methods) 
    )
    print(paste(t, "took", signif(dt[3], 2), "seconds"))
  }
}

