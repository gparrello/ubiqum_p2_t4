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
  "./data/item_list2.csv",
  strip.white = TRUE
)
# pr <- apply(pr, 2, trim)  # trim strings, not needed any more


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

## THIS IS BETTER CODE! DO NOT ITERATE OVER DATAFRAMES IDIOT!!!
# df[df == ''] <- NA
# df$transaction <- 1:nrow(df)
# df <- na.omit(melt(data = df, id.vars = 'transaction'))
# df$variable <- NULL
# df <- df[order(df$transaction), ]

df <- apply(tmpdf, 2, trim)  # trim strings
# merge categories
df <- merge(
  df,
  pr,#[,c("Product", "Type")],
  by.x = "Product",
  by.y = "Product",
  all.x = TRUE,
  all.y = FALSE
  )
df <- subset(df, Product != "")  # still have some empty products, remove them
rm(v, row, tmpdf, pr)  # remove unused variables

dfWideProducts <- dcast(df, transaction ~ Type, value.var = "transaction", fun.aggregate = length)  # cast dataframe into wide (pivot) format
rownames(dfWideProducts) <- dfWideProducts$transaction  # set transaction numbers as indexes
dfWideProducts$transaction <- NULL  # remove transaction columns
dfWideProducts$total <- apply(dfWideProducts, 1, sum)  # get a summatory of all categories

dfWideClients <- dcast(df, transaction ~ ClientType, value.var = "transaction", fun.aggregate = length) # cast dataframe into wide (pivot) format
rownames(dfWideClients) <- dfWideClients$transaction  # set transaction numbers as indexes
dfWideClients$transaction <- NULL  # remove transaction columns
dfWideClients$total <- apply(dfWideClients, 1, sum)  # get a summatory of all categories

rm(df)  # remove unused variables2df


#### Subset into client profiles ####
# create some variables to use as minimum values to qualify as b2b profile
minTotalItems <- 10
minDesktop <- 2
minLaptop <- 2
minTablets <- 2
minMonitors <- 3
minStands <- 3
minHeadphones <- 2
minMouseKeyboard <- 2
minPrinters <- 2
minSmartHome <- 2
# subset for b2b
b2b <- subset(
  dfWideProducts,
  # criteria used to subset for b2b
  total >= minTotalItems |
    Desktop >= minDesktop |
    Laptops >= minLaptop |
    `Computer Tablets` >= minTablets |
    Monitors >= minMonitors |
    `Computer Stands` >= minStands |
    `Computer Headphones` >= minHeadphones |
    `Active Headphones` >= minHeadphones |
    Keyboard >= minMouseKeyboard |
    `Computer Mice` >= minMouseKeyboard |
    `Mouse and Keyboard Combo` >= minMouseKeyboard |
    Printers >= minPrinters |
    `Smart Home Devices` >= minSmartHome
)
# create index vectors
b2b <- as.integer(rownames(b2b))  # create integer vector from b2b indexes
b2c <- allIndex[!allIndex %in% b2b]  # create vector for b2c out of all indexes
rm(allIndex)  # remove unused variables

# create some variables to use as minimum values to qualify as b2b profile
minGaming <- 2
minFanboy <- 2
# subset for b2b
gamer <- subset(
  dfWideClients,
  # criteria used to subset for b2b
  Gaming >= minGaming
)
fanboy <- subset(
  dfWideClients,
  # criteria used to subset for b2b
  Fanboy >= minFanboy
)
# create index vectors
gamer <- intersect(b2c, as.integer(rownames(gamer)))
fanboy <- intersect(b2c, as.integer(rownames(fanboy)))
regular <- setdiff(b2c, union(gamer, fanboy))
# length(regular)+length(fanboy)+length(gamer) == length(b2c)  # why is this false?!

rm(list=ls(pattern="^min.*"))  # remove unused variables
rm(dfWideProducts, dfWideClients)  # remove unused variables2df

segmentsList <- list(
  b2b = b2b,
  b2c = b2c,
  regular = regular,
  fanboy = fanboy,
  gamer = gamer
)
rm(b2b, b2c, regular, fanboy, gamer)  # remove unused variables