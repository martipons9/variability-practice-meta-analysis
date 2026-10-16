# Practice variability in early sport-specific skill learning: A systematic review and meta-analysis

## Overview

This repository contains the data and R code supporting a systematic review and meta-analysis examining the effects of variability-based interventions on sport-specific skill learning in novice performers.

The review synthesizes evidence comparing different practice conditions that vary in the amount or organization of practice variability. Where sufficient comparable evidence is available, quantitative syntheses are conducted to examine outcomes across practice conditions and evaluation stages.

## Repository Contents

```text
.
├── README.md
├── data/
│   ├── meta_database.xlsx
│   └── data_dictionary.md
└── R/
    └── meta_analysis.R
```

- **`data/meta_database.xlsx`**: Database containing the study-level information and numerical data used in the analyses.
- **`data/data_dictionary.md`**: Description of the database variables, their meanings, and coding conventions.
- **`R/meta_analysis.R`**: R script used to conduct the meta-analyses and associated analyses, including sensitivity analyses and assessments of potential publication bias.

## Data

The database includes information on study characteristics, sport-specific skills, learning outcomes, evaluation time points, practice-condition comparisons, and the sample sizes, means, and standard deviations required for quantitative synthesis.

The data are organized by comparison, outcome, and evaluation stage, including acquisition, retention, and transfer where applicable. Variable definitions and coding conventions are provided in the data dictionary.

The database contains the data required to reproduce the analyses reported in the review, subject to the availability and comparability of the evidence for each synthesis.

## Analyses

The analyses were conducted in R using the `meta` and `metafor` packages, alongside additional packages for data management and visualization.

The analysis script includes:

- Standardized mean differences using Hedges' *g*.
- Random-effects meta-analysis where the available evidence meets the specified eligibility criteria for quantitative synthesis.
- Forest plots summarizing the results of the meta-analyses.
- Leave-one-out sensitivity analyses to examine the influence of individual studies on pooled estimates.
- Assessments of potential publication bias when the number of effect sizes is sufficient.
- Additional analyses, including trim-and-fill, where specified in the script.

Not all comparisons or evaluation stages necessarily yield a meta-analysis; quantitative synthesis depends on the availability of a sufficient number of independent studies with comparable practice conditions and outcomes.

## Reproducibility

To reproduce the analyses:

1. Install [R](https://www.r-project.org/) and [RStudio](https://posit.co/download/rstudio-desktop/), if desired.
2. Clone or download this repository.
3. Install the R packages required by the script if they are not already installed.
4. Open `R/meta_analysis.R` and set the working directory to the local root directory of the repository.
5. Check that the input file path in the script points to `meta_database.xlsx`.
6. Run the script.

The script and data are provided to facilitate transparency and reproducibility. Differences in software versions or computing environments may affect some outputs.

## Scope and Interpretation

The findings should be interpreted in light of the characteristics and methodological quality of the included studies, the comparability of practice interventions, and the availability of evidence for each outcome and evaluation stage. The repository supports the analyses reported in the review and is not intended to imply that all practice conditions or outcomes can be compared quantitatively.

## Citation

If you use the data or code in this repository, please cite the associated systematic review and meta-analysis once its bibliographic details are available.

**Publication:** To be added.

**DOI:** To be added.

## License

A license will be specified for the repository's code and data. Until a license is added, reuse and redistribution should not be assumed to be permitted.

## Contact

For questions about the repository, the database, or the analysis code, please contact the corresponding author of the associated review.
