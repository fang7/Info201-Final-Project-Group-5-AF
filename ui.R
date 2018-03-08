library(shiny)
  # Loads the shiny library

range.year <- range(1974, 2011)
  # The range of the years of this data set

ui <- fluidPage(
  
  # The title of our web app
  titlePanel("Exploring Meteorite Data"),
  
  # What goes in our tabsets
  tabsetPanel(type = "tabs",
              tabPanel("Geographical Map", 
                       sidebarLayout(
                         sidebarPanel( 
                           br(),
                           sliderInput('chosen.year', 
                                       label = "Pick a year:", 
                                       min = 1974, 
                                       max = 2016, 
                                       value = 1995, 
                                       sep = "")
                         ),
                         mainPanel(
                                br(), 
                                h1("Description"),
                                textOutput("map.description"), 
                                h1("Location and Info"), 
                                plotOutput('plot',
                                           click = "plot_click",
                                           brush = brushOpts(
                                             id = "plot_brush"
                                           )
                                ),
                                verbatimTextOutput("click_info"),
                                verbatimTextOutput("brush_info")
                         )
                       )
              ),
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
              tabPanel("Relation between meteorite data and population density", 
                       sidebarPanel(br(),
                                    br(),
                                    br(),
                                    br(),
                                    br(),
                                    br(),
                                    br(),
                                    br(),
                                    br(),
                                    br(),
                                    sliderInput("n",
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
                         p("This analysis question tries to understand where 
                           the majority of the meteorites are found and using
                           the population densities in those regions, try to 
                           understand how many people the meteorite falls may
                           affect. Even if there are no people or buildings 
                           that are directly hit by a meteorite, the shockwave
                           from the exploding object injures people and causes
                           a lot of damage to infrastructures. "),
                         br(),
                         p("When looking at the data found, it was noticed that
                           most of the meteorite falls have been recorded in 
                           North America, North Africa and Antarctica whose 
                           population densities are moderate, moderate, and 
                           almost negligible respectively. Thus, it was 
                           concluded that a majority of the meteorite falls
                           weren't recorded in densely populated countries."),
                         br(),
                         p("This analysis question also sparked another 
                           question. Why are most number of meteorites 
                           found in the above-mentioned countries?"),
                         br(),
                         p("The reason is because the Africa and Antarctica 
                            have a large span of deserts and deserts are places 
                            that collect meteorites over thousands of years 
                            without anything happening to them. Also, 
                            meteorites are easier to find in deserts then in 
                            places with lots of vegetation or other rocks. 
                            
                            Another reason why more meteorites are found in 
                            deserts is because they are collected irrespective
                            of their size, whereas in other places it is easier
                            to miss the smaller meteorites. If instead of 
                            looking at the amount of meteorites that fell in a 
                            place by number, we looked at the amount that fell 
                            by mass, we would actually find that more 
                            meteorites by mass have been found in places like 
                            North America.
                            "),
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