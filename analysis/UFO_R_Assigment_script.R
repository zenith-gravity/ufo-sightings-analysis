#===================================
# UFO Sightings Regression Assignment
#====================================

#The Question is the time of day associated with how long a UFO 
#sighting is reported to last?

#------------------------------------
# (1) Load Dataset
#------------------------------------

ufo <- read.csv("ufo_sightings_scrubbed.csv")

head(ufo)

names(ufo)

str(ufo)

#-----------------------------------
#(2) Prepare the Data
#-----------------------------------

# Convert datetime into a date-time format
ufo$datetime <- as.POSIXct(
  ufo$datetime,
  format = "%Y-%m-%d %H:%M:%S"
)

# Create a separate date column
ufo$date <- as.Date(ufo$datetime)

# Create a separate time column
ufo$time <- format(ufo$datetime, "%H:%M:%S")

#check it it worked
head(ufo) #That is not very helpful, I ask for a better way to view and recived

head(ufo[,c("datetime", "date", "time")])
#datetime               date      time
#1 1949-10-10 20:30:00 1949-10-11 NULL
#2 1949-10-10 21:00:00 1949-10-11 NULL
#3 1955-10-10 17:00:00 1955-10-10 NULL
#4 1956-10-10 21:00:00 1956-10-11 NULL
#5 1960-10-10 20:00:00 1960-10-11 NULL
#6 1961-10-10 19:00:00 1961-10-10 NULL

#something went wrong so I am going to reload the data and try something else

ufo <- read.csv("ufo_sightings_scrubbed.csv")

#Checking the datetime column agian

head(ufo$datetime)

# Create separate date and time columns
ufo$date <- as.Date(substr(ufo$datetime, 1, 10))

ufo$time <- substr(ufo$datetime, 12, 19)

#Adding an hour column as an integer
ufo$hour <- as.integer(substr(ufo$time, 1, 2))

#Check it again
head(ufo[, c("datetime", "date", "time", "hour")])
#This time it worked, Lets look at the duration
head(ufo$duration..seconds.)
#[1] "2700" "7200" "20"   "20"   "900"  "300"
summary(ufo$duration..seconds.)
#  Length     Class      Mode 
#80332 character character

length(ufo$duration..seconds.)

ufo$duration_seconds <- as.numeric(ufo$duration..seconds.)

#---------------------------------------------------
#(2.1) organize the data
#---------------------------------------------------

#Removing missing or invalid duration values

ufo_clean <- ufo[
  !is.na(ufo$duration_seconds) &
    ufo$duration_seconds > 0 &
    !is.na(ufo$hour),
]

#Check the cleaned data
summary(ufo_clean$duration_seconds)
# Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
#    0       30      180     9017    600     97836000 
summary(ufo_clean$hour)
#Min. 1st Qu.  Median    Mean   3rd Qu.    Max. 
#0.00   10.00   19.00   15.53   21.00      23.00

#-------------------------------------------
# introducing a Log transformation because
# the few extremely long reported sightings 
# can dominate
#-------------------------------------------

ufo_clean$log_duration <- log(ufo_clean$duration_seconds)

summary(ufo_clean$log_duration)

#=============================================================
#(3) Linear Regression
#=============================================================

linear_model <- lm(log_duration ~ hour, data = ufo_clean)
summary(linear_model)

#Call:
#lm(formula = log_duration ~ hour, data = ufo_clean)

#Residuals:
#  Min       1Q   Median       3Q      Max 
#-11.9021  -1.5334   0.2584   1.4661  13.4530 

#Coefficients:
#  Estimate Std. Error t value Pr(>|t|)    
#(Intercept)  5.0092393  0.0172724  290.01  < 2e-16 ***
#  hour        -0.0037320  0.0009953   -3.75 0.000177 ***
#  ---
#  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

#Residual standard error: 2.187 on 80327 degrees of freedom
#Multiple R-squared:  0.000175,	Adjusted R-squared:  0.0001625 
#F-statistic: 14.06 on 1 and 80327 DF,  p-value: 0.0001773


# --------------------------------------------------------------
# Here we see that p is less than 0.05 so the relationship is
#Statistically significant

# However, R-squared = 0.000175, so hour explains only about
# 0.018% of the variation in sighting duration. Therefore,
# the relationship is statistically significant but very weak.
#----------------------------------------------------------------

# Create binary outcome
# 1 = sighting lasted 10 minutes or longer
# 0 = sighting lasted less than 10 minutes

ufo_clean$long_sighting <- ifelse(
  ufo_clean$duration_seconds >= 600,
  1,
  0
)

# See how many sightings fall into each group
table(ufo_clean$long_sighting)

# See percentages
prop.table(table(ufo_clean$long_sighting))

#---------------------------------------------------
# (4) Logistic Regression
#---------------------------------------------------

# Research question:
# Is the hour of the day associated with whether
# a UFO sighting lasts at least 10 minutes?

logistic_model <- glm(
  long_sighting ~ hour,
  data = ufo_clean,
  family = binomial
)

# Display logistic regression results
summary(logistic_model)

#Call:
#glm(formula = long_sighting ~ hour, family = binomial, data = ufo_clean)

#Coefficients:
#  Estimate Std. Error z value Pr(>|z|)    
#(Intercept) -0.7149049  0.0168807 -42.350  < 2e-16 ***
# hour        -0.0064556  0.0009785  -6.598 4.18e-11 ***
#  ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

#(Dispersion parameter for binomial family taken to be 1)

#Null deviance: 99061  on 80328  degrees of freedom
#Residual deviance: 99018  on 80327  degrees of freedom
#AIC: 99022

#Number of Fisher Scoring iterations: 4

#---------------------------------------------------
# (3.1) Linear Regression Visualization
#---------------------------------------------------

# Open a new plotting window
dev.new(width = 8, height = 6)

# Plot hour against log duration
plot(
  ufo_clean$hour,
  ufo_clean$log_duration,
  xlab = "Hour of Day",
  ylab = "Log Duration (seconds)",
  main = "UFO Sighting Duration by Time of Day",
  pch = 16,
  cex = 0.3,
  col = rgb(0, 0, 0, 0.15)
)

# Add regression line
abline(
  linear_model,
  col = "red",
  lwd = 3
)

#-----------------------------------------------------
#That did not work lets try the correlation analysis
#-----------------------------------------------------
# Select numeric variables related to the linear regression
cor_data <- ufo_clean[, c(
  "hour",
  "duration_seconds",
  "log_duration"
)]

# Create Pearson correlation matrix
correlation_matrix <- cor(
  cor_data,
  use = "complete.obs",
  method = "pearson"
)

# Display correlation matrix
round(correlation_matrix, 4)
#                 hour       duration_seconds log_duration
#hour              1.0000          -0.0028      -0.0132
#duration_seconds -0.0028           1.0000       0.0741
#log_duration     -0.0132           0.0741       1.0000

## Assignment 2

#Now I am looking at the time of day and took ufo_clean
# and got the summary after checking out the first few entrieys

`head(ufo_clean$hour`

#the summary is 
`summary(uf0_clean$hour)`

#now we will split it into day and night

`ufo_clean$day_night <- ifelse(
  ufo_clean$hour >= 6 & ufo_clean$hour < 18,
  "Day",
  "Night"
)`

#check and see how many for each

`table(ufo_clean$day_night`)

# Looking to use a two sample test

`tapply(ufo_clean$duration_seconds,
        ufo_clean$day_night,
        summary)`

#opps I forgot about the historgram!

#historgram for the day

`hist(ufo_clean$duration_seconds[ufo_clean$day_night == "Day"])`

#historgram for the night

`hist(ufo_clean$hour)`

