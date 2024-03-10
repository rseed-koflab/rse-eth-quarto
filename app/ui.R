# Inspired by https://trr266.wiwi.hu-berlin.de/shiny/sposm_survey/
# https://github.com/joachim-gassen/sposm/tree/master/code/intro_survey

library(shiny)
library(shinythemes)

fluidPage(theme = shinytheme("superhero"),
          title = "Technical and Scientific Publishing",
          fluidRow(
            column(width = 6,
                   div(class = "jumbotron",
                       h1("Technical and Scientific Publishing"),
                       p("Please take a minute to answer this minimal survey. Your answers helps us as a group to get an understanding of the adaption of quarto as a relatively new tool. "))
            )
          ),
          uiOutput("quarto"),
          uiOutput("publishing"),
          uiOutput("language"),
          uiOutput("submit"),
          uiOutput("thanks")
          )

