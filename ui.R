# Load library
library(dplyr)
library(plotly)
library(maps)
library(mapproj)
library(stringr)
library(bslib)


my_theme <- bs_theme(
  bootswatch = "yeti"
)

# Load dataframe
final_data_df <- read.csv("final_data_df.csv")

# Links to datasets
drug_od_deaths <- "https://github.com/BuzzFeedNews/2018-05-fentanyl-and-cocaine-overdose-deaths/blob/master/data/vssr/VSRR_Provisional_Drug_Overdose_Death_Counts.csv"
pov_by_race <- "https://www.kff.org/other/state-indicator/poverty-rate-by-raceethnicity/?dataView=1&currentTimeframe=5&sortModel=%7B%22colId%22:%22Location%22,%22sort%22:%22asc%22%7D"
pop_by_race <- "https://www.kff.org/other/state-indicator/distribution-by-raceethnicity/?dataView=1&currentTimeframe=5&sortModel=%7B%22colId%22:%22Location%22,%22sort%22:%22asc%22%7D"

## OVERVIEW TAB INFO

overview_tab <- tabPanel("Introduction",
   h1("Introduction"),
   p("Rayana Lyons, Nakyoung Kim, Mia Sohn, Brayden Lam"),
   p("Welcome to our exploration into the relationship between poverty and drug overdose deaths in the United States. 
   This project delves into essential questions surrounding the intersection of socio-economic status and public health outcomes, 
   utilizing datasets that weave together vital statistics. Join us in deciphering the narrative that shapes the health outcomes 
   of communities across the United States. Let’s uncover the stories hidden within the numbers."),
   
   h3("Key Questions:"),
   tags$div(tags$ul(
     tags$li("Does a significant correlation exist between poverty rates 
             and the prevalence of drug overdose deaths across diverse states in the U.S.?"),
     tags$li("How do drug overdose deaths manifest across different racial groups, 
             and to what extent does poverty contribute to these variations?"),
     tags$li("What is the number of drug overdose deaths for each state?"),
     tags$li("What is the percentage of people in poverty by race and state?"),
     tags$li("How do the number of drug overdose deaths 
             and total number of people in poverty compare by region?"))),
   
   h3("Dataset at a Glance:"),
   p("The datasets that we used offer a detailed exploration of mortality 
   and poverty dynamics in the United States during 2016. Our compilation uses these three datasets:"),
   p("1. ", a("Drug Overdose Deaths", href = drug_od_deaths)),
   p("2. ", a("People in Poverty Based on Race for each State", href = pov_by_race)),
   p("3. ", a("Population by Race for each State", href = pop_by_race)),
   
   h3("Ethical Considerations:"),
   tags$div(tags$ul(
     tags$li(em("Privacy and Identification:"), "Address potential privacy concerns and the risk of 
     individual or community identification, particularly with race and region data."),
     tags$li(em("Data Accuracy:"),  "Consider the accuracy and reliability of reported death 
             and overdose numbers, ensuring consistency in data collection methods across states."),
     tags$li(em("Ethical Use of Racial Data:"), "Handle racial data with care to avoid reinforcing stereotypes or biases, 
             and address the potential risks of stigmatization or discrimination."),
     tags$li(em("Implications of Poverty Percentage:"), "Ethically interpret and present poverty percentages, 
             considering potential consequences and avoiding misuse of the information."))),
   
   img(src = "poverty_img.jpeg", height = 350, width = 600),

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
  h2("Percent of People who are in Poverty by Race"),
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
  selectInput(
    inputId = "region_select",
    label = "Selected regions to display",
    choices = c("West", "Northeast", "South", "North Central"),
    selected = "West",
    multiple = TRUE
  )
)

viz_3_main_panel <- mainPanel(
  h2("Number of Drug Overdose Deaths and Total Percent of People in Poverty by Region"),
  plotlyOutput(outputId = "region_plot")
)

viz_3_tab <- tabPanel("Deaths and Poverty by Region",
  sidebarLayout(
    viz_3_sidebar,
    viz_3_main_panel
  )
)

## CONCLUSIONS TAB INFO

conclusion_tab <- tabPanel("Conclusion",
 h1("Conclusion"),
 p("some conclusions")
)


ui <- navbarPage("Poverty and Drug Overdose Deaths",
  theme = my_theme,
  overview_tab,
  viz_1_tab,
  viz_2_tab,
  viz_3_tab,
  conclusion_tab
)