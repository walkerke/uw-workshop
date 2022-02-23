# Install packages (if necessary)
# install.packages(c("tidycensus", "tidyverse"))

# Load libraries
library(tidycensus)
library(tidyverse)

# Get a Census API key at https://api.census.gov/data/key_signup.html.  
# Activate the key from the link in your email.  
# Now you can get started!
# Restart R after running this line if you plan to install your key.  Otherwise, don't worry 
# about it.  
install <- FALSE
census_api_key("YOUR KEY GOES HERE", install = install)

# Decennial Census data with `get_decennial()`
# 2020 data are available from the PL-94171 redistricting file
wa_pop_2020 <- get_decennial(
  geography = "county",
  variables = "P1_001N",
  state = "WA",
  year = 2020
)

# Either print out the first few rows in your R console:
wa_pop_2020

# Or view the entire dataset in RStudio
View(wa_pop_2020)

# ACS data are available with `get_acs()`.  More variables, but with margins of error.
wa_income <- get_acs(
  geography = "county",
  variables = "B19013_001",
  state = "WA",
  year = 2019
)

View(wa_income)

# The `geography` argument controls the level of data aggregation; see
# https://walker-data.com/census-r/an-introduction-to-tidycensus.html#geography-and-variables-in-tidycensus
# For example, we can get data for school districts in Washington instead:
wa_income_sds <- get_acs(
  geography = "school district (unified)",
  variables = "B19013_001",
  state = "WA",
  year = 2019
)

View(wa_income_sds)

# The `variables` argument takes one or more Census variable codes.  How to identify them?
# `load_variables()` fetches a dataset of Census variables for a given year and dataset.
# For the detailed tables:
acs_detailed <- load_variables(2019, "acs5")
# For the Data Profile (pre-computed data): 
acs_profile <- load_variables(2019, "acs5/profile")

View(acs_profile)

# The `state` and `year` arguments get data for different locations and time periods
# Be careful: DP variables change from year to year!
lane_income_14 <- get_acs(
  geography = "tract",
  variables = "B19013_001",
  state = "OR",
  county = "Lane",
  year = 2014
)

# Tables of Census or ACS data can be requested with a `table` argument
# For the ACS, use the characters that precede the underscore for the table ID
wa_income_brackets <- get_acs(
  geography = "county",
  table = "B19001",
  state = "WA",
  year = 2019
)

# Some analysts prefer data with variables spread across the columns;
# you can get this format with `output = "wide"`
wa_income_wide <- get_acs(
  geography = "county",
  table = "B19001",
  state = "WA",
  year = 2019,
  output = "wide"
)

# tidycensus outputs (long or wide) can be analyzed with tidyverse tools
# Example: create a new column, "Percent of households earning over $200k"
wa_200k <- wa_income_wide %>%
  mutate(percent_200k = 100 * (B19001_017E / B19001_001E)) %>%
  select(GEOID, NAME, percent_200k) %>%
  arrange(desc(percent_200k))

# Output can be visualized with the popular ggplot2 package, part of the tidyverse
ggplot(wa_200k, aes(x = NAME, y = percent_200k)) + 
  geom_col()

# Not great! Let's clean it up:
wa_200k %>%
  mutate(NAME = str_remove(NAME, " County, Washington")) %>%
  ggplot(aes(x = percent_200k, y = reorder(NAME, percent_200k))) + 
  geom_col(fill = "#4b2e83", alpha = 0.8) + 
  theme_minimal(base_size = 12) + 
  labs(title = "Percent of households earning $200k or more",
       subtitle = "Counties in Washington",
       caption = "Data source: 2015-2019 American Community Survey",
       x = "ACS estimate (percent)",
       y = "")

# Exercises
# 1. Look up variables from the 2020 decennial Census with 
# `load_variables(2020, "pl")`.
#g
# 2. Get a dataset with information on total population and the Hispanic population 
# from the 2020 decennial Census for counties in Washington using appropriate 
# Census variable IDs and `get_decennial()`. 
#
# 3. Bonus: try to adapt the code above to find out which county in 
# Washington has the largest Hispanic share of its population in 2020.  
# We'll review after the break!
  