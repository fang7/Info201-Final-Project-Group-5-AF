library(shiny)
library(ggplot2)

source("Question4Data.R")

q4.data <- RatioByYearData()

server <- function(input, output) {

  output$q4 <- renderText({
    "How has the amount of technology and/or resources helped observe 
    meteorite landngs over time? Has the amount of meteorites seen falling
    compared to the amount found on the ground increased over time?"
  })
  
  output$table.description <- renderText({
    "This table displays the number of meteorites found, the number of 
    meteorites seen falling, and the percentage of meteorites seen falling for 
    the user-selected years. This table also displays the averages for all of 
    these values over the selected time period as the last row in the table."
  })
  
  filtered.years <- reactive({q4.data %>%
                                filter(year >= input$year.choice[1] &
                                       year <= input$year.choice[2])
  })
  
  mean.found <- reactive({round(mean(filtered.years()$found), 2)})
  mean.fell <- reactive({round(mean(filtered.years()$fell), 2)})
  mean.percentage <- 
    reactive({round(100 * mean.fell() / (mean.fell() + mean.found()), 2)})
  
  filtered.data <- 
    reactive({rbind(filtered.years(), c("Averages", mean.found(), mean.fell(),
                                        mean.percentage()))})
  
  output$q4.table <- renderTable({
    return(filtered.data())
  })  
  
  output$fit.intro <- renderText({
    "Here we are going to fit a linear regression line for the relationship 
    between the year and the percentage of meteorites seen falling. We will 
    use every year in the data set (1974-2011) for this analysis."
  })
  
  linear.fit <- lm(q4.data$percentage.fell ~ q4.data$year)
  
  output$q4.plot <- renderPlot({
    p <- ggplot(q4.data, mapping = aes(x = year, y = percentage.fell)) +
      geom_point() +
      geom_smooth(method = "lm", se = FALSE) +
      geom_text(x = 2007, y = 7, 
                label = paste("r =", 
                              round(cor(q4.data$year, q4.data$percentage.fell),
                                    2))) +
      geom_text(x = 2007, y = 8, 
                label = paste("slope =", 
                              round(summary(linear.fit)$coefficients[2,1], 
                                    2))) +
      labs(title = "Percentage of Meteorites Seen Falling Over Time")
    return(p)
  })
      
  output$fit.description <- renderText({
    paste0("The linear fit has a slope of ", 
          round(summary(linear.fit)$coefficients[2,1], 2), " and an associated 
          p-value of ", round(summary(linear.fit)$coefficients[2,4], 2), ". The
           correlation coefficient is r = ", 
          round(cor(q4.data$year, q4.data$percentage.fell), 2), ". Both values 
          are negative which means that the number of meteorites seen falling 
          is actually trending downward. The p-value is not significant and 
          the correlation coefficient is quite low so therefore the 
          downward trend doesn't seem significant. This could be because of 
          the outlier data of 20% during the year 1976. Let's see what happens 
          when we remove any outliers by getting rid of years with residuals 
          greater than 10.")
  })
    
  q4.new.data <- q4.data[-which(abs(linear.fit$residuals) > 10), ]
    
  new.linear.fit <- lm(q4.new.data$percentage.fell ~ q4.new.data$year)
    
  output$new.plot <- renderPlot({
      p2 <- ggplot(q4.new.data, mapping = aes(x = year, y = percentage.fell)) +
         geom_point() +
         geom_smooth(method = "lm", se = FALSE) +
         geom_text(x = 2010, y = 2, 
                  label = paste("r =", 
                                round(cor(q4.new.data$year, 
                                          q4.new.data$percentage.fell), 2))) +
         geom_text(x = 2010, y = 2.2, 
                   label = paste("slope =", 
                               round(summary(new.linear.fit)$coefficients[2,1],
                                     3))) +
         labs(title = "Percentage of Meteorites Seen Falling Over Time")
      return(p2)
  })
  
  output$new.description <- renderText({
    paste0("After removing outliers, the new slope of the linear regression 
           line is ", round(summary(new.linear.fit)$coefficients[2,1], 3), 
           " with an associated p-value of ", 
           round(summary(new.linear.fit)$coefficients[2,4], 2), ". The 
           correlation coefficient is r = ", 
           round(cor(q4.new.data$year, q4.new.data$percentage.fell), 2), ". 
           Both of these values still indicate a extremely small downward trend 
           but it is much closer to zero. This would mean that there is no 
           change in percentage of meteorites seen falling over time. These 
           results are not significant as the p-value is much larger than 0.05 
           and the correlation coefficient is extremely low.") 
  })
  
  output$conclusion <- renderText({
    paste0("The linear fit regression line originally had a slope of ", 
           round(summary(linear.fit)$coefficients[2,1], 2), " and a correlation
           coefficient of ", 
           round(cor(q4.data$year, q4.data$percentage.fell), 2), ". This 
           wouldn't really make sense as the percentage of meteorites seen 
           falling shouldn't be decreasing over time as technology improves 
           unless NASA and/or observatories lost funding. Therefore, I decided 
           to remove outliers and fit another linear regression line. This new 
           regression line had a slope of ", 
           round(summary(new.linear.fit)$coefficients[2,1], 3), "with an 
           associated p-value of ", 
           round(summary(new.linear.fit)$coefficients[2,4], 2), " and a 
           correlation coefficient of ", 
           round(cor(q4.new.data$year, q4.new.data$percentage.fell), 2), " . 
           This slope seems more likely as it is very close to zero so that 
           would mean that the percentage of meteorites seen falling has 
           remained constant over time. Unfortunately, the p-value is too large
           and the correlation coefficient is too low to deem this result 
           significant. In conclusion, the percentage of meteorites seen 
           falling over time seems to remain somewhat constant, but the results
           were quite random and not significant.")
  })
  
  output$implications <- renderText({
    "You should be interested in these results for two reasons. One, they show 
    that meteorites observed falling are basically observed at random. Two, 
    they show that there have been no improvements in technology used to 
    observe meteorites as they're falling. If you want to work for NASA or 
    a related company, or you just are interested in meteorites, you could 
    design technology that would detect or predict meteorites and it will  
    almost certainly be an improvement."
  })
}