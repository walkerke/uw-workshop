# Exercises answer:
library(tidycensus)
library(tidyverse)

vars2020 <- load_variables(2020, "pl")

wa_2020 <- get_decennial(
  geography = "county",
  state = "WA",
  variables = c("P2_001N", "P2_002N"),
  year = 2020,
  output = "wide"
)

wa_pct_hispanic <- wa_2020 %>%
  mutate(percent_hispanic = 100 * (P2_002N / P2_001N)) %>%
  arrange(desc(percent_hispanic))

# tigris and county "geometry"
library(tigris)

# cb = TRUE gives us the cartographic boundary shapefile, which is pre-clipped to the US
# shoreline and better for thematic mapping
wa_counties <- counties("WA", cb = TRUE, year = 2020) 

plot(wa_counties$geometry)

# Browse interactively with mapview
library(mapview)

mapview(wa_counties)

# tidycensus integrates tigris automatically - no need for joining!
# Use the argument `geometry = TRUE`
wa_2020_geo <- get_decennial(
  geography = "county",
  state = "WA",
  variables = c(total_pop = "P2_001N", 
                hispanic = "P2_002N"),
  year = 2020,
  output = "wide",
  geometry = TRUE
) %>%
  mutate(percent_hispanic = 100 * (hispanic / total_pop))

# ggplot2 can map this data with `geom_sf()`
# We'll focus here on the tmap package, which offers a familiar interface to GIS users
# We initialize a map with `tm_shape()`, then specify how to draw the data with `tm_polygons()`:
library(tmap)

tm_shape(wa_2020_geo) + 
  tm_polygons()

# A choropleth map can be rendered by specifying a column to map:
tm_shape(wa_2020_geo) + 
  tm_polygons(col = "percent_hispanic")

# We'll likely want to do some customization. Let's change the colors
# and move the legend outside the map frame:
tm_shape(wa_2020_geo) + 
  tm_polygons(col = "percent_hispanic", palette = "Purples",
              title = "% Hispanic, 2020") + 
  tm_layout(legend.outside = TRUE)

# We can also modify map elements for clarity and change
# the breaks from "pretty" (the default) to Jenks natural breaks
# (the default in ArcGIS)
tm_shape(wa_2020_geo) + 
  tm_polygons(col = "percent_hispanic", palette = "Purples",
              title = "% Hispanic, 2020", style = "jenks") + 
  tm_layout(legend.outside = TRUE, bg.color = "grey80")

# Alternative map types are also available, like graduated symbols:
tm_shape(wa_2020_geo) + 
  tm_polygons() + 
  tm_bubbles(size = "hispanic", 
             col = "navy",
             alpha = 0.5,
             scale = 3,
             title.size = "Hispanic residents, 2020") + 
  tm_layout(legend.outside = TRUE,
            legend.outside.position = "bottom")

# To automatically convert to an interactive map, use `tmap_mode("view")`
tmap_mode("view")

tm_shape(wa_2020_geo) + 
  tm_polygons(col = "percent_hispanic", palette = "Purples",
              title = "% Hispanic, 2020", alpha = 0.5) + 
  tm_layout(legend.outside = TRUE)

# Advanced workflow: King County geometries
king_income <- get_acs(
  geography = "tract",
  variables = "B19013_001",
  state = "WA",
  county = "King",
  geometry = TRUE
)

mapview(king_income)

# New feature: `erase_water()`!
library(sf)

# Transform to a State Plane coordinate reference system
# (Washington North - EPSG code 6596)
# then erase the largest water areas in the county (area percentile 90 percent and up)
king_income_erased <- king_income %>%
  st_transform(6596) %>%
  erase_water(area_threshold = 0.9)

# Our map should now look much better!
tm_shape(king_income_erased) + 
  tm_polygons(col = "estimate", palette = "viridis",
              alpha = 0.6)

# Exercises:
# 1. Use your knowledge gained in both parts of this workshop to get spatial Census data for a different location and different Census variable with tidycensus.
# 2. Make a static map of that data with tmap.
# 3. Make an interactive map of that data with tmap as well!


