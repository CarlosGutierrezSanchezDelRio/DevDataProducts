
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
set.seed(9)

shinyUI(fluidPage(

  # Application title
  titlePanel("Return on investment of a sample photovoltaic system. Carlos Gutierrez Sanchez Del Rio. 2016"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      submitButton('Submit'),
      
      sliderInput("Capacity",
                  "Installed system capacity in megawatts-peak (MWp):",
                  min = 5,
                  max = 150,
                  value = 30,
                  step = 5),
    
      numericInput("Capex",
                "Overnight system price in USDmillion/MWp:",
                min = 0.5,
                max = 5,
                value = 1.2,
                step = 0.1),
      
      numericInput("Opex",
                   "Annual Maintenance Costs USD/MWp/year:",
                   min = 10000,
                   max = 80000,
                   value = 25000,
                   step = 5000),
      
      sliderInput("FLEH", 
                  label = "First year Full Load Equivalent Hours in MWh/MWp P90-P50 range:",
                  min = 500, max = 3000, value = c(1800, 2400),step=100),
      
      sliderInput("Degradation",
                   "Annual degradation in %/year:",
                   min = 0,
                   max = 2,
                   value = 0.5,
                   step = 0.05,
                   pre="%"),
      
      numericInput("Tariff",
                   "Feed-in Tariff for year 1 in USD/MWh:",
                   min = 10,
                   max = 200,
                   value = 65,
                   step = 5),
      
      sliderInput("AssetLife",
                  "Asset Life in Years:",
                  min = 15,
                  max = 35,
                  value = 25,
                  step = 5),
      
      numericInput("Tax_Rate",
                   "Applicable Corporate Tax Rate (%):",
                   min = 0,
                   max = 100,
                   value = 30,
                   step = 5),
      
      numericInput("Inflation_Rate",
                   "Applicable Inflation Rate for Opex and Tariff (%):",
                   min = 0,
                   max = 20,
                   value = 2,
                   step = 0.5),
      
      sliderInput("WACC",
                  "Cost of Capital (%):",
                  min = 0,
                  max = 20,
                  value = 5,
                  step = 0.5,
                  pre="%")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      fluidRow(
        img(src='solar.png', align = "right", width=100),
        column(8,plotOutput("distPlot")),
        column(12,plotOutput("FCFPlot"))
      )
    )
  )
))
