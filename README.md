# MustangNestLocator
Search apartments near Southern Methodist University using Rshiny

Mustang Nest Locator is a Shiny web application that provides a platform for finding apartments near Southern Methodist University (SMU).

## Features

- **Home Tab:** Welcome message and team information.
- **Apartment Search Tab:** Search for apartments based on location, price range, and number of bedrooms.
- **Submit Review Tab:** Submit reviews for apartments.
- **Manage Reviews Tab:** View, update, and remove submitted reviews.
- **Apartment Locations Tab:** View apartment locations on an interactive map.

## Getting Started

### Prerequisites

- RStudio (optional, but recommended)
- SQL Server Management Studio (or any other sql server)

### Install dependencies
- install.packages(c("shinydashboard", "leaflet", "DBI", "odbc", "DT", "shinythemes", "shinyjs", "shinyalert", "htmltools", "rsconnect"))

## Configurations
- Configurations in the creds.R file. Enter the credentials of the DB accordingly.
- This app uses Microsoft ODBC Driver for database connectivity

