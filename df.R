# load libraries
pacman::p_load(
  "arules",
  "arulesViz",
  "gdata",
  "reshape2"
)

# read transactions from file
tr <- read.transactions(
  "./data/ElectronidexTransactions2017.csv",
  format = "basket",
  sep = ","
)

# read transactions as dataframe
df <- read.csv(
  file = "./data/ElectronidexTransactions2017.csv",
  sep = ",",
  header = FALSE
)
df <- df[!apply(df == "", 1, all),]  # clean empty rows

# read categories from file
pr <- read.csv(
  "./data/item_list2.csv"
)
pr <- apply(pr, 2, trim)  # trim strings

tmpdf <- data.frame()  # create empty dataframe

# loop over dataframe rows
for(row in 1:nrow(df)){
  v <- unname(unlist(df[row,]))  # get a vector out of a row from the dataframe
  v <- v[!v %in% ""]  # remove empty elements from the vector
  v <- as.data.frame(v)  # convert to a 1-column dataframe
  colnames(v) <- "Product"  # change name of column
  v["transaction"] <- row  # add column with transaction number
  tmpdf <- rbind(tmpdf, v)  # append to new dataframe to create long format
}

df <- apply(tmpdf, 2, trim)  # trim strings
# merge categories
df <- merge(
  df,
  pr[,c("Product", "Type")],
  by.x = "Product",
  by.y = "Product",
  all.x = TRUE,
  all.y = FALSE
  )
df <- subset(df, Product != "")  # still have some empty products, remove them
df <- dcast(df, transaction ~ Type)  # cast dataframe into wide (pivot) format
rm(v, row, tmpdf, pr)  # remove unused variables