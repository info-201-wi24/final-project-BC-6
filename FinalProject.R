# Load libraries
library("dplyr")
library("tidyr")

# Load csv files
deaths_per_year_df <- read.csv("DrugOverdoseCountDataset.csv")
total_pop_df <- read.csv("2016_total_pop_dem.csv")
poverty_count_df <- read.csv("2016_poverty_dem.csv")


# -------------------- Clean total_pop_df and poverty_count_df -------------------- #
# Remove columns for Asian and Hawaiian / Pacific Islander
# due to high numbers of NAs
total_pop_df <- total_pop_df[-c(5, 7)]
poverty_count_df <- poverty_count_df[-5]

# Join total_pop_df and poverty_count_df 
perc_poverty_by_race <- left_join(total_pop_df, poverty_count_df, by = "State.Name")

# Make all numbers numerical
perc_poverty_by_race <- perc_poverty_by_race %>% 
  mutate_at(c(2:13), as.numeric, na.rm = TRUE)

# Get the percentage of poverty by race/ethnicity and
# create numerical columns for each value
perc_poverty_by_race <- perc_poverty_by_race %>% 
  group_by(State.Name) %>% 
  summarize(white = round((White.y / White.x) * 100, digits = 2),
            black = round((Black.y / Black.x) * 100, digits = 2),
            hispanic = round((Hispanic.y / Hispanic.x) * 100, digits = 2),
            native = round((American.Indian.Alaska.Native.y / American.Indian.Alaska.Native.x) * 100, digits = 2),
            multiple_races = round((Multiple.Races.y / Multiple.Races.x) * 100, digits = 2),
            total = round((Total.Poverty / Total) * 100, digits = 2))

# Gather all the percentage in poverty columns into two columns
perc_poverty_by_race <- gather(
  perc_poverty_by_race,
  key = race,
  value = perc_in_pov,
  -State.Name
)

# -------------------- Clean deaths_per_year_df -------------------- #
# Make Data.Value column numeric
deaths_per_year_df$Data.Value <- round(as.numeric(gsub(",","",deaths_per_year_df$Data.Value)), digits = 0)

# Only keep rows that count average total number of deaths and average drug overdose number of deaths
deaths_per_year_df <- 
  deaths_per_year_df[
    deaths_per_year_df$Indicator %in% c("Number of Deaths","Number of Drug Overdose Deaths"),]

# Only keep the number of deaths that was recorded in December
# because the dataset uses 12-month rolling provisional death counts
deaths_per_year_df <- 
  deaths_per_year_df[
    deaths_per_year_df$Month %in% "December",]

# Only keep year 2016
deaths_per_year_df <- 
  deaths_per_year_df[
    deaths_per_year_df$Year %in% 2016,]

# Remove columns 5, 8, 9, 10
deaths_per_year_df <- select(deaths_per_year_df, -4:-5, -8:-10)

# Spread out Indicator column
deaths_per_year_df <- spread(deaths_per_year_df, key = Indicator, value = Data.Value)

# -------------------- Join dataframes -------------------- #
# Join poverty_count_df to deaths_per_year_df
final_data_df <- left_join(deaths_per_year_df, perc_poverty_by_race, by = c("State.Name"))


# -------------------- Clean / Augment final_data_df -------------------- #
# Remove row with United States and New York City
final_data_df <- final_data_df[-c(265:270, 313),]

# Create categorical column to show which region each state is in
state_abbreviations <- state.abb
regions <- state.region
state_region <- data.frame(state = state_abbreviations, region = regions)

final_data_df <- left_join(final_data_df, state_region, by = c("State" = "state"))


# -------------------- Write csv file -------------------- #
#write.csv(final_data_df, file = file.path("final_data_df.csv"))








