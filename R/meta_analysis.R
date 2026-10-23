#############################################################
#################### META-ANALYSIS SCRIPT ###################
#############################################################

### Working directory
# Set the working directory to the folder containing
# the downloaded dataset and the R script.
# Replace the path below with your local folder path.

setwd("C:/Users/YourName/variability-practice-meta-analysis")

#############################################################
### Load packages
#############################################################

library(readxl)
library(meta)
library(metafor)
library(dmetar)
library(tidyverse)
library(rcompanion)
library(ggplot2)

#############################################################
### Load database
#############################################################

meta_database <- read_excel("meta_database.xlsx")

#############################################################
### Format variables
#############################################################

meta_database <- meta_database %>%
  mutate(
    
    sport = factor(sport),
    sps = factor(sps),
    skill_type = factor(skill_type),
    learning_outcome = factor(learning_outcome),
    evaluation_time = factor(evaluation_time),
    comparison = factor(comparison),
    
    higher_better = case_when(
      higher_better %in% c(TRUE, "true", 1) ~ TRUE,
      higher_better %in% c(FALSE, "false", 0) ~ FALSE,
      TRUE ~ NA
    )
    
  )

#############################################################
### Remove incomplete comparisons
#############################################################

required_variables <- c(
  
  "comparison",
  "evaluation_time",
  "learning_outcome",
  
  "higher_better",
  
  "n.c",
  "n.e",
  
  "mean.c",
  "mean.e",
  
  "sd.c",
  "sd.e"
  
)

meta_database <- meta_database %>%
  filter(complete.cases(across(all_of(required_variables))))

#############################################################
### Reverse outcomes where lower values indicate
### better performance
#############################################################

reverse <- meta_database$higher_better == FALSE

meta_database$mean.c[reverse] <- -meta_database$mean.c[reverse]
meta_database$mean.e[reverse] <- -meta_database$mean.e[reverse]

#############################################################
### Outcome groups
#############################################################

accuracy_outcomes <- c(
  "accuracy",
  "accuracy (error)",
)

speed_outcomes <- c(
  "speed"
)

outcome_sets <- list(
  Accuracy = accuracy_outcomes,
  Speed = speed_outcomes
)

#############################################################
### Labels for comparisons
#############################################################

comparison_labels <- list(
  
  cons_vs_lci = c(
    "Constant",
    "Low CI"
  ),
  
  cons_vs_hci = c(
    "Constant",
    "High CI"
  ),
  
  cons_vs_dl = c(
    "Constant",
    "DL"
  ),
  
  lci_vs_hci = c(
    "Low CI",
    "High CI"
  ),
  
  lci_vs_dl = c(
    "Low CI",
    "DL"
  ),
  
  hci_vs_dl = c(
    "High CI",
    "DL"
  ),
  
  lp_vs_nlp = c(
    "LP",
    "NLP"
  )
  
)

#############################################################
### Function to run a meta-analysis
#############################################################

run_meta <- function(data,
                     comparison_name,
                     outcomes_selected,
                     evaluation_stage){
  
  data_subset <- data %>%
    filter(
      
      comparison == comparison_name,
      evaluation_time == evaluation_stage,
      learning_outcome %in% outcomes_selected
      
    )
  
  if(nrow(data_subset) < 3){
    
    message("---------------------------------------")
    message(comparison_name)
    message(evaluation_stage)
    message("Not enough comparisons (n = ",
            nrow(data_subset), ")")
    message("---------------------------------------")
    
    return(NULL)
    
  }
  
  meta_object <- metacont(
    
    n.e = n.e,
    mean.e = mean.e,
    sd.e = sd.e,
    
    n.c = n.c,
    mean.c = mean.c,
    sd.c = sd.c,
    
    studlab = reference,
    
    data = data_subset,
    
    sm = "SMD",
    method.smd = "Hedges",
    
    fixed = FALSE,
    random = TRUE,
    
    method.tau = "REML",
    method.random.ci = "HK",
    
    title = paste(
      comparison_name,
      evaluation_stage,
      sep = " | "
    )
    
  )
  
  print(summary(meta_object))
  
  return(meta_object)
  
}

#############################################################
### Function to draw forest plots
#############################################################

plot_meta <- function(meta_object, comparison_name){
  
  if(is.null(meta_object)) return(NULL)
  
  labels <- comparison_labels[[comparison_name]]
  
  forest(
    meta_object,
    
    label.c = labels[1],
    label.e = labels[2],
    
    leftcols = c("studlab",
                 "n.c", "mean.c", "sd.c",
                 "n.e", "mean.e", "sd.e"),
    
    leftlabs = c("Study",
                 "Total", "Mean", "SD",
                 "Total", "Mean", "SD"),
    
    digits = 2,
    digits.mean = 2,
    digits.sd = 2,
    
    label.left = paste("Favors", labels[1]),
    label.right = paste("Favors", labels[2])
    
    
  )
  
}

#############################################################
### Comparisons to analyse
#############################################################

comparisons <- c(
  
  "cons_vs_lci",
  "cons_vs_hci",
  "cons_vs_dl",
  "lci_vs_hci",
  "lci_vs_dl",
  "hci_vs_dl",
  "lp_vs_nlp"
  
)

#############################################################
### Evaluation times
#############################################################

evaluation_times <- c(
  
  "acquisition",
  "retention",
  "transfer"
  
)

#############################################################
### Object to store results
#############################################################

meta_results <- list()

#############################################################
### Run all eligible meta-analyses
#############################################################

pdf(
  "Forest_plots_all_meta_analyses.pdf",
  width = 12,
  height = 8
)

for(outcome_name in names(outcome_sets)){
  
  for(comp in comparisons){
    
    for(eval in evaluation_times){
      
      cat("\n=========================================\n")
      cat(outcome_name, "|", comp, "|", eval, "\n")
      cat("=========================================\n")
      
      meta_object <- run_meta(
        
        data = meta_database,
        
        comparison_name = comp,
        
        outcomes_selected = outcome_sets[[outcome_name]],
        
        evaluation_stage = eval
        
      )
      
      if(!is.null(meta_object)){
        
        object_name <- paste(
          
          outcome_name,
          comp,
          eval,
          
          sep = "_"
          
        )
        
        meta_results[[object_name]] <- meta_object
        
        plot_meta(
          
          meta_object,
          comparison_name = comp
          
        )
        
      }
      
    }
    
  }
  
}

dev.

#############################################################
### Summary of successful meta-analyses
#############################################################

cat("\n\n")
cat("=========================================\n")
cat("META-ANALYSES COMPLETED\n")
cat("=========================================\n")

names(meta_results)

length(meta_results)

#############################################################
### Sensitivity analysis (leave-one-out)
#############################################################

sensitivity_results <- list()
sensitivity_summary <- data.frame()

for(name in names(meta_results)){
  
  cat("\n=========================================\n")
  cat("Sensitivity analysis:", name, "\n")
  cat("=========================================\n")
  
  sens <- metainf(meta_results[[name]])
  
  sensitivity_results[[name]] <- sens
  
  print(summary(sens))
  
  # Original pooled estimates
  original_SMD <- meta_results[[name]]$TE.random
  original_p   <- meta_results[[name]]$pval.random
  original_I2  <- meta_results[[name]]$I2
  
  for(i in seq_along(sens$studlab)){
    
    sensitivity_summary <- rbind(
      sensitivity_summary,
      data.frame(
        
        Meta_analysis = name,
        
        Omitted_study = sens$studlab[i],
        
        Original_SMD = round(original_SMD, 3),
        
        New_SMD = round(sens$TE[i], 3),
        
        Delta_SMD = round(
          abs(original_SMD - sens$TE[i]), 3
        ),
        
        Original_p = round(original_p, 3),
        
        New_p = round(sens$pval[i], 3),
        
        P_changed =
          (original_p >= 0.05 & sens$pval[i] < 0.05) |
          (original_p < 0.05 & sens$pval[i] >= 0.05),
        
        Original_I2 = round(100 * original_I2, 1),
        
        New_I2 = round(100 * sens$I2[i], 1),
        
        Delta_I2 = round(
          100 * (original_I2 - sens$I2[i]), 1
        )
        
      )
    )
    
  }
}

#############################################################
### Forest plots - Leave-one-out sensitivity analyses
#############################################################

get_favors_labels <- function(name) {
  
  comparison <- sub(
    "^[^_]+_(.*)_(Acquisition|Retention|Transfer)$",
    "\\1",
    name
  )
  
  groups <- strsplit(comparison, "_vs_")[[1]]
  
  label_map <- c(
    "Cons" = "Constant",
    "LCI"  = "Low CI",
    "HCI"  = "High CI",
    "DL"   = "DL"
  )
  
  groups <- label_map[groups]
  
  paste(
    paste("Favors", groups[1]),
    "           ",
    paste("Favors", groups[2])
  )
}


pdf(
  "Sensitivity_analysis_forest_plots.pdf",
  width = 12,
  height = 8
)

for(name in names(meta_results)){
  
  sens <- metainf(meta_results[[name]])
  
  favors_labels <- get_favors_labels(name)
  
  forest(
    sens,
    xlab = favors_labels
  )
  
}

dev.off()

#############################################################
### Potentially influential studies
#############################################################

influential_studies <- subset(
  sensitivity_summary,
  P_changed == TRUE |
    Delta_I2 > 30 |
    Delta_SMD > 0.30
)

View(influential_studies)

#############################################################
### Publication bias
#############################################################

publication_bias_results <- data.frame()

for(meta_name in names(meta_results)){
  
  meta_object <- meta_results[[meta_name]]
  
  # Number of independent studies and effect sizes
  k_study <- meta_object$k.study
  k_effect <- meta_object$k
  
  # Assess publication bias only when there are at least 10 effect sizes
  if(k_effect >= 10){
    
    cat("\n=========================================\n")
    cat("Publication bias:", meta_name, "\n")
    cat("=========================================\n")
    
    ##################################################
    ### Funnel plot
    ##################################################
    
    funnel(
      meta_object,
      studlab = FALSE,
      xlab = "Standardized Mean Difference (Hedges' g)"
    )
    
    title(main = meta_name)
    
    ##################################################
    ### Egger regression test
    ##################################################
    
    egger <- metabias(
      meta_object,
      method.bias = "linreg"
    )
    
    print(egger)
    
    ##################################################
    ### Save results
    ##################################################
    
    publication_bias_results <-
      rbind(
        publication_bias_results,
        data.frame(
          Meta_analysis = meta_name,
          Studies = k_study,
          Effect_sizes = k_effect,
          Bias = egger$method.bias,
          p_value = egger$p.value
        )
      )
  }
}

publication_bias_results


##################################################
### Print Funnel Plots
##################################################

funnel_names <- c(
  "Accuracy_lci_vs_hci_acquisition" = "LCI vs HCI — Acquisition",
  "Accuracy_lci_vs_hci_retention"   = "LCI vs HCI — Retention",
  "Accuracy_lci_vs_hci_transfer"    = "LCI vs HCI — Transfer"
)

pdf(
  "Funnel_plots_publication_bias.pdf",
  width = 8,
  height = 8
)

for(name in names(funnel_names)){
  
  funnel(
    meta_results[[name]],
    studlab = FALSE,
    xlab = "Standardized Mean Difference (Hedges' g)"
  )
  
  title(main = funnel_names[name])
}

dev.off()
