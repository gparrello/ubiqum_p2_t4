#### Load libraries and data ####
# load libraries
pacman::p_load(
  "gdata",
  "reshape2"
)

# read transactions as dataframe
df <- read.csv(
  file = "./data/ElectronidexTransactions2017.csv",
  sep = ",",
  header = FALSE
)
df <- df[!apply(df == "", 1, all),]  # clean empty rows
allIndex <- c(1:nrow(df))  # create vector with all indexes

# read categories from file
pr <- read.csv(
  "./data/item_list2.csv"
)
pr <- apply(pr, 2, trim)  # trim strings

#### Build transactions dataframe ####
tmpdf <- data.frame()  # create empty dataframe
# loop over dataframe rows
for(row in 1:nrow(df)){
  v <- unname(unlist(df[row,]))  # get a vector out of a row from the dataframe
  v <- v[!v %in% ""]  # remove empty elements from the vector
  v <- as.data.frame(v)  # convert to a 1-column dataframe
  colnames(v) <- "Product"  # change name of column
  v$transaction <- row  # add column with transaction number
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
rownames(df) <- df$transaction  # set transaction numbers as indexes
df$transaction <- NULL  # remove transaction columns
df$total <- apply(df, 1, sum)  # get a summatory of all categories
rm(v, row, tmpdf, pr)  # remove unused variables

#### Subset into client profile ####
# create some variables to use as cutting criteria
cutTotal <- 10
cutDesktop <- 2
cutLaptop <- cutDesktop
# subset for b2b
b2b <- subset(
  df,
  # criteria used to subset for b2b
  total > cutTotal |
    Desktop >= cutDesktop |
    Laptops >= cutLaptop
)
rm(cutTotal, cutDesktop, cutLaptop)  # remove unused variables

# create index vectors
b2b <- as.integer(rownames(b2b))  # create integer vector from b2b indexes
b2c <- allIndex[!allIndex %in% b2b]  # create vector for b2c out of all indexes
rm(allIndex, df)  # remove unused variables2df