---
title: "Made-up Moose Aerial Survey Report"
author: "Jane Biologist"
date: today
format: html
embed-resources: true
---

# Introduction

This report summarizes the findings from the moose aerial survey conducted across various regions. The data includes counts of adult moose and calves observed by different observers.

# Study Area

``` {r}
#| echo: false
#| message: false

library(httr)
library(sf)
library(leaflet)

get_refuge <- function(orgname = "Tetlin National Wildlife Refuge") {  # Get sf multipolygon of refuge boundary
  library(httr)
  library(sf)
  
  orgname <- toupper(orgname)
  
  message(paste("Downloading boundary layer for", orgname))
  
  url <- httr::parse_url("https://services.arcgis.com/QVENGdaPbd4LUkLV/arcgis/rest/services")
  url$path <- paste(url$path, "National_Wildlife_Refuge_System_Boundaries/FeatureServer/0/query", sep = "/")
  url$query <- list(where = paste("ORGNAME =", paste0("'",orgname,"'")),  # Arctic Refuge, in this case
                    outFields = "*",
                    returnGeometry = "true",
                    f = "pgeojson"
  )
  request <- httr::build_url(url)
  prop <- sf::st_read(request, quiet = TRUE)
  
  message("Done.")
  
  return(prop)
}

refuge <- suppressMessages(get_refuge("Innoko National Wildlife Refuge"))
pts <- sf::st_sample(refuge, 40)

leaflet(refuge) |> 
    addTiles(group = "OSM") |>
    addProviderTiles(providers$Esri.WorldStreetMap, 
                     group = "Base map") |>
    addPolygons(data = refuge,
                         fill = FALSE,
                         color = "black",
                         group = "Innoko NWR",
                         weight = 1) |>
    addCircleMarkers(data = pts,
                     radius = 0.5, 
                     color = "black", 
                     group = "Moose") |>
    addLayersControl(baseGroups = c("OSM",
                                    "ESRI World Imagery"),
                     overlayGroups = c("Moose", 
                                       "Innoko NWR"),
                     options = layersControlOptions(collapsed = FALSE)) |>
    addMiniMap(height = 100, width = 100) |>
    addScaleBar()
```


# Dataset Overview

The dataset consists of observations from various regions, recorded by multiple observers. The key variables are as follows:

- **Observer Name**: The individual conducting the survey.
- **Area**: The specific region surveyed.
- **Number of Adults**: The number of adult moose counted.
- **Number of Calves**: The number of calf moose counted.
- **Survey Date**: The date the survey was conducted.

Below is a snippet of the dataset:

```{r}
#| echo: false
#| message: false

# Load necessary packages
library(DT)

# Create the dataset
moose_data <- data.frame(
    Date = as.Date(c("2023-09-01", "2023-09-02", "2023-09-03", "2023-09-04", 
                          "2023-09-05", "2023-09-06", "2023-09-07", "2023-09-08", 
                          "2023-09-09", "2023-09-10")),
    Observer = c("John Doe", "Jane Smith", "Alex Johnson", "Emily Davis", 
                    "Michael Brown", "Sarah Wilson", "Tom White", "Linda Green", 
                    "Robert Black", "Karen Blue"),
  Area = c("Region A", "Region A", "Region B", "Region B", 
           "Region C", "Region C", "Region D", "Region D", 
           "Region E", "Region E"),
  Adults = c(25, 30, 20, 15, 18, 22, 29, 27, 26, 31),
  Calves = c(5, 4, 3, 2, 6, 7, 5, 4, 3, 2))

# Display the dataset
moose_data |>
  DT::datatable()
```


## Summary Statistics

### Total Counts

The total counts of adult moose and calves observed during the survey are as follows:

**Total Adults:** `r sum(moose_data$Adults)`  
**Total Calves:** `r sum(moose_data$Calves)`

### Average Counts
The average counts of adults and calves per survey are:

**Average Adults per Survey:** `r mean(moose_data$Adults)`  
**Average Calves per Survey:** `r mean(moose_data$Calves)`  

### Summarize data by region

```{r}
#| echo: false
#| message: false

library(DT)
library(dplyr)

# Summarize the dataset
region_summary <- moose_data |>
  group_by(Area) |>
  summarize(Total_Adults = sum(Adults),
            Total_Calves = sum(Calves),
            Average_Adults = mean(Adults),
            Average_Calves = mean(Calves))

# Display the summary
region_summary |> 
  DT::datatable()
```

## Conclusion

This report summarizes the key findings from the moose aerial survey dataset. The data shows a distribution of observed adult and calf moose across the specified regions. The average counts indicate overall trends that can inform future wildlife management strategies.

## Recommendations

Based on the analysis, consider implementing these recommendations:

- Increase monitoring efforts in regions with lower counts.
- Investigate potential causes for calf mortality.
- Share findings with relevant wildlife management authorities for action.

## References

Moose aerial survey data collected in September 2023.
Additional resources on wildlife management and population studies...
