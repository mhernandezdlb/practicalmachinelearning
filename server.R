#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)

# Define server logic required to draw a plot
shinyServer(function(input, output) {
    
    data <- reactive({
        Depth <- seq(0,input$Depth,length = input$nodes)
        PressGrad <- (input$Press[2]-input$Press[1])/input$Depth
        Pressure <- (Depth*PressGrad)+input$Press[1]
        TempGrad <- (input$Temp[2]-input$Temp[1])/input$Depth
        Temperature <- (Depth*TempGrad)+input$Temp[1]
        data <- data.frame(Depth, Pressure, Temperature)
        data
    })
    
    output$contents <- renderPlot({
        
        C_Inhibitor <- input$coeff
        tubing_id <- input$id
        Co2_percentage <- input$co2
        Fluid_rate <- input$water
        carbon_content <-input$carbon
        chrome_content <- input$chrome
        
        x <- data()
        x<- x %>% mutate(Depth_ft = Depth,
                         Temperature_F = Temperature,
                         Pressure_psi = Pressure,
                         Temperature_K = (5*(Temperature_F-32)/9)+273.15,
                         Temperature_C = Temperature_K-273.15,
                         Pressure_Bar = Pressure_psi/14.504,
                         PpCo2_psi = Co2_percentage*Pressure_psi/100,
                         PPCO2_Bar = Co2_percentage*Pressure_Bar/100,
                         Vsl_mps = (Fluid_rate*5.515/86400)/((pi*tubing_id^2)/(4*144))*0.3048,
                         Vm_mmyear = 2.8*PPCO2_Bar*(Vsl_mps^0.8/((0.0254*tubing_id)^0.2)), 
                         fug_coef = if_else(Pressure_Bar<= 250, 
                                            10^(45.33*(0.0031-1.4/Temperature_K)),
                                            10^(230*(0.0031-1.4/Temperature_K))),
                         FCO2_bar = PPCO2_Bar*fug_coef,
                         Tcap_K = 2400/(6.7+0.6*log10(FCO2_bar)),
                         T_ratio = Temperature_K - Tcap_K,
                         log_Fs = (2400/Temperature_K)-0.6*log10(FCO2_bar)-6.7,
                         Fs = if_else(T_ratio >= 1,10^log_Fs,1),
                         pH = 3.71+(4.17*10^-3)*Temperature_C-0.5*log10(FCO2_bar),
                         Vr_mmyear = 10^(5.785+0.41*log10(PPCO2_Bar)-(1119/Temperature_K)-0.34*pH),
                         Fc = 1+(4.5+1.9)*carbon_content, #carbon content
                         Fcr = 1/(1+(2.3+0.4)*chrome_content), # chrome content
                         V_mmyear = Fs*Vm_mmyear*Vr_mmyear*Fc*Fcr/(Vm_mmyear+Vr_mmyear*Fc),
                         V_mpy = (1-C_Inhibitor/100)*V_mmyear*39.37)
        xaxes <- x$Depth_ft
        yaxes <- x$V_mpy
        plot(xaxes, yaxes, type = "l", xlab = "Depth (ft)",
             ylab= "Corrosion Rate (mpy)")
    })
    output$documentation <- renderText({
        "Documentation: Model that calculates corrosion on vertical pipelines.
        Choose Depth and Pressure ranges. Use the sliders to do a sensitivity
        analysis with different variables"
    })
})