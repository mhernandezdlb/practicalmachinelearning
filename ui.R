library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Data Input"),
    sidebarLayout(
        sidebarPanel(
            sliderInput("Press","Pick Min and Max Pressure:",
                        min = 0,
                        max = 5000,
                        value = c(100,4000),
                        step = 100
            ),
            sliderInput("Temp","Pick Min and Max Temperature:",
                        min = 0,
                        max = 300,
                        value = c(80,215),
                        step = 10
            ),
            sliderInput("Depth","Indicate Depth:",
                        min = 1000,
                        max = 10000,
                        value = 5000,
                        step = 100
            ),
            sliderInput("nodes","Nodes:",
                        min = 10,
                        max = 100,
                        value = 20,
                        step = 10
            ),
            sliderInput("coeff", "Corrosion Inhibitor Efficiency:",
                        min = 0,
                        max = 100,
                        value = 50,
                        step = 1
            ),
            sliderInput("id",
                        "Internal Diameter:",
                        min = 0.1,
                        max = 5,
                        value = 2.992,
                        step = 0.001
            ),
            sliderInput("co2",
                        "CO2 Percentage:",
                        min = 0,
                        max = 100,
                        value = 2,
                        step = 1
            ),
            sliderInput("carbon",
                        "Carbon Content Percentage:",
                        min = 0,
                        max = 1,
                        value = 0.38,
                        step = 0.01
            ),
            sliderInput("chrome",
                        "Chrome Content Percentage:",
                        min = 0,
                        max = 1,
                        value = 0.15,
                        step = 0.01
            ),
            sliderInput("water",
                        "Water Rate:",
                        min = 0,
                        max = 10000,
                        value = 4000,
                        step = 100
            )
    ),
        mainPanel(
            h3("Corrosion Profile"),
            plotOutput("contents"),
            textOutput("documentation")
        )
    )
))

