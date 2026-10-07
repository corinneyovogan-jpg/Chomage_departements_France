#============================================================================
#Projet: Déterminants du chômage départemental en France

#Auteure: Sylvia Corinne YOVOGAN
#============================================================================

## Installation et chargement des packages
# Installation (si besoin)
# install.packages(c("tidyverse", "readxl", "lmtest", "sandwich", "car"))
library(tidyverse)
library(readxl)
library(lmtest) # pour le test de l'hétéroscédasticité
library(sandwich) # pour les erreurs-types robustes
library(car) # pour le test de multicolinéarité

## Import et nettoyage des données

# Diplômes du supérieur (2021)
diplomes <- read_excel("data/indic_sex_rp.xlsx", sheet = "Data", skip = 4)
diplomes <- filter(diplomes, sexe == "T", an == "2021")
diplomes <- select(diplomes, codgeo, libgeo, p_diplsup15)

# Chômage (2021, 4e trimestre)
chomage <- read_excel("data/famille_TAUX-CHOMAGE_18092026.xlsx",sheet = "valeurs_trimestrielles")
names(chomage)[1] <- "libelle"
chomage <- filter(chomage, str_detect(libelle, "par département"))
chomage <- mutate(chomage, libgeo = str_remove(libelle, "Taux de chômage localisé par département - "))
chomage <- select(chomage, libgeo, `2021-T4`)
names(chomage) <- c("libgeo", "taux_chomage_2021")

# Part des jeunes 18-24 ans (2022)
jeunes <- read_excel("data/part_18_24_ans.xlsx", sheet = "Data", skip = 4)
jeunes <- filter(jeunes, an == "2022")
jeunes <- select(jeunes, libgeo, part_pop1824)

# Part de l'emploi industriel (2022)
industrie <- read_excel("data/part_emploi_industriel.xlsx", sheet = "Data", skip = 4)
industrie <- filter(industrie, an == "2022")
industrie <- select(industrie, libgeo, part_emplt_indus)

## Fusion des 4 variables dans un seul tableau
donnees <- inner_join(diplomes, chomage, by = "libgeo")
donnees <- inner_join(donnees, jeunes, by = "libgeo")
donnees <- inner_join(donnees, industrie, by = "libgeo")

# Vérification
nrow(donnees)
summary(donnees)

## Statistiques descriptives et graphique
ggplot(donnees, aes(x = p_diplsup15, y = taux_chomage_2021)) + geom_point() +
  labs(title = "Chômage et diplômes du supérieur par département (2021)",
    x = "Part de diplômés du supérieur (%)",
    y = "Taux de chômage (%)")

## Regression linéaire multiple (modèle complet avec DOM)
modele <- lm(taux_chomage_2021 ~ p_diplsup15 + part_pop1824 + part_emplt_indus, data = donnees)
summary(modele)

# Vérification de l'hétéroscédasticité
bptest(modele)

# Correction par erreurs-types robustes
coeftest(modele, vcov = vcovHC(modele, type = "HC1"))

# Identification des valeurs influentes
plot(modele, which = 4)
donnees[c(97, 100), ]

## Modèle final : France métropolitaine sans les DOM
donnees_metropole <- filter(donnees, !codgeo %in% c("971", "972", "973", "974", "976"))
modele_final <- lm(taux_chomage_2021 ~ p_diplsup15 + part_pop1824 + part_emplt_indus, data = donnees_metropole)
summary(modele_final)

# Vérification de l'hétéroscédasticité sur le modèle final
bptest(modele_final)

# Correction par erreurs-types robustes
coeftest(modele_final, vcov = vcovHC(modele_final, type = "HC1"))

# Vérification de la multicolinéarité
vif(modele_final) 






