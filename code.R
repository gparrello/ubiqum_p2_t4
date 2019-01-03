pacman::p_load(
  "caret",
  "rbokeh",
  "arules",
  "arulesViz"
)

tr <- read.transactions(
  "./data/ElectronidexTransactions2017.csv",
  # format = "basket",
  sep = ','
)

pr <- read.csv(
  "./data/item_list.csv"
)

itemFrequencyPlot(
  tr,
  topN = 10,
  # support = .2,
  type = "absolute"
)

rules <- apriori(
  tr,
  parameter = list(
    supp = .01,
    conf = .05,
    minlen = 2
  )
)

figure() %>%
  ly_points(support, lift, data = rules@quality, color = confidence)

plot(
  head(
    rules,
    n = 10,
    by = "lift"
  ),
  method = "graph",
  interactive = TRUE
)

# ruleExplorer(tr)
# itemInfo(tr) <- data.frame(labels = pr$Product, level1 = pr$Type)
trByProductType <- aggregate(
  tr,
  pr$Type
)
