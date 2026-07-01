------------------------------------------------------------------------

editor_options: markdown: wrap: 72 ---

# Publication bias in psilocybin depression trials: a RoBMA re-analysis

[![Status](https://img.shields.io/badge/status-under%20review-orange)]() [![R](https://img.shields.io/badge/R-4.6.1-blue)](https://cran.r-project.org/) [![RoBMA](https://img.shields.io/badge/RoBMA-4.0.0-blue)](https://cran.r-project.org/package=RoBMA) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Overview

This repository contains the full reproducibility code for an independent re-analysis of Singleton et al. (2026), submitted as a **Matters Arising** to *Nature Mental Health*.

**Target paper:** \> Singleton SP, Sevchik BL, Lahey A, Cuijpers P, Harrer M, Jones MT, Nayak SM, \> Strain EC, Vandekar SN, Dworkin RH, Scott JC, & Satterthwaite TD. A living \> systematic review, meta-analysis and open-data resource of randomized controlled \> trials of psilocybin treatment for symptoms of depression. \> *Nature Mental Health* (2026).

**Open dataset:** Singleton P, Harrer M & Sevchik B. `metapsy-project/data-depression-psiloctr`. Zenodo (2025). <https://doi.org/10.5281/zenodo.17657950>

------------------------------------------------------------------------

## What we did

Singleton et al. assessed publication bias using Egger's test (p = 0.21, non-significant) — a method with low power at k = 12 studies that provides no bias-corrected effect estimate. We applied **Robust Bayesian Meta-Analysis** (RoBMA; Maier, Bartoš & Wagenmakers, 2022) to the same open dataset using identical inclusion criteria.

RoBMA fits an ensemble of 12 models simultaneously varying effect presence, heterogeneity, and publication bias (via Vevea–Hedges step-weight functions and PET-PEESE), delivering Bayes Factors for each component and a model-averaged, bias-corrected posterior.

------------------------------------------------------------------------

## Key results

| Analysis | k | Published g | RoBMA μ [95% CrI] | BF_pb |
|---------------|---------------|---------------|---------------|---------------|
| Primary (single-level) | 12 | 0.90 [0.55, 1.26] | 0.53 [0.00, 1.00] | **3.90** |
| Excl. open-label | 9 | 0.81 [0.60, 1.03] | 0.77 [0.00, 0.99] | 0.73 |
| Multilevel (all timepoints) | 37 (12 clusters) | 0.82 [0.57, 1.08]† | 0.00 [−0.15, 0.77] | **28.27** |

†CHE model estimate (Singleton et al.); multilevel result is exploratory.

**Primary finding:** Moderate evidence for publication bias (BF_pb = 3.90; posterior probability = 0.80). The bias-corrected pooled effect (g ≈ 0.53) is 41% smaller than the published value, with a credible interval spanning to zero. The bias signal dissipates when open-label studies or the Davis (2021) outlier are excluded, suggesting design-specific expectancy inflation rather than file-drawer suppression of blinded trials.

------------------------------------------------------------------------

## Repository structure

```         
sypres/
├── psilodep-robma.Rmd            # Main analysis — set run_fresh = TRUE/FALSE here
├── ED_Table1_comprehensive_results.csv  # Extended Data Table 1 (all RoBMA runs)
├── fig1_robma_main.jpg           # Main Figure 1 (three-panel)
├── fig_ED1_prior_sensitivity.jpg # Extended Data Figure 1: prior sensitivity
├── fig_ED2_dichotomous.jpg       # Extended Data Figure 2: response and remission
│
├── psilodep-robma-results.RData  # Pre-computed RoBMA models
├── .gitignore
└── README.md
```

------------------------------------------------------------------------

## Reproducing the analysis

### Quick start (pre-computed models, \~2 min to knit)

1.  Clone the repository
2.  Open `psilodep-robma.Rmd` — confirm `run_fresh <- FALSE` at the top
3.  Knit the document

### Full rerun from scratch (\~90 min)

Set `run_fresh <- TRUE` in `psilodep-robma.Rmd`. This fits all 14 RoBMA models (primary, 5 subgroups, 5 sensitivities, response, remission, multilevel) and saves `psilodep-robma-results.RData`.

------------------------------------------------------------------------

## System requirements

| Requirement | Version tested | Notes |
|------------------------|------------------------|------------------------|
| R | 4.6.1 |  |
| JAGS | 4.3.2 | Required by RoBMA. Install from <https://mcmc-jags.sourceforge.io/> |
| RoBMA | 4.0.0 | On Apple Silicon (M-series), install from source — see below |
| metapsyData | ≥ 0.2 | Provides the open dataset |
| metapsyTools | ≥ 1.0 | Data filtering utilities |
| tidyverse, ggplot2 | current CRAN |  |
| magick | 2.9.1 | Requires ImageMagick system library |
| patchwork, cowplot | current CRAN |  |
| pdftools | 3.9.0 | Required by magick for PDF→PNG conversion |
| png, bayesmeta, dmetar | current CRAN |  |

### Apple Silicon note

The CRAN binary of RoBMA links against `/usr/local/lib/libjags.4.dylib` (Intel path). On Apple Silicon, install JAGS via Homebrew and build RoBMA from source:

``` r
# 1. Install JAGS
system("brew install jags")

# 2. Add to ~/.R/Makevars (adjust GCC version as needed)
# FLIBS=-L/opt/homebrew/Cellar/gcc/16.1.0/lib/gcc/current/gcc/aarch64-apple-darwin25/16
#   -lemutls_w -lheapt_w -L/opt/homebrew/Cellar/gcc/16.1.0/lib/gcc/current -lgfortran

# 3. Install from source
install.packages("RoBMA", type = "source")
```

------------------------------------------------------------------------

## Seed

All MCMC models use `seed = 4821`. Results may differ slightly across platforms due to JAGS compiler differences; the conclusions are robust to these variations (R-hat ≤ 1.01 for all parameters).

------------------------------------------------------------------------

## Citation

If you use this code, please cite:

> Çağrı Özkurt. Publication bias in randomized trials of psilocybin for depression: a Robust Bayesian Meta-Analysis. *Nature Mental Health* Matters Arising (under review, 2026). [DOI to be added]

And the methods paper:

> Maier M, Bartoš F & Wagenmakers E-J. Robust Bayesian meta-analysis: addressing publication bias with model-averaging. *Psychological Methods* 28(1), 107–122 (2022). <https://doi.org/10.1037/met0000405>

For the multilevel extension:

> Bartoš F, Maier M & Wagenmakers E-J. Robust Bayesian multilevel meta-analysis: adjusting for publication bias in the presence of dependent effect sizes. *Behavior Research Methods* (2026). <https://doi.org/10.3758/s13428-026-03023-y>

------------------------------------------------------------------------

## License

MIT — see [LICENSE](LICENSE). The analysis code is freely reusable.

------------------------------------------------------------------------
