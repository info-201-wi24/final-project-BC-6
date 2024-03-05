# Load library
library(dplyr)
library(plotly)
library(maps)
library(mapproj)
library(stringr)
library(bslib)


# Load dataframe
final_data_df <- read.csv("final_data_df.csv")


server <- function(input, output){
  
  # TODO Make outputs based on the UI inputs here
  # --------------------- Tab 1 --------------------- #
  output$drug_od_plot <- renderPlotly({
    selected_df <- final_data_df %>% filter(State.Name %in% input$state_select)
    
    drug_overdose_plot <- ggplot(selected_df) + 
      geom_col(mapping = aes(
        x = Number.of.Drug.Overdose.Deaths / 6,
        y = State.Name,
        text = paste0("Count: ", Number.of.Drug.Overdose.Deaths),
        fill = State.Name
      )) +
      labs(x = "Number of Drug Overdose Deaths", y = "State")
    return(ggplotly(drug_overdose_plot, tooltip = "text"))
  })
  
  
  # --------------------- Tab 2 --------------------- #
  output$race_plot <- renderPlotly({
    blank_theme <- theme_bw() +
      theme(
        axis.line = element_blank(),        # remove axis lines
        axis.text = element_blank(),        # remove axis labels
        axis.ticks = element_blank(),       # remove axis ticks
        axis.title = element_blank(),       # remove axis titles
        plot.background = element_blank(),  # remove gray background
        panel.grid.major = element_blank(), # remove major grid lines
        panel.grid.minor = element_blank(), # remove minor grid lines
        panel.border = element_blank()      # remove border around plot
      )
    
    if(input$race_select == "Multiple Races"){
      chosen_race <- "multiple_races"
    }
    else{
      chosen_race <- tolower(input$race_select)
    }
    selected_df <- final_data_df %>% filter(race == chosen_race) %>% mutate(State.Name = tolower(State.Name))
    
    state_shape <- map_data("state")
    state_shape <- left_join(selected_df, state_shape, by = c("State.Name" = "region"))
    
    race_pov_plot <- ggplot(data = state_shape) +
      geom_polygon(mapping = aes(
        x = long,
        y = lat,
        group = group,
        text = paste0("State: ", str_to_title(State.Name), "<br>", "Percent in Poverty: ", perc_in_pov),
        fill = perc_in_pov),
        color = "white",
        size = 0.1
      ) +
      coord_map() +
      scale_fill_continuous(low = "White", high = "Dark Green") +
      labs(fill = "Percent in Poverty") +
      blank_theme
    
    return(ggplotly(race_pov_plot, tooltip = "text"))
  })
  
  
  # --------------------- Tab 3 --------------------- #
  output$region_plot <- renderPlotly({
    selected_df <- final_data_df %>% filter(race == "total")
    selected_df <- selected_df %>% filter(region %in% input$region_select)
    region_choice_plot <- ggplot(selected_df) +
      geom_point(mapping = aes(
        x = Number.of.Drug.Overdose.Deaths,
        y = perc_in_pov,
        text = paste0("State: ", State.Name, "<br>",
                      "Number of Drug Overdose Deaths: ", Number.of.Drug.Overdose.Deaths, "<br>",
                      "Percent in Poverty: ", perc_in_pov),
        color = region
      )) +
      labs(x = "Number of Drug Overdose Deaths", y = "Total Percent in Poverty") 
    return(ggplotly(region_choice_plot, tooltip = "text"))
  })
  
  
  
  
}