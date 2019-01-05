# load libraries
pacman::p_load(
  "rbokeh"
)

# load other code
fileSources <- c(
  "./df.R",
  "./tr.R"
)
sapply(fileSources, source, .GlobalEnv)
rm(fileSources)

# subset transactions
b2b <- tr[b2b]
b2c <- tr[b2c]
