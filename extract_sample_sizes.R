## Extract per-study, per-arm participant N for the primary RoBMA analysis
## (data_main, k = 12 — Singleton et al.'s own published primary model).
## Mirrors the data_main filter chain in psilodep-robma.Rmd exactly.

library(metapsyData)
library(metapsyTools)
library(tidyverse)

## Pinned to the exact version cited in the published paper's own reference
## list ("Version 25.1.2", doi:10.5281/zenodo.15714852; verified directly
## against natmh2026.pdf). getData() defaults to "latest", which is a living
## database that keeps growing as new trials are added — do not remove this
## version pin. (An earlier version of this script was pinned to 25.0.4,
## which matches Singleton et al.'s medRxiv preprint, not the published paper
## this Matters Arising responds to — do not revert to that version.)
d    <- getData("depression-psiloctr", version = "25.1.2")
data <- d$data

data_main <- data |>
  filterPoolingData(
    primary_instrument == "1",
    primary_timepoint  == "1",
    is.na(post_crossover) | !Detect(post_crossover, "1"),
    outcome_type == "msd" | outcome_type == "imsd",
    !(Detect(study, "Goodwin 2022") & (!is.na(multi_arm1)) & Detect(multi_arm1, "10 mg")),
    !(Detect(study, "Goodwin 2022") & (!is.na(multi_arm2)) & Detect(multi_arm2, "10 mg")),
    !Detect(study, "Krempien 2023"),
    !Detect(study, "Carhart-Harris 2021")
  )

stopifnot(n_distinct(data_main$study) == 12)

## multi_arm1/multi_arm2 included because condition_arm1/2 alone is
## ambiguous for multi-arm dose-ranging trials (Goodwin 2022, Krempien 2023)
## where both arms are labelled "psil" and only the dose column disambiguates
## which arm was retained.
sample_sizes <- data_main |>
  select(study, condition_arm1, condition_arm2, multi_arm1, multi_arm2,
         n_arm1, n_arm2) |>
  distinct() |>
  mutate(n_total = n_arm1 + n_arm2) |>
  arrange(study)

write.csv(sample_sizes, "sample_sizes_primary.csv", row.names = FALSE)

cat("Rows:", nrow(sample_sizes), "| studies:", n_distinct(sample_sizes$study), "\n")
cat("Total N pooled across primary analysis:", sum(sample_sizes$n_total), "\n\n")
sample_sizes |> as.data.frame() |> write.csv(stdout(), row.names = FALSE)
