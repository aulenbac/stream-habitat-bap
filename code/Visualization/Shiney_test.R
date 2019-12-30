library(shiny)

ui<-fluidPage(sliderInput(inputId ="num", label= "Choose a number", value=25, min =1, max = 100), 
              plotOutput("hist"))

server <- function(input, output) { #put r code in here to 
        output$hist <-renderPlot({
          hist(rnorm(input$num))
        })
} 

shinyApp(server = server, ui=ui)