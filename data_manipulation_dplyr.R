library(data.table)
library(dplyr)

# Require access SNOMED CT content

# Read required files
language <- fread("./Language/der2_cRefset_LanguageSnapshot.txt", colClasses = 'character')
Concept <- fread("./Terminology/sct2_Concept_Snapshot.txt", colClasses = 'character')
description <- fread("./Terminology/sct2_Description_Snapshot.txt", colClasses = 'character')
ExtendedMapFull <- fread("./Terminology/snomed/SNOMEDCT_InternationalRF2/Full/Refset/Map/der2_iisssccRefset_ExtendedMapFull.txt", colClasses = 'character')


# Dataset of Active concept, Fully specified name for description & Preferred acceptability
medical_terminology <- Concept %>%
  left_join(description, by = c("id" = "conceptId"), keep=FALSE) %>%
  left_join(language, by = c("id.y" = "referencedComponentId"), keep=FALSE) %>%
  filter(active.x == "1", typeId == "900000000000003001", refsetId == "900000000000509007", acceptabilityId == "900000000000548007") %>%
  select(term, id.y)

# Dataset for concepts synonym
synonym <- Concept %>%
  left_join(description, by = c("id" = "conceptId"), keep=FALSE) %>%
  left_join(language, by = c("id.y" = "referencedComponentId"), keep=FALSE) %>%
  filter(active.x == "1", typeId == "900000000000013009", refsetId == "900000000000509007", acceptabilityId == "900000000000549004") %>%
  select(term, id.y)

# Mapping snomded ct terminology to ICD10
snomedct_icd10 <- ExtendedMapFull %>%
  left_join(synonym, by = c("referencedComponentId" = "id.y")) %>%
  na_if("") %>%
  filter(!is.na(mapTarget)) %>%
  distinct(mapTarget, referencedComponentId)
  



