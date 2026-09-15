# ufo-sightings-analysis
# UFO Sightings Analysis

## Project Overview

This project analyzes historical UFO sighting reports to identify patterns in when, where, and how sightings have been reported. The goal is to use statistical analysis, visualization, and data-processing techniques to better understand trends within the dataset.

The project began with an analysis of sighting duration and time of day. It will continue to expand by examining additional factors that may be associated with changes in reported UFO sightings, including geographic patterns, reported UFO shapes, and possible cultural influences such as movies and other popular media.

This project is also being used to practice working with several types of data tools and formats, including R, CSV, JSON, Web APIs, GitHub, and command-line tools.

## Dataset

The primary dataset contains historical UFO sighting reports. Each row represents an individual reported sighting.

The dataset includes information such as:

- Date and time of the sighting
- City
- State
- Country
- Reported UFO shape
- Duration of the sighting
- Written comments or descriptions
- Date the sighting was posted
- Latitude
- Longitude

The dataset contains more than 80,000 reported sightings.

## Current Analysis

The current stage of the project focuses on examining the relationship between the time of day and the reported duration of UFO sightings.

Because sighting durations contain several very large outliers, the analysis also considers transformed duration values and statistical methods that are more appropriate for highly skewed data.

The analysis includes:

- Data cleaning and preparation
- Summary statistics
- Visualization of sighting duration
- Comparison of sightings across different times of day
- Statistical hypothesis testing
- Regression analysis

## Future Analysis

Future stages of the project may expand the analysis to investigate additional questions, including:

- Whether UFO sightings vary by geographic location
- Which UFO shapes are reported most frequently
- Whether sightings change over time
- Whether major cultural events or movies involving aliens are associated with changes in UFO sighting reports
- Whether other historical or technological events correspond with changes in reported sightings

## Files

- `UFO_Statistical_Analysis.Rmd` – R Markdown source file containing the statistical analysis
- `UFO_Statistical_Analysis.html` – Rendered HTML version of the analysis
- `data/ufo_sightings.csv` – UFO sighting dataset
- `analysis/` – Earlier R scripts and analysis files

## Tools and Technologies

This project uses:

- R
- R Markdown
- CSV
- JSON
- Git
- GitHub
- GitHub Pages
- Web APIs
- `curl`
- `jq`

## Statistical Analysis

The current statistical analysis can be viewed here:

[View the UFO Statistical Analysis](UFO_Statistical_Analysis.html)
