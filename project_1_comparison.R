# This is R code to reproduce a 1 facet design

library(gtheory)
library(tidyverse)
# this next line comes from the package "conflicted" - I'd suggest using it!
conflict_prefer("filter", "dplyr")
library(readxl)

# Work with a reduced version of the data as in class, also we rename these 
# awful variables

d_reduc <- read_xlsx(file_data_p1) %>%
  filter(ratercluster == "Barrow-Herder-Kackley") %>%
  select(starts_with("Tech")) %>%
  transmute(Person = as.character(row_number()),
            rater_1 = `Techincalscore by rater1`,
            rater_2 = `Techincalscore by rater2`,
            rater_3 = `Techincalscore by rater3`) %>%
  gather("Rater", "Score", 2:4) %>%
  mutate(Rater = case_when(
    Rater == "rater_1" ~ "1",
    Rater == "rater_2" ~ "2",
    Rater == "rater_3" ~ "3"
  )) %>%
  as.data.frame()

# We start with a crossed G study design

study_design <- as.formula("Score ~ (1|Person) + (1|Rater)")

G_study <- gstudy(data = d_reduc, 
            formula = study_design)

# Now let's run a pair of d studies comparing the use of two raters
# with both a fully crossed and a nested design

n_people <- 9
n_raters <- 2

p <- c()
for (i in 1:n_people){
  tmp <- rep(i, n_raters)
  p <- c(p, tmp)
}

crossed_sim_design <- data.frame(
  Person = p,
  Rater = rep(1:n_raters, n_people),
  Score = rep(0, n_raters*n_people)
)

# here we simulate the nested design by only giving one assignment to each
# rater

nested_sim_design <- data.frame(
  Person = p,
  Rater = 1:n_raters*n_people,
  Score = rep(0, n_raters*n_people)
)

# Note what we put together data files for the two designs, let's look at 
# comparisons for the two designs

dstudy(G_study, 
       data=crossed_sim_design, 
       colname.objects = "Person",
       colname.scores = "Score")

dstudy(G_study, 
       data=nested_sim_design, 
       colname.objects = "Person",
       colname.scores = "Score")
