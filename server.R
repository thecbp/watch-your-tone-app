# Define server logic required to draw a histogram
server <- function(input, output) {
  
  filtered_pinyin_db = reactive({
    pinyin_db %>% filter(pinyin %in% input$pinyin_selectize)
  })
  
  # Create event observers for each button that is currently on the screen
  observeEvent(input$pinyin_selectize, {
    
    map(input$pinyin_selectize, function(py) {
      
      # Get all of the characters with the tones at the end
      pinyin_tones = filtered_pinyin_db() %>% 
        filter(pinyin == py) %>% 
        pull(pinyin_tone) %>% 
        unique
     
      # Currently just retrieve the first voice for each 
      pinyin_paths = map_chr(pinyin_tones, function(pt) {
        filtered_pinyin_db() %>% 
          filter(pinyin_tone == pt) %>% 
          pull(path) %>% .[1]
      }) 
      
      # Add an observer for the all-tone button
      if (!(py %in% names(input))) {
        
        observeEvent(input[[py]], {
          play(readMP3(paste0("www/", pinyin_paths[1])))
          play(readMP3(paste0("www/", pinyin_paths[2])))
          play(readMP3(paste0("www/", pinyin_paths[3])))
          play(readMP3(paste0("www/", pinyin_paths[4])))
        })
        
      }
      
      
      # Add files for each of the one-tone buttons
      map2(pinyin_tones, pinyin_paths, function(pt, pp) {
        
        if (!(pp %in% names(input))) {
          
          observeEvent(input[[pp]], {
            play(readMP3(paste0("www/", pp)))
          })
          
        }
        
      })
      
    })
    
  })
  
  output$pinyin_rows = renderUI({
    
    # Iterate over the selected pinyin and create fluidRows row all of them
    map(input$pinyin_selectize, function(py) {
      
      # Get all of the characters with the tones at the end
      pinyin_tones = filtered_pinyin_db() %>% 
        filter(pinyin == py) %>% 
        pull(pinyin_tone) %>% 
        unique
      
      # Currently just retrieve the first voice for each 
      pinyin_paths = map_chr(pinyin_tones, function(pt) {
        filtered_pinyin_db() %>% 
          filter(pinyin_tone == pt) %>% 
          pull(path) %>% .[1]
      })
      
      # Create the rows from the pinyin tones
      # This UI creates interface where you can't download the files
      # fluidRow(
      #   column(1),
      #   column(2, actionButton(inputId = py,
      #                          label = py,
      #                          class = "all-voice",
      #                          width = "100%")),
      #   column(2, actionButton(inputId = pinyin_paths[1],
      #                          label = pinyin_tones[1],
      #                          class = "one-voice",
      #                          width = "100%")),
      #   column(2, actionButton(inputId = pinyin_paths[2],
      #                          label = pinyin_tones[2],
      #                          class = "one-voice",
      #                          width = "100%")),
      #   column(2, actionButton(inputId = pinyin_paths[3],
      #                          label = pinyin_tones[3],
      #                          class = "one-voice",
      #                          width = "100%")),
      #   column(2, actionButton(inputId = pinyin_paths[4],
      #                          label = pinyin_tones[4],
      #                          class = "one-voice",
      #                          width = "100%")),
      #   column(1)
      # )
      
      # This UI just uses the audio tag from the shiny library to play files
      fluidRow(
        column(1),
        column(2, actionButton(inputId = py,
                               label = py,
                               class = "all-voice",
                               width = "100%")),
        column(2, tags$audio(src = pinyin_paths[1], 
                             type = "audio/mpeg", 
                             controls = TRUE, 
                             controlsList = "nodownload")),
        column(2, tags$audio(src = pinyin_paths[2], 
                             type = "audio/mpeg", 
                             controls = TRUE, 
                             controlsList = "nodownload")),
        column(2, tags$audio(src = pinyin_paths[3], 
                             type = "audio/mpeg", 
                             controls = TRUE, 
                             controlsList = "nodownload")),
        column(2, tags$audio(src = pinyin_paths[4], 
                             type = "audio/mpeg", 
                             controls = TRUE, 
                             controlsList = "nodownload")),
        column(1)
      )
      
    })
  
  })
  
  # Take the current text in the 
  observeEvent(input$talk, {
    
    # Take the input and create a vector of pinyin+tone
    split_pinyin = reformat_input(input$synthesizer_text)
    
    play_word(split_pinyin)
    
  })
  
}