library(rgdal)
library(rgeos)

sleacDataX <- read.table(file = "westPokotSLEACdata.csv", header = TRUE, sep = ",")

westPokot  <- readOGR(dsn = "westPokotMaps", layer = "westPokot")

library(RColorBrewer)

baseColours <- brewer.pal(n = 3, name = "RdYlGn")

## Calculate coverage indicators

# Function to calculate case-finding effectiveness
calculate_cf <- function(cin, cout) {
  cin / (cin + cout)
}

# Funciton to calculate treatment coverage

calculate_tc <- function(cin, cout, rin, k = 3) {
  
  rout <- 1/k * (rin * ((cin + cout + 1)/(cin + 1)) - rin)
  
  (cin + rin) / (cin + cout + rin + rout)
}


cf <- NULL

for(i in 1:nrow(sleacDataX)) {
  cf <- c(cf, calculate_cf(cin = sleacDataX[i, "sam.in"], cout = sleacDataX[i, "sam.total"] - sleacDataX[i, "sam.in"]))
}

tc <- NULL

for(i in 1:nrow(sleacDataX)) {
  tc <- c(tc, calculate_tc(cin = sleacDataX[i, "sam.in"], 
                           cout = sleacDataX[i, "sam.total"] - sleacDataX[i, "sam.in"], 
                           rin = sleacDataX[i, "sam.rec"], k = 3))
}

sleacDataX$cf <- cf
sleacDataX$tc <- tc

cutoffs <- c(0, 0.2, 0.5)

cf.class <- cut(x = sleacDataX$cf, breaks = cutoffs, labels = FALSE)
tc.class <- cut(x = sleacDataX$tc, breaks = cutoffs, labels = FALSE)

sleacDataX$cf.class <- cf.class
sleacDataX$tc.class <- tc.class

westPokot@data <- data.frame(westPokot@data, sleacDataX)

plot(westPokot, col = baseColours[westPokot$cf.class])
text(coordinates(westPokot), labels = westPokot$subcounty, cex = 0.75)

plot(westPokot, col = baseColours[westPokot$tc.class])
text(coordinates(westPokot), labels = westPokot$subcounty, cex = 0.75)

