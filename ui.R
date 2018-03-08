library(shiny)
  # Loads the shiny library

range.year <- range(1974, 2011)
  # The range of the years of this data set

ui <- fluidPage(
  
  # The title of our web app
  titlePanel("Exploring Meteorite Data"),
  
  # What goes in our tabsets
  tabsetPanel(type = "tabs",
              tabPanel("Q1"),
              tabPanel("Composition vs Location",
                       sidebarLayout(
                         sidebarPanel(
                           br(),
                           sliderInput("select.year", "Year:",min = 1974, max = 2011, value = 1974),
                           br()
                         ),
                         
                         mainPanel(
                           h2("Description"),
                           textOutput("q2.text3"),
                           h2("Density of Meteorite Landings on Land"),
                           plotOutput("q2.map") , 
                           h2("Meteorite Compositions"),
                           plotOutput("q2.bar.graph"), 
                           h2("Composition Information"),
                           img(src = "classification.png"),
                           textOutput("img.source"),
                           br(),
                           img(src = "table_class.png"),
                           h2("Analysis"), 
                           textOutput("q2.text2"),
                           br(),
                           br()) 
                       )
              ),
              # The tab panel for question 3. Includes an interactive map, 
              # an introduction to the map, an information display that 
              # displays data accordingto user's click, and an interactive 
              # slider
              tabPanel("Relation between meteorite data and population density"
                       , sidebarPanel(sliderInput("n",
                                                  "Choose a year:",
                                                  value = 2000,
                                                  min = 1974,
                                                  max = 2016)),
                       mainPanel(
                         br(), p(textOutput("intro3")),
                         p(strong("In which countries have the most number of 
                         meteorites been found and how many people did it 
                         affect (depending on the population density of the 
                         country)?")),
                         p("It was found that over the years, 
                           a majority of meteorites were reported to be found 
                           in North America and Afria and the population 
                           density in these places have always been in the 
                           middle range in comparison to other countries. Thus
                           concluding that so far, meteorites haven't been 
                           found a lot in highly populated countries."),
                         plotOutput("map3", click = "plot_click"),
                         verbatimTextOutput("info3")  
                       )
              ),
              # The tab panel for question 4. Includes the question, an 
              # interactive table, two linear regression plots, a conclusion
              # paragraph,and an implications paragraph as well as descriptions
              # for the table and plots.
              tabPanel("Resources for Observing Meteorites", 
                       p(strong("Question 4")), textOutput("q4"), p(""),
                       p(strong("Table")), textOutput("table.description"), 
                       p(""),
                       sidebarPanel(sliderInput("year.choice", label = "Years",
                                                min = range.year[1], 
                                                max = range.year[2], 
                                                value = range.year),
                                    textOutput("slider.info")),
                       tableOutput("q4.table"), p(strong("Linear Regression")), 
                       textOutput("fit.intro"), p(""), plotOutput("q4.plot"),
                       textOutput("fit.description"), p(""), 
                       plotOutput("new.plot"), textOutput("new.description"),
                       p(""), p(strong("Conclusion")), 
                       textOutput("conclusion"), p(""), 
                       p(strong("Implications")), textOutput("implications"))

  )
  
)