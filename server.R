library(shiny)
library(ggplot2)
library(dplyr)
library(maps)

source("CleanMeteoriteData.R")
source("Question4Data.R")

meteorite.data <- CleanMeteoriteData()

q4.data <- RatioByYearData()

server <- function(input, output) {

  output$q4 <- renderText({
    "How has the amount of technology and/or resources helped observe 
    meteorite landngs over time? Has the amount of meteorites seen falling
    compared to the amount found on the ground increased over time?"
  })
  
  output$q4.table <- renderTable({
    return(q4.data)
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
          when we remove any outliers with residuals greater than 10.")
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
         labs(title = "Percentage of Meteorites Seen Falling Over Time")
      return(p2)
  })
}