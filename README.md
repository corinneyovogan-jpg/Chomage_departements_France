# Déterminants du chômage départemental en France

Projet d'économétrie — M1 Économie Appliquée, parcours SciDE, Université de Lille
Auteure : Sylvia Corinne Yovogan

## Question de recherche

Quels facteurs expliquent les écarts de taux de chômage entre les départements français ?

## Données

| Variable | Source | Année |
|---|---|---|
| Taux de chômage | INSEE | 2021 (T4) |
| Part de diplômés du supérieur | Observatoire des Territoires (INSEE) | 2021 |
| Part des 18-24 ans dans la population | Observatoire des Territoires (INSEE) | 2022 |
| Part de l'emploi industriel | Observatoire des Territoires (INSEE) | 2022 |

Les variables issues du recensement (diplômes, jeunes, industrie) ne sont pas toutes disponibles pour la même année exacte. L'année la plus récente disponible a été retenue pour chacune : le taux de chômage et les diplômes datent de 2021, la part des jeunes et l'emploi industriel du dernier recensement disponible (2022).

## Méthode

Une régression linéaire multiple (MCO) est estimée sur les départements français :
taux_chomage = β₀ + β₁·diplômes + β₂·jeunes_18_24 + β₃·emploi_industriel + ε

Deux versions du modèle sont présentées :
- **Modèle complet** (100 départements, DOM inclus)
- **Modèle final** (95 départements, France métropolitaine uniquement)

La Guadeloupe et La Réunion ont été exclues du modèle final : l'analyse des valeurs influentes (distance de Cook) a montré que ces deux départements, dont les taux de chômage sont structurellement très élevés pour des raisons économiques et historiques spécifiques, constituaient des valeurs atypiques qui gonflaient artificiellement l'ajustement du modèle complet.

## Résultats (modèle final, France métropolitaine)

| Variable | Coefficient | Significativité |
|---|---|---|
| Part de diplômés du supérieur | -0,094 | *** |
| Part des 18-24 ans | +0,229 | * |
| Part de l'emploi industriel | -0,151 | *** |

*R² = 0,18 — le modèle explique 18 % de la variation du taux de chômage entre départements métropolitains.*

**Lecture des résultats** (toutes choses égales par ailleurs) :
- Une hausse d'1 point de la part de diplômés du supérieur est associée à une baisse de 0,09 point du taux de chômage.
- Une hausse d'1 point de la part des 18-24 ans est associée à une hausse de 0,23 point du taux de chômage.
- Une hausse d'1 point de la part de l'emploi industriel est associée à une baisse de 0,15 point du taux de chômage.

Ces résultats sont cohérents avec la littérature économique : un niveau de diplôme plus élevé facilite l'insertion professionnelle, les jeunes actifs sont structurellement plus exposés au chômage, et l'emploi industriel est associé à des bassins d'emploi plus stables dans certains territoires.

## Validité du modèle

- **Hétéroscédasticité** : détectée sur le modèle complet (test de Breusch-Pagan, p = 0,0007) et sur le modèle final (p = [ta valeur]). Des erreurs-types robustes (HC1) ont été utilisées dans les deux cas ; les variables restent statistiquement significatives après correction.
- **Multicolinéarité** : aucun problème détecté (VIF < 2 pour les trois variables du modèle final).
- **Valeurs influentes** : la Guadeloupe et La Réunion ont été identifiées comme atypiques (distance de Cook) et exclues du modèle final.

## Limites

- Ce modèle met en évidence des **associations statistiques**, et non des relations de causalité.
- Seules 3 variables sont incluses : d'autres facteurs (conjoncture locale, histoire économique du territoire, etc.) influencent très probablement le chômage départemental et ne sont pas captés ici (R² = 0,18).
- Les données ne couvrent pas toutes exactement la même année (2021-2022), par contrainte de disponibilité des sources.

## Structure du dépôt
├── analyse.R # Script R complet (import, nettoyage, régression, diagnostics)
├── data/ # Données sources (INSEE, Observatoire des Territoires)
└── README.md

## Reproduire l'analyse

1. Ouvrir le fichier `chomage-departements-france.Rproj` dans RStudio
2. Installer les packages si besoin (voir le haut de `analyse.R`)
3. Exécuter `analyse.R`
