# Data Dictionary

## Overview

The dataset contains extracted data from studies included in a systematic review and meta-analysis of variability-based interventions in sport-specific skill learning.

Each row represents a specific extracted dataset for a study or experiment, sport-specific skill, practice-regime comparison, learning outcome, and assessment time.

## Variable Definitions

| Variable | Description | Format / allowed values |
|---|---|---|
| `id` | Numeric identifier assigned to each study. The same identifier is used for all records from the same article. | Two-digit study identifier |
| `id_experiment` | Unique identifier for each extracted record. The first two digits correspond to the study identifier. | Unique code |
| `reference` | Reference to the original article, including the sport–skill abbreviation in parentheses. | Text |
| `sport` | Sport examined in the study. | Text |
| `sps` | Sport-specific skill (SpS) assessed. | Text |
| `skill_type` | Classification of the target skill according to its temporal structure. | `discrete` or `continuous` |
| `learning_outcome` | Performance outcome measured, such as accuracy, speed, or ball control. | Text |
| `evaluation_time` | Stage at which the outcome was assessed. | `acquisition`, `retention`, or `transfer` |
| `comparison` | Practice-regime comparison represented by the record. The first group is the control condition and the second is the experimental condition. | For example, `cons_vs_lci`, `lci_vs_hci` |
| `higher_better` | Indicates whether a higher numerical value represents better performance for the outcome. | `true` or `false` |
| `n.c` | Sample size in the control group (the first condition in `comparison`). | Positive integer |
| `n.e` | Sample size in the experimental group (the second condition in `comparison`). | Positive integer |
| `mean.c` | Mean outcome value for the control group. | Numeric |
| `sd.c` | Standard deviation of the outcome for the control group. | Numeric |
| `mean.e` | Mean outcome value for the experimental group. | Numeric |
| `sd.e` | Standard deviation of the outcome for the experimental group. | Numeric |

## Coding Conventions

### Study and record identifiers

- `id` identifies the original study.
- `id_experiment` identifies an individual extracted record and must be unique within the dataset.

### Practice-regime comparisons

The `comparison` variable identifies the two practice conditions being compared. The first condition represents the group exposed to **less practice variability**, and is coded as the control group (`.c`). The second condition represents the group exposed to **more practice variability**, and is coded as the experimental group (`.e`).

Examples include:

- `cons_vs_lci`: constant practice versus low contextual interference.
- `cons_vs_hci`: constant practice versus high contextual interference.
- `lci_vs_hci`: low versus high contextual interference.

The abbreviations should be interpreted consistently with the operational definitions adopted in the systematic review.

### Direction of performance

The `higher_better` variable indicates the direction of the outcome:

- `true`: higher values indicate better performance.
- `false`: lower values indicate better performance, as may occur with movement time or error measures.

This variable is used to ensure that effect directions are harmonised when calculating standardised mean differences.

### Missing data

Missing or unavailable values should be documented explicitly. The conventions used to represent missing values in the published dataset will be specified before release.

## Data Use

The dataset should be interpreted alongside the associated systematic review and meta-analysis. Study-level coding decisions and operational definitions are described in the review and its supplementary materials.
