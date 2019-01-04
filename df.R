pacman::p_load(
  "caret",
  "rbokeh",
  "arules",
  "arulesViz",
  "gdata",
  "reshape2"
)

# read transactions from file
tr <- read.transactions(
  "./data/ElectronidexTransactions2017.csv",
  #format = "basket",
  sep = ","
)

df <- read.csv(
  file = "./data/ElectronidexTransactions2017.csv",
  sep = ",",
  header = FALSE
)
df <- df[!apply(df == "", 1, all),]

pr <- read.csv(
  "./data/item_list2.csv"
)
pr <- apply(pr, 2, trim)

tmpdf <- data.frame()

for(row in 1:nrow(df)){
  v <- unname(unlist(df[row,]))
  v <- v[!v %in% ""]
  v <- as.data.frame(v)
  colnames(v) <- "Product"
  v["transaction"] <- row
  tmpdf <- rbind(tmpdf, v)
}

rm(v, row)
df <- apply(tmpdf, 2, trim)
rm(tmpdf)
df <- merge(df, pr[,c("Product", "Type")], by.x = "Product", by.y = "Product", all.x = TRUE, all.y = FALSE)
rm(pr)
df <- subset(df, Product != "")
df <- dcast(df, transaction ~ Type)
