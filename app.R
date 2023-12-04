library(shinydashboard)
library(leaflet)
library(DBI)
library(odbc)
library(DT)
library(shinythemes)
library(shinyjs)
library(shinyalert)
library(htmltools)
library(rsconnect)

# Connect to the database
source("./creds.R")
print(getOption("database_userid"))
con <- dbConnector(
  server = getOption("database_server"),
  database = getOption("database_name"),
  uid = getOption("database_userid"),
  pwd = getOption("database_password"),
  port = getOption("database_port")
)
#con <- dbConnect(
#  odbc::odbc(),
#  driver = "ODBC Driver 17 for SQL Server",
#  server = "classroomdb.smu.edu,55433",
#  database = "ITOM6265_F23_Group19",
 # port = 55433,
#  uid = "itom6265",
#  pwd = "ITOM_6265_passw0rd"
#)

# Define the UI
ui <- fluidPage(
  title = "Mustang Nest Locator",
  #theme = shinytheme("cerulean"),
  tags$head(
    tags$style(
      HTML("
    /* Customize the navbar to have a dark background and change font color to white for contrast */
.navbar {
  background-color: #1A2A35  ; /* Dark grey background */
  color: #FFFFFF  ; /* White text color for contrast */
  image: none  ;
  width: 100%;
}
    /* Ensure the html element covers the entire screen */
    html {
      height: 100%;
    }
 
    /* Create a full-screen pseudo-element for the grey overlay */
    html::after {
      content: '';
      position: fixed; /* Fixed position relative to the viewport */
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(128, 128, 128, 0); /* Grey overlay with 70% opacity */
      z-index: -1; /* Positioned behind the content but above the background image */
    }
 
   
 
    body {
      background-image: url('https://i.postimg.cc/Cxr5jLKm/Bg.png');
      background-size: cover;
      background-repeat: no-repeat;
      background-attachment: fixed;
      position: relative;
      color: #1A2A35; 
    }

    .nav.nav-tabs {
      justify-content: space-around; 
    }
    
    .nav-item {
      flex: 1; /* Each tab item will take equal space */
      text-align: center; /* Center-align the tab labels */
    }

    h1, h2, h3, h5, h6, p {
      color: #FFFFFF; 
    }
    h4 {
      color: #1A2A35;
    }
    
    /* Style DT tables with a white background */
    .dataTable {
      background-color: white  ;
    }
    /* DT table headers and cells styling */
    table.dataTable thead th, table.dataTable tbody td {
      background-color: white  ;
      border-color: #ddd  ; /* Light grey border for some contrast */
    }
    .tab-pane {
        background-color: rgba(26, 42, 53, 0.3); /* Light green background */
        border-radius: 5px; /* Optional: adds rounded corners */
        padding: 15px; /* Optional: adds some padding inside the tab panels */
        margin-top: 15px; /* Optional: adds some space at the top of the tab panel */
    }
      .tab-pane * {
        font-weight: 500; /* Bold text with a font weight of 700 */
      }
      /* Change background color of the navbar tabs */
    .nav-tabs {
        background-color: rgba(26, 42, 53, 1); /* Light green background */
         border-bottom: none  ;
    }
 
    /* Change font color of the navbar tabs */
    .nav-tabs > li > a {
      color: #ffffff; /* Replace with the color you want */
    }
 
    /* Change background color for the active tab */
    .nav-tabs > .active > a,
    .nav-tabs > .active > a:focus,
    .nav-tabs > .active > a:hover {
      background-color: rgba(185, 204, 184, 0.7); /* Darker shade for active tab, replace with color you want */
      color: #1A2A35; /* Replace with the color you want */
    }
  ")),
  ),
  titlePanel(
    div(
      span("MUSTANG NEST LOCATOR", class = "title-panel-text"),
      style = "background-color: #1A2A35; color: #FFFFFF; padding: 10px; width: 101%"
    )
  ),
  
  useShinyjs(),
  useShinyalert(),
  tabsetPanel(
    # Home tab
    tabPanel("Home",
             h2("Welcome to Mustang Nest Locator"),
             p("Your go-to platform for finding apartments near SMU."),
             p("Team: Devaloy Mukherjee, Roshan Dhaigude, Jyoti Singh, Rahul Jogdankar")
    ),
    # Apartment Search tab
    tabPanel("Apartment Search",
             sidebarLayout(
               sidebarPanel(
                 selectInput("location", "Location:", choices = c("All", "Village", "Arrive on University", "On Campus")),
                 sliderInput("price", "Price Range:", min = 0, max = 5000, value = c(0, 5000)),
                 selectInput("bedrooms", "Bedrooms:", choices = c("Any", 1, 2, 3)),
                 actionButton("search", "Search")
               ),
               mainPanel(
                 DTOutput("apartment_table")
               )
             )
    ),
    # Submit Review tab
    tabPanel("Submit Review",
             fluidRow(
               column(3, numericInput("review_username", "Your UserID:", value = NULL)),
               column(3, numericInput("review_aptid", "AptID:", value = NULL)),
               column(3, numericInput("review_rating", "Rating (1-5):", min = 1, max = 5, value = NULL)),
               column(3, textInput("review_comment", "Review Comment:")),
               column(12, actionButton("submit_review", "Submit Review"))
             )
    ),
    # Manage Reviews tab
    tabPanel("Manage Reviews",
             fluidRow(
               DTOutput("reviews_table"),
               column(4, 
                      numericInput("update_username", "ReviewID to Update:", value = NULL),
                      numericInput("review_rating", "Updated Review Rating", value = NULL),
                      textInput("review_comment", "Updated Review Comment", value = NULL),
                      actionButton("update_review", "Update Review")
               ),
               column(4,
                      numericInput("remove_reviewID", "ReviewID to Remove:", value = NULL),
                      actionButton("remove_review", "Remove Review")
               )
             )
    ),
    # Apartment Locations tab
    tabPanel("Apartment Locations",
             fillCol(
               leafletOutput("map", width = "100%", height = "80vh")  
             )
    )
  )
  
)

# Define the server logic
server <- function(input, output, session) {
  
  
  # Keep track of the currently selected row
  selected_row <- reactiveVal(NULL)
  reactive_apartments <- reactiveVal(data.frame())
  
  # Render the leaflet map
  output$map <- renderLeaflet({
    locations <- dbGetQuery(con, "SELECT * FROM Apartment")
    
    # Create a leaflet map with street view
    leaflet() %>%
      setView(lng = -96.784562, lat = 32.841188, zoom = 14) %>%  
      addProviderTiles("OpenStreetMap.Mapnik") %>%  
      addMarkers(
        data = locations,
        lng = ~Longitude,
        lat = ~Latitude,
        popup = ~paste("Name: ", Name, "<br>",
                       "Location: ", Location, "<br>",
                       "Rent: $", Rent, "<br>",
                       "Bedrooms: ", Bedrooms, "<br>",
                       "Bathrooms: ", Bathrooms, "<br>",
                       "Contact Name: ", ContactName, "<br>",
                       "Contact Number: ", ContactNumber,
                       "<br><a href='https://www.google.com/maps?q=", htmlEscape(Latitude), ",", htmlEscape(Longitude), "' target='_blank'>View on Google Maps</a>")
      ) %>%
      addMarkers(lng = -96.784562, lat = 32.841188, 
                 popup = "Southern Methodist University",
                 icon = makeIcon(iconUrl = "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png",
                                 iconWidth = 25, iconHeight = 41))
  })
  
  
  
  # Define a reactive query for apartment search
  apartment_query <- reactive({
    location <- input$location
    price_min <- input$price[1]
    price_max <- input$price[2]
    bedrooms <- input$bedrooms
    query <- "SELECT * FROM apartment WHERE 1=1"
    
    if (location != "All") {
      query <- paste(query, paste("AND Location LIKE '%", location, "%'", sep = ""), sep = " ")
    }
    
    if (price_min >= 0 && price_max >= price_min) {
      query <- paste(query, paste("AND Rent >= ", price_min, " AND Rent <= ", price_max, sep = ""), sep = " ")
    }
    
    if (bedrooms != "Any") {
      query <- paste(query, paste("AND Bedrooms = ", bedrooms, sep = ""), sep = " ")
    }
    
    return(query)
  })
  
  #Observe parameters given as inputs to filter and display apartments
  observeEvent(input$search, {
    query <- apartment_query()
    apartments <- dbGetQuery(con, query)
    reactive_apartments(apartments)
  })
  
  output$apartment_table <- DT::renderDataTable({
    datatable(
      reactive_apartments(),
      selection = 'single',
      options = list(
        dom = 't',
        pageLength = Inf
      )
    )
  })
  
  
  column_names <- c("SR No.","ApartmentID", "Name", "Location", "Rent", "Bedrooms", 
                    "Bathrooms", "Latitude", "Longitude", "ContactName", "ContactNumber")
  
  # Observe clicks on rows of the apartment table to print rent and show details
  observeEvent(input$apartment_table_rows_selected, {
    selected_row_index <- input$apartment_table_rows_selected
    if (length(selected_row_index) == 1) {
      apartments_data <- reactive_apartments()
      selected_row <- apartments_data[selected_row_index, ]
      
      selected_rent_value <- selected_row$Rent
      max_rent_for_cheaper_apartments <- selected_rent_value - 500
      
      display_columns <- c("ApartmentID", "Name", "Location", "Rent", "Bedrooms", "Bathrooms", "ContactName", "ContactNumber")
      
      cheaper_apartments_query <- paste(
        "SELECT TOP 3", paste(display_columns, collapse=", "), "FROM Apartment WHERE Rent BETWEEN",
        dbQuoteLiteral(con, max_rent_for_cheaper_apartments),
        "AND",
        dbQuoteLiteral(con, selected_rent_value),
        "ORDER BY Rent ASC"
      )
      
      cheaper_apartments <- dbGetQuery(con, cheaper_apartments_query)
      
      if (nrow(cheaper_apartments) > 0) {
        cheaper_apartments_details <- apply(cheaper_apartments, 1, function(row) {
          paste(display_columns, row[display_columns], sep=": ", collapse="<br/>")
        })
        cheaper_apartments_details_html <- paste(cheaper_apartments_details, collapse="<hr/>")
        
        modal_content <- HTML(paste("<style>.modal-content { color: black; }</style>",
                                    "<h4>Selected Apartment Details:</h4>",
                                    paste(display_columns, selected_row[display_columns], sep=": ", collapse="<br/>"),
                                    "<h4>Cheaper Apartments:</h4>",
                                    cheaper_apartments_details_html))
      } else {
        modal_content <- HTML(paste(                          "<h4>Selected Apartment Details:</h4>",
                                    paste(display_columns, selected_row[display_columns], sep=": ", collapse="<br/>"),
                                    "<h4>No Cheaper Apartments Available</h4>"))
      }
      
      showModal(
        modalDialog(
          title = "Apartment Details",
          modal_content,
          easyClose = TRUE,
          footer = modalButton("Close")
        )
      )
    }
  })
  
  
  observeEvent(input$submit_review, {
    username <- isolate(input$review_username)
    aptid <- isolate(input$review_aptid)
    rating <- isolate(input$review_rating)
    comment <- isolate(input$review_comment)
    current_date <- Sys.Date()
    dbExecute(con, "INSERT INTO Review (UserID, ApartmentID, Rating, Comment, Date) VALUES (?, ?, ?, ?, ?)",
              params = list(username, aptid, rating, comment, current_date))
    
    shinyalert("Success!", "Your review has been submitted.", type = "success")
    
    updateNumericInput(session, "review_username", value = NA)
    updateNumericInput(session, "review_aptid", value = NA)
    updateNumericInput(session, "review_rating", value = NA)
    updateTextInput(session, "review_comment", value = "")
  })
  
  reviews <- reactiveVal(data.frame())
  
  observe({
    reviews_data <- dbGetQuery(con, "SELECT * FROM Review")
    reviews(reviews_data)
  })
  
  output$reviews_table <- renderDT({
    datatable(reviews(), editable = TRUE, options = list(dom = 't', pageLength = 10))
  })
  
  
  observeEvent(input$update_review, {
    reviewID <- isolate(input$update_username)
    
    # Check if reviewID is not NULL
    if (!is.null(reviewID)) {
      print("Updating review with ReviewID:")
      print(reviewID)
      
      updated_rating <- input$review_rating
      updated_comment <- input$review_comment
      
      print("Updated Rating:")
      print(updated_rating)
      
      print("Updated Comment:")
      print(updated_comment)
      
      dbExecute(con, "UPDATE Review SET Rating = ?, Comment = ? WHERE ReviewID = ?",
                params = list(updated_rating, updated_comment, reviewID))
      
      reviews_data <- dbGetQuery(con, "SELECT * FROM Review")
      reviews(reviews_data)
      
      shinyalert("Success!", "Review updated successfully.", type = "success")
    } else {
      shinyalert("Error", "Please provide a valid ReviewID for updating.", type = "error")
    }
  })
  
  observeEvent(input$remove_review, {
    username <- isolate(input$remove_reviewID)
    
    dbExecute(con, "DELETE FROM Review WHERE ReviewID = ?", data.frame(username))
    
    shinyalert("Deleted", "Your review has been deleted", type = "error")
    
    updateNumericInput(session, "remove_reviewID", value = NA)
    
    reviews_data <- dbGetQuery(con, "SELECT * FROM Review")
    reviews(reviews_data)
  })
  
  
}

shinyApp(ui, server)