install.packages("tidyverse")
install.packages("readxl")
library(tidyverse)
library(readxl)
# Import du fichier
diplomes <- read_excel("data/indic_sex_rp.xlsx", sheet = "Data", skip = 4)

# Filtrage des lignes
diplomes <- filter(diplomes, sexe == "T", an == "2021")

# Sélection des colonnes
diplomes <- select(diplomes, codgeo, libgeo, p_diplsup15)

head(diplomes)

# Import du fichier chômage
## Import du fichier chômage
chomage <- read_excel(
  "data/famille_TAUX-CHOMAGE_29092026/famille_TAUX-CHOMAGE_18092026.xlsx",
  sheet = "valeurs_trimestrielles"
)

# On renomme tout de suite la 1ère colonne pour éviter les soucis d'accent
names(chomage)[1] <- "libelle"

# On ne garde que les lignes qui concernent les départements (pas les régions)
chomage <- filter(chomage, str_detect(libelle, "par département"))

# On extrait le nom du département à partir du libellé
chomage <- mutate(chomage, libgeo = str_remove(libelle, "Taux de chômage localisé par département - "))

# On garde seulement le nom du département et le taux du 4e trimestre 2021
chomage <- select(chomage, libgeo, `2021-T4`)

# On renomme la dernière colonne
names(chomage) <- c("libgeo", "taux_chomage_2021")

head(chomage)

# On fusionne les deux tableaux à partir du nom du département (libgeo)
donnees <- inner_join(diplomes, chomage, by = "libgeo")

# Aperçu du résultat
head(donnees)

# Combien de départements ont bien été appariés ?
nrow(donnees)

# Statistiques descriptives rapides
summary(donnees$p_diplsup15)
summary(donnees$taux_chomage_2021)

# Graphique : chômage en fonction du niveau de diplôme
ggplot(donnees, aes(x = p_diplsup15, y = taux_chomage_2021)) +
  geom_point() +
  labs(
    title = "Chômage et diplômes du supérieur par département (2021)",
    x = "Part de diplômés du supérieur (%)",
    y = "Taux de chômage (%)"
  )





