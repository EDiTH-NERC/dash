# Header ----------------------------------------------------------------
# Project: dash
# File name: setup.R
# Last updated: 2025-04-15
# Author: Lewis A. Jones
# Email: LewisA.Jones@outlook.com
# Repository: https://github.com/LewisAJones/dash
# Load libraries --------------------------------------------------------
library(leaflet)
library(sf)
library(reactable)

# Load data -------------------------------------------------------------
bins <- readRDS("data/stages.RDS")
occdf <- readRDS("data/PBDB.RDS")
colldf <- readRDS("data/PBDB_collections.RDS")

colldf$content <- paste0("<b>", 
                         colldf$interval_name,
                         " (",
                         colldf$max_ma, 
                         "—", 
                         colldf$min_ma,
                         " Ma) ",
                         "</b>", 
                         "<br>",
                         "Collection number: ",
                         colldf$collection_no, 
                         "<br>",
                         "Country: ",
                         colldf$cc,
                         "<br>",
                         "Longitude: ",
                         colldf$lng,
                         "<br>",
                         "Latitude: ",
                         colldf$lat,
                         "<br>",
                         "Genera: ",
                         colldf$genera
)

# Map -------------------------------------------------------------------
data_map <- colldf |> 
  leaflet() |> 
  addProviderTiles(providers$CartoDB.Positron, 
                   options = list(noWrap = TRUE,
                                  minZoom = 4,
                                  maxZoom = 14)) |>
  setView(lng = -78.5, lat = 20.5, zoom = 4) |> 
  setMaxBounds(lng1 = -180, lat1 = 90, lng2 = 180, lat2 = -90) |>
  addRectangles(lng1 = -100, lng2 = -58, lat1 = 6, lat2 = 35, group = "Bounding Box") |>
  addCircleMarkers(data = colldf,
                   lng = ~lng,
                   lat = ~lat,
                   layerId = ~collection_no,
                   popup = ~content,
                   group = ~interval_name,
                   radius = 5,
                   stroke = TRUE,
                   weight = 1,
                   opacity = 1,
                   color = "#36454F",
                   fillColor = ~colour,
                   fillOpacity = 0.5) |>
  addLayersControl(overlayGroups = c(colldf$interval_name))


# Table -----------------------------------------------------------------
data_table <- occdf[, 1:(ncol(occdf)-3)] |> 
  reactable(searchable = TRUE,
            defaultPageSize = 100,
            theme = reactableTheme(
              style = list(fontSize = "0.7em")))


# 
# # Load libraries
# library(ggplot2)
# library(plotly)
# library(MetBrewer)
# library(deeptime)
# # Load data
# df <- readRDS("data/stats/sampling.RDS")
# p <- ggplot(data = df, aes(x = `Age (Ma)`, y = Count, colour = Field, fill = Field)) +
#   geom_line() +
#   geom_point(shape = 21, alpha = 0.7) +
#   scale_x_reverse() +
#   scale_colour_met_d("Nizami") +
#   theme_bw() +
#   theme(
#     legend.position = "right",
#     legend.background = element_blank(),
#     legend.title = element_blank()
#   ) + 
#   coord_geo(height = unit(1, "line"), size = 3)
# #p
# ggplotly(p, tooltip = c("Count"))
# 
