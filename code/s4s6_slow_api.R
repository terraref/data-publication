#!/usr/bin/env Rscript

# this takes 4+ hours
# much quicker to use sql

library(traits)
options(betydb_url = "https://terraref.org/bety/",
        betydb_api_version = 'v1',
        betydb_key = readLines('~/.betykey', warn = FALSE))

## Get all Season 4 data
traits <-   c("planter_seed_drop", "FmPrime", "harvest_lodging_rating", "LEF", "canopy_height", "dry_matter_fraction", 
  "ECSt", "grain_stage_time", "absorbance_605", "leaf_angle_mean", "leaf_angle_chi", "pitch", "panicle_surface_area", "stalk_diameter_major_axis", "gH+", "FoPrime", "panicle_volume", "aboveground_fresh_biomass", "relative_chlorophyll", "emergence_count", "roll", "leaf_length", "aboveground_dry_biomass", "chlorophyll_index", 
  "FvP/FmP", "PhiNPQ", "absorbance_850", "leaf_desiccation_present", "stem_elongated_internodes_number", "Fs", "leaf_thickness", "absorbance_650", "leaf_angle_beta", "leaf_angle_alpha", "SPAD_650", "light_intensity_PAR", "panicle_height", "SPAD_880", "NBI_nitrogen_balance_index", "SPAD_850", "SPAD_730", "leaf_width", "stand_count", "absorbance_530", "absorbance_940", "seedling_emergence_rate", "lodging_present", "NPQt", "RFd", "qP", "SPAD_605", "leaf_temperature", "flavonol_index", "vH+", "ambient_humidity", "plant_basal_tiller_number", "qL", "stalk_diameter_fixed_height", "anthocyanin_index", "absorbance_880", "leaf_angle_clamp_position", "proximal_air_temperature", "flowering_time", "aboveground_biomass_moisture", "leaf_temperature_differential", "absorbance_420", "canopy_cover", "absorbance_730", "SPAD_530", "SPAD_420", "stalk_diameter_minor_axis", "leaf_stomatal_conductance", "flag_leaf_emergence_time", "panicle_count", "PhiNO", "Phi2")
#48809
#49052
#53243
#53205
#53369
for(t in traits){
  print(paste0("downloading ", t))
  tt <- system.time(
    tmp <- betydb_query(sitename = '~Season 4', limit = 'none', trait = t)
    )
  print(paste0(t, ' has ', nrow(tmp), ' records ', ' and took ', round(tt[3]/60, 3), ' minutes to download'))
  readr::write_csv(x = tmp, path = file.path('data/season_4_traits', 
                                             paste0('season_4_',gsub('/','_',t),'.csv')))
}

print("done with season 4")

## get all season 6 data


traits <-   c(#"leaf_angle_mean", "leaf_angle_chi", "panicle_surface_area", "panicle_volume", 
  # "aboveground_fresh_biomass", "surface_temperature", 
  "canopy_height", "leaf_angle_beta", "emergence_count", "leaf_angle_alpha", "leaf_length", "stalk_diameter_fixed_height", "aboveground_dry_biomass", "panicle_count", "aboveground_biomass_moisture", "canopy_cover", "leaf_width")
for(t in traits){
  print(paste0("downloading ", t))
  tt <- system.time(
    tmp <- betydb_query(sitename = '~Season 6', limit = 'none', trait = t)
  )
  print(paste0(t, ' has ', nrow(tmp), ' records ', ' and took ', round(tt[3]/60, 3), ' minutes to download'))
  readr::write_csv(x = tmp, path = file.path('data/season_6_traits/', 
                                             paste0('season_6_',t,'.csv')))
}
print("done with season 6")