pacman::p_load(
  "arules",
  "arulesViz"
)

# read transactions from file
tr <- read.transactions(
  "./data/ElectronidexTransactions2017.csv",
  #format = "basket",
  sep = ','
)
tr <- tr[which(size(tr) != 0)]  # eliminate empty rows
newInfo <- data.frame(itemInfo(tr)$labels)  # extract labels (columns) from the transactions into a new variable newInfo
colnames(newInfo) <- "labels"  # change column name of newInfo

# read categories from file
pr <- read.csv(
  "./data/item_list2.csv"
)
newInfo <- merge(newInfo, pr, by.x = "labels", by.y = "Product", all.x=TRUE)  # merge categories into newInfo
itemInfo(tr) <- newInfo[,c("labels", "Type")]  # add categories to itemInfo in tr
rm(newInfo)  # remove unused variables

# build frequency plot
freqPlot <- itemFrequencyPlot(
  tr,
  topN = 10,
  # support = .2,
  type = "absolute"
)

# plot(
#   head(
#     rules,
#     n = 10,
#     by = "lift"
#   ),
#   method = "graph",
#   interactive = TRUE
# )

# aggregate tr by categories
trByProductType <- aggregate(
  tr,
  by = tr@itemInfo[["Type"]]
)

# aggregate tr by other categories
# trByProductType2 <- aggregate(
#   tr,
#   by = tr@itemInfo[["NewType"]]
# )

# trB2C <- subset(tr, (!items %in% lhs(b2bRules) & !items %in% lhs(b2bRules)))
# profileLimit <- 4
# trB2C <- subset(tr, size(tr) < profileLimit)
# trB2B <- subset(tr, size(tr) >= profileLimit)
