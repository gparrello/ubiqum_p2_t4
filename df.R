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

# maxNumMain = 2
# b2b <- c()
# b2c <- c(1:nrow(df))
tmpdf <- data.frame()

for(row in 1:nrow(df)){
  v <- unname(unlist(df[row,]))
  v <- v[!v %in% ""]
  # items <- length(v)
  v <- as.data.frame(v)
  colnames(v) <- "Product"
  v["transaction"] <- row
  tmpdf <- rbind(tmpdf, v)
  # v <- v[,"Type"]
  
  # if(
  #   (items > 10) |
  #   (length(
  #     which(v == "Desktop") |
  #     which(v == "Laptops") |
  #     which(v == "Monitors") |
  #     which(v == "Printers") |
  #     which(v == "Computer Tablets")
  #   ) >= maxNumMain)
  # ){
  #   b2b <- append(b2b, row)
  # }
}
rm(v, row)#, items)
df <- apply(tmpdf, 2, trim)
rm(tmpdf)
df <- merge(df, pr[,c("Product", "Type")], by.x = "Product", by.y = "Product", all.x = TRUE, all.y = FALSE)
rm(pr)
df <- subset(df, Product != "")
df <- dcast(df, transaction ~ Type)

# b2c <- b2c[!b2c %in% b2b]
