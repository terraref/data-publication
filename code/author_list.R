install.packages("rorcid")
library(rorcid)
library(dplyr)

# from https://docs.google.com/spreadsheets/d/1FnaeJZ1A6r1fa3UvhfczMLKh5CWaSMErBRw4vTKgPe8/edit#gid=653912363
download.file('https://docs.google.com/spreadsheets/d/e/2PACX-1vRlpmpKQFDP0yWf0_xUT8s_h1t5IC6dtDxt4fmerrAULfItbtd0nefH-22DpgaIPwiURBPNcXpXpDyV/pub?gid=653912363&single=true&output=csv',
              'authorship.csv')
x <- readr::read_csv('authorship.csv')
#orcid_auth()

a <- list()
for(orcid in x$ORCID){
  orcid_result <- rorcid::orcid_id(orcid)
  a[[orcid]] <- orcid_result[[1]]$name$`family-name`$value
}



y <- x %>% select(name = Name, institution = `Institutional Affiliation(s)`, orcid = ORCID, contributions = `Contributions to Paper`) %>% 
  mutate(familyname = as.vector(unlist(a)),
         Conceptualization = grepl("Conceptualization:", contributions),
         `Data Curation` = grepl("Data Curation:", contributions),
         `Formal Analysis` = grepl("Formal Analysis:", contributions),
         `Funding Acquisition` = grepl("Funding Acquisition:", contributions),
         Investigation = grepl("Investigation", contributions),
         Methodology = grepl("Methodology", contributions),
         `Project Administration` = grepl("Project Administration", contributions),
         Resources = grepl("Resources", contributions),
         Software = grepl("Software", contributions),
         Supervision = grepl("Supervision", contributions),
         `Writing- Original Draft Preparation` = grepl("Writing- Original Draft Preparation", contributions),
         `Writing - Review and Editing` = grepl("Writing - Review and Editing", contributions))

acronymatize <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste((substring(s, 1,1)),
        sep="", collapse="")
}

z <- y %>% 
  rowwise() %>% 
  mutate(initials = acronymatize(name))

readr::write_csv(z, 'metadata/authors.csv')
