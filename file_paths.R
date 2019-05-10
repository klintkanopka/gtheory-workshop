library(here)
library(fs)

# looks for these directories within your working directory
dir_data <- here("data files")
dir_output <- here("output")


# paths for the data files
file_data_p1 <- path(dir_data, 
                     "data for mini-project 1", 
                     ext="xlsx")
file_data_p2_4 <- path(dir_data, 
                       "data for mini-projects 2-4, table 3.8 shavelson & Webb",
                       ext="xlsx")
file_data1_p5 <- path(dir_data, 
                      "data 1 for mini-project 5", 
                      ext="xlsx")
file_data2_p5 <- path(dir_data, 
                      "data 2 for mini-project 5", 
                      ext="xlsx")
file_data_p6 <- path(dir_data, 
                     "problem 6 data", 
                     ext="xlsx")
