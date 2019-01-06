# load libraries
pacman::p_load(
  "plotly"
)

# create functions
lifter <- function(rules){
  rules <- subset(
    rules,
    lift > 1
  )
  rules <- sort(rules, by = "lift", decreasing = TRUE)
  return(rules)
}

# load other code
fileSources <- c(
  "./df.R",
  "./tr.R"
)
sapply(fileSources, source, .GlobalEnv)
rm(fileSources)

trList <- list(all = tr)
# subset transactions
for(t in names(segmentsList)){
  trList[[t]] <- tr[segmentsList[[t]]]
}

piedf <- as.data.frame(sapply(segmentsList, length))
colnames(piedf) <- "Total"
piedf <- subset(piedf, rownames(piedf) != "b2c")
pie <- plot_ly(
  piedf,
  labels = rownames(piedf),
  values = ~Total,
  type = "pie"
) %>%
  layout(title = 'Transactions by customer profile')
rm(piedf, segmentsList, t)  # remove unused variables

# build list of frequency plots
freqPlot <- list()
for(t in names(trList)){
  freqPlot[[t]] <- itemFrequencyPlot(
    trList[[t]],
    topN = 10,
    # support = .2,
    type = "absolute",
    main = paste("Top 10 products for", t, "profile")
  )
}

# build association rules
b2bRules <- apriori(
  trList[["b2b"]],
  parameter = list(
    support = .1,
    confidence = .5
  )
)

fanboyRules <- apriori(
  trList[["fanboy"]],
  parameter = list(
    support = .08,
    confidence = .5
  )
)

b2bRules <- lifter(b2bRules)
fanboyRules <- lifter(fanboyRules)
