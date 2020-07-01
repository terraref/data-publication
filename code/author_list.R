
library(rorcid)
library(dplyr)

# from https://docs.google.com/spreadsheets/d/1FnaeJZ1A6r1fa3UvhfczMLKh5CWaSMErBRw4vTKgPe8/edit#gid=653912363
file.remove('authorship.csv')
download.file('https://docs.google.com/spreadsheets/d/e/2PACX-1vRlpmpKQFDP0yWf0_xUT8s_h1t5IC6dtDxt4fmerrAULfItbtd0nefH-22DpgaIPwiURBPNcXpXpDyV/pub?gid=653912363&single=true&output=csv', cacheOK = FALSE,
              'authorship.csv')


# check who opted out
readr::read_csv('authorship.csv') %>% 
  filter(`Would you like to be a co-author` == 'No')

x <- readr::read_csv('authorship.csv') %>% 
  filter(`Would you like to be a co-author` == "Yes")


# orcid_auth(reauth = TRUE)

a <- list()

for(orcid in x$ORCID){
  if(!is.na(orcid)){
    orcid_result <- rorcid::orcid_id(orcid)
    a[[orcid]] <- orcid_result[[1]]$name$`family-name`$value
  } else {
    a[['NA']] <- "Qin"
  }
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


zz <- z %>% arrange(familyname) %>% 
  summarise(authors = 
              paste0(' - ', name, '^[', 
                     institution, 
                     ', orcid:', orcid,']')
            )

writeLines(zz$authors, 'authors.txt')
