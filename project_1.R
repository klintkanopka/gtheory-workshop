# This is R code to reproduce a 1 facet design

library(gtheory)
library(tidyverse)
# this next line comes from the package "conflicted" - I'd suggest using it!
conflict_prefer("filter", "dplyr")
library(readxl)

d <- read_xlsx(file_data_p1)

# Work with a reduced version of the data as in class, also we rename these 
# awful variables

d_reduc <- d %>%
  filter(ratercluster == "Barrow-Herder-Kackley") %>%
  select(starts_with("Tech")) %>%
  transmute(Person = as.character(row_number()),
            rater_1 = `Techincalscore by rater1`,
            rater_2 = `Techincalscore by rater2`,
            rater_3 = `Techincalscore by rater3`)

# The gtheory package wants everything to exist in long form (annoying)
# It also requires data frames (not tibbles) for the dstudy.

d_shaped <- d_reduc %>%
  gather("Rater", "Score", 2:4) %>%
  mutate(Rater = case_when(
    Rater == "rater_1" ~ "1",
    Rater == "rater_2" ~ "2",
    Rater == "rater_3" ~ "3"
  )) %>%
  as.data.frame()

# COOL! FINALLY! Note that Person and Rater are character variables so they'll
# be handled as factors by the model, not numbers.

study_design <- as.formula("Score ~ (1|Person) + (1|Rater)")

G_study <- gstudy(data = d_shaped, 
            formula = study_design)

# This object seems kind of useless? We need to run it through a 
# d study for it to be of any real value.

# note here that $generalizability is the relative G_coef
# and $dependability is the absolute G_coef

dstudy(G_study, 
       data=d_shaped, 
       colname.objects = "Person",
       colname.scores = "Score")

# let's try a d-study with four raters. what the dstudy function wants is
# a dataframe that has the form of the study you *would* run.

# This is kind of a pain in the ass, but this code will work for a 
# single facet design of any size.

n_people <- 9
n_raters <- 4

p <- c()
for (i in 1:n_people){
  tmp <- rep(i, n_raters)
  p <- c(p, tmp)
}

sim_design <- data.frame(
  Person = p,
  Rater = rep(1:n_raters, n_people),
  Score = rep(0, n_raters*n_people)
)

# Note what we put together, here - it's a single row for every possible

dstudy(G_study, 
       data=sim_design, 
       colname.objects = "Person",
       colname.scores = "Score")

# For fun, we can wrap all that up in a function to conduct fast 1-facet
# dstudies of arbitrary design:

D.study <- function(G_study, n_people, n_raters){
  p <- c()
  for (i in 1:n_people){
    tmp <- rep(i, n_raters)
    p <- c(p, tmp)
  }
  
  sim_design <- data.frame(
    Person = p,
    Rater = rep(1:n_raters, n_people),
    Score = rep(0, n_raters*n_people)
  )
  
  D_study <- dstudy(G_study, 
         data=sim_design, 
         colname.objects = "Person",
         colname.scores = "Score")
  
  return(D_study)
}

# Cool?

D.study(G_study, 9, 4)
D.study(G_study, 9, 5)
