library(shiny)
library(shinyjs)
library(DBI)
library(RPostgres)

shinyServer(function(input, output, session){


  # it should be sufficient to store the session token.
  # cookies auth is a more sophisticated alternative, but
  # let's not dive into js to deep for now.
  # session$token

  store_record <- function(response){
    con <- dbConnect(
      drv = Postgres(),
      dbname = "postgres",
      port = 1111,
      user = Sys.getenv("PG_USER"),
      password = Sys.getenv("PG_PASSWORD"),
      host = "localhost"
    ) 
    
    dbExecute(con,"SET SEARCH_PATH=rseed")
    dbAppendTable(con, dbQuoteIdentifier(con,"survey_responses"), response)
    dbDisconnect(con)
  }

  submitted <- reactiveVal(FALSE)


  response <- reactive({
    dt <- data.frame(
      id = session$token,
      quarto = input$quarto,
      publishing = input$publishing,
      programming = input$programming,
      stringsAsFactors = FALSE
    )
  })

  observeEvent(input$submit, {
    store_record(response())
    submitted(TRUE)
    # has_participated(TRUE)
    # js$setcookie("HAS_PARTICIPATED_IN_SPOSM_INTRO_SURVEY")
  })

  output$test <- renderText({
    as.character(submitted())
  })


  output$quarto <- renderUI(
    if(!submitted()){
      fluidRow(
        column(width = 6,
               div(class = "panel panel-primary",
                   div(class = "panel-heading",
                       h3("Quarto"),
                       div(class = "panel-body",
                       "Please indicate your familarity with quarto.
                       0 = Never hear of it before, 1 = I remember the name and concept 2 = I understand roughly how it works,
                       3 = I can apply quarto, 4 = It's my tool of choice, I use it regularly, 5 = I can teach others and create extensions.",
                       sliderInput("quarto",
                                   label = "Quarto Adoption",
                                   min = 0,
                                   max = 5,
                                   value = 0)
                       )
                       )
                   )
               )
      )
      }
    )
  

  output$publishing <- renderUI(
    if(!submitted()){
      fluidRow(
        column(width = 6,
               div(class = "panel panel-primary",
                   div(class = "panel-heading",
                       h3("Publishing")),
                   div(class = "panel-body",
                       "Please indicate your main Typesetting engine or Publishing Tool.",
                       radioButtons("publishing","Main Publishing Tool",
                                    choices = c("LaTeX" = "LaTeX",
                                                "RMarkdown (Traditional knitr)" = "RMarkdown",
                                                "Notebooks" = "Notebooks",
                                                "Quarto" = "quarto",
                                                "MS Word" = 'Word',
                                                "Cloud Based Service" = "cloud",
                                                "Other" = "Other"
                                    ))
                   ),
                   
               )
        )
      )
    }
  )
  

  output$language <- renderUI(
    if(!submitted()){
      fluidRow(
        column(width = 6,
               div(class = "panel panel-primary",
                   div(class = "panel-heading",
                       h3("Programming Language")),
                   div(class = "panel-body",
                       "Please indicate your *main* programming language.",
                       radioButtons("programming","Main Programming Language",
                                    choices = c("Python" = "Python",
                                                "R" = "R",
                                                "Julia" = "Julia",
                                                "C/C++/C#" = "C",
                                                "Java" = "Java",
                                                "Go" = "Go",
                                                "Rust" = "Rust",
                                                "JavaScript" = "Javascript",
                                                "Other" = "Other"
                                                ))
                       ),

               )
        )
      )
    }
  )

  
  
  output$submit <- renderUI(
    if(!submitted()){
    fluidRow(
      column(width = 6,
             div(class = "panel panel-primary",
                 div(class = "panel-heading",
                     h3("Submit Your Answers!")),
                 div(class = "panel-body", align = "right",
                     actionButton('submit',"submit")
                 )
             )
      )
    )
    }
  )

  output$thanks <- renderUI(
    if(submitted()){
      fluidRow(
        column(width = 6,
               div(class = "panel panel-info",
                   div(class = "panel-heading",
                       h3("Thank You")),
                   div(class = "panel-body", align = "right",
                       "Thank you for your participation. Please take only part once."
                   )
               ))
      )
    }
  )

})








