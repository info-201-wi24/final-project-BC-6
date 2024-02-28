# Load library
library(dplyr)
library(plotly)
library(maps)
library(mapproj)
library(stringr)

# Load dataframe
final_data_df <- read.csv("final_data_df.csv")

## OVERVIEW TAB INFO

overview_tab <- tabPanel("Introduction",
   h1("Introduction"),
   p("some explanation")
)

## VIZ 1 TAB INFO

viz_1_sidebar <- sidebarPanel(
  #h2("Options for graph"),
  #TODO: Put inputs for modifying graph here
  selectInput(
    inputId = "state_select",
    label = "Selected states to display",
    choices = final_data_df$State.Name,
    selected = "Washington",
    multiple = TRUE
  )
)

viz_1_main_panel <- mainPanel(
  h2("Drug Overdose Deaths Across the United States"),
  plotlyOutput(outputId = "drug_od_plot")
)

viz_1_tab <- tabPanel("Drug Overdose Deaths",
  sidebarLayout(
    viz_1_sidebar,
    viz_1_main_panel
  )
)

## VIZ 2 TAB INFO

viz_2_sidebar <- sidebarPanel(
  #h2("Options for graph"),
  #TODO: Put inputs for modifying graph here
  radioButtons(
    inputId = "race_select",
    label = "Select a race",
    choices = c("White", "Black", "Hispanic", "Multiple Races"),
    #selected = "hispanic",
    inline = TRUE
  )
  
)

viz_2_main_panel <- mainPanel(
  h2("Vizualization 2 Title"),
  plotlyOutput(outputId = "race_plot")
)

viz_2_tab <- tabPanel("Poverty by Race",
  sidebarLayout(
    viz_2_sidebar,
    viz_2_main_panel
  )
)

## VIZ 3 TAB INFO

viz_3_sidebar <- sidebarPanel(
  #h2("Options for graph"),
  #TODO: Put inputs for modifying graph here
)

viz_3_main_panel <- mainPanel(
  h2("Vizualization 3 Title"),
  # plotlyOutput(outputId = "your_viz_1_output_id")
)

viz_3_tab <- tabPanel("Viz 3 tab title",
  sidebarLayout(
    viz_3_sidebar,
    viz_3_main_panel
  )
)

## CONCLUSIONS TAB INFO

conclusion_tab <- tabPanel("Conclusion",
 h1("Some title"),
 p("some conclusions")
)



ui <- navbarPage("Poverty and Drug Overdose Deaths",
  overview_tab,
  viz_1_tab,
  viz_2_tab,
  viz_3_tab,
  conclusion_tab
)