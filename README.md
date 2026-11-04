# UFO Sightings Analysis

**Exploring when, where, and how UFO sightings are reported using R, Python, statistical testing, and data visualization.**

## Project Overview

This ongoing research project analyzes historical reports of unidentified flying objects (UFOs) to investigate patterns in sighting timing, duration, reported shape, and geography. The emphasis is on examining *reported observations* through reproducible data analysis—not establishing whether the reported objects were extraterrestrial.

The project began with exploratory analysis in **R** of sighting duration and time of day. It expanded into shape visualizations using **D3.js**, investigation of geographic patterns and **K-means clustering implemented from scratch in Python**, and exploratory classification of alien-themed movie descriptions. The separate analyses build on one another while addressing different research questions.

## Dataset

The primary worldwide dataset contains **more than 80,000 reported sightings**. Each record describes a reported event and includes fields such as date and time, city, state, country, shape, duration, comments, posting date, latitude, and longitude.

For the geographic clustering study, the original worldwide scope was narrowed to an **approximate rectangular area around the contiguous United States**. This focuses the comparison on a more geographically consistent region, but the rectangular coordinate filter is **not an exact national-border filter** and may include some nearby Canadian or Mexican reports.

The final geographic K-means experiments used **70,877 observations**. Reported shape categories were standardized and rare categories removed for shape comparisons; `other` was combined with `unknown`.

## Research Areas

### 1. R: Sighting Duration and Time of Day

The original statistical analysis investigates when sightings are reported and how long they last. Work includes data preparation, descriptive summaries, visualizations, handling of extreme durations, statistical hypothesis tests, and regression analysis. Because durations are highly skewed, the analysis examines transformed values and methods suited to non-normal data.

**Source:** [`R/UFO_Statistical_Analysis.Rmd`](R/UFO_Statistical_Analysis.Rmd)

### 2. D3.js: Reported UFO Shapes

The D3 visualization summarizes frequent reported shapes. Symbols represent reported shape categories, symbol size reflects report frequency, and labels include average reported duration in seconds.

The original README linked to this project at [`data/d3_ufo_shapes/`](data/d3_ufo_shapes/); verify this directory against the current repository before publishing.

### 3. Python: Geographic K-Means Clustering

The geographic study began with worldwide exploration, then narrowed the study area to the contiguous U.S. region. The research questions were:

- Can sightings be organized into interpretable geographic clusters?
- Do reported UFO shape proportions differ across those regions?
- Are the differences statistically detectable, and are they practically meaningful?

The analysis converted geographic latitude and longitude to **Earth-centered X, Y, Z coordinates** for distance calculations. A **custom K-means implementation**, written using NumPy operations rather than a prebuilt K-means clustering function, repeatedly assigns reports to centroids and updates centroid positions until convergence.

To evaluate the number of clusters, the project ran **five initializations for each `k` from 2 to 20 (95 experiments)**, recorded within-cluster sum of squares (WCSS), and plotted an elbow curve. The curve suggested **six clusters as a reasonable candidate**, though not a uniquely proven optimum.

**Key results:**

| Measurement | Finding |
| --- | --- |
| Records in geographic K-means analysis | 70,877 |
| Candidate geographic clusters | 6 |
| Best tested initialization for `k = 6` | Seed 3 |
| Best WCSS at `k = 6` | Approximately 13.654 billion km² |
| Shape vs. geographic cluster chi-square | χ² = 404.501, df = 95 |
| Chi-square p-value | Approximately 8.41 × 10⁻⁴⁰ |
| Cramér's V | 0.0338 (extremely weak association) |

The resulting clusters form recognizable geographic groupings. Although shape proportions differ statistically across clusters, the association is **extremely weak**: geography alone offers little information about which shape a report will describe.

**Notebook:** [`notebooks/Cluster_ufo_types_v.5.ipynb`](notebooks/Cluster_ufo_types_v.5.ipynb)

### 4. Python: Alien-Themed Movie Descriptions

A separate notebook explores thematic classification of movie descriptions as part of a broader investigation into potential cultural influences on UFO reporting. This is an exploratory line of research; no causal relationship between movie releases and UFO reports is claimed here.

**Notebook:** [`notebooks/Thematic_classification_of_movie_descriptions.ipynb`](notebooks/Thematic_classification_of_movie_descriptions.ipynb)

## Methods and Tools

| Area | Tools / methods |
| --- | --- |
| Statistical analysis | R, R Markdown, hypothesis testing, regression |
| Python analysis | Python, pandas, NumPy, SciPy, Matplotlib, Jupyter notebooks |
| Clustering | Manually implemented K-means, WCSS, repeated random starts, elbow method |
| Visualization | R plots, Matplotlib, D3.js |
| Data handling and version control | CSV, JSON, command-line tools, Git, GitHub |

## Repository Guide

| Path | Contents |
| --- | --- |
| [`R/`](R/) | R and R Markdown analysis |
| [`notebooks/`](notebooks/) | Python notebooks, including clustering and movie-description classification |
| [`data/`](data/) | UFO datasets and related data files |
| `analysis/` | Earlier analysis scripts, if retained in the repository |
| `README.md` | Project overview and links to analyses |

Additional visualizations and rendered reports may live elsewhere in the repository; their links should be confirmed after the folder reorganization.

## Limitations

- These are **self-reported sightings**, not independently verified physical events.
- Areas with more reports may also have larger populations or different reporting practices; the geographic analysis does not normalize for population.
- The geographic filter is a **bounding box**, not a precise U.S. border.
- K-means requires choosing `k`, is sensitive to initialization, and assigns every observation to a cluster even without sharp natural boundaries.
- Statistical significance can coexist with very small practical effects, as the shape-versus-cluster results illustrate.

## Future Work

Potential extensions include population-adjusted sighting rates, changes across decades, comparisons with density-based clustering methods, and further investigation of whether movie releases correlate with reported sightings. Such analyses would require additional controls before drawing causal conclusions.

## Reproducing the Analysis

Open the relevant R Markdown file or Jupyter notebook and follow its data-loading instructions. Required data files and relative paths should be checked for the current repository layout, particularly after moving scripts into `R/` and `notebooks/`. The Python notebook uses standard data-analysis libraries rather than a prebuilt K-means function.
