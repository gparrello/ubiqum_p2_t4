# load libraries
pacman::p_load(
  "rbokeh"
)

# load other code
file.sources <- c(
  "./df.R",
  "./tr.R"
)
sapply(file.sources, source, .GlobalEnv)

# subset transactions
b2b <- tr[b2b]
b2c <- tr[b2c]

# b2bDf <- as.data.frame(b2b)
# colnames(b2bDf) <- "index"
# b2cDf <- as.data.frame(b2c)
# colnames(b2cDf) <- "index"
# b2bDf$profile <- "b2b"
# b2cDf$profile <- "b2c"
# 
# custProf <- rbind(b2bDf, b2cDf)
# rownames(custProf) <- custProf$index
# custProf$index <- NULL
# itemsetInfo(tr) <- custProf
