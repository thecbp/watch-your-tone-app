source("./global.R")

ui <- navbarPage(title = "Watch Your Tone",
                 windowTitle = "Watch Your Tone",
                 id = "navbar",
                 theme = "styles.css",
                 collapsible = TRUE,
                 
                 ###############################################################
                 
                 ### START OF PINYIN TABLE TAB 
                 
                 ###############################################################
                 
                 tabPanel(
                   "Pinyin",
                   fluidRow(
                     column(1),
                     column(10,
                            selectizeInput(
                              inputId = "pinyin_selectize",  
                              label = "Choose pinyin to display in gallery:", 
                              choices = pinyin_vec,
                              selected = "a",
                              multiple = TRUE,
                              width = "100%"
                            )),
                     column(1)
                   ),
                   fluidRow(
                     column(3),
                     column(2, h3("First Tone")),
                     column(2, h3("Second Tone")),
                     column(2, h3("Third Tone")),
                     column(2, h3("Fourth Tone")),
                     column(2)
                   ),
                   uiOutput("pinyin_rows")
                 ),
                 
                 ###############################################################
                 
                 ### START OF SYNTHESIZER TAB ###
                 
                 ###############################################################
                 
                 tabPanel(
                   "Synthesizer",
                   fluidRow(
                    column(2),
                    column(8, textInput(inputId = "synthesizer_text",
                                        label = "Enter a series of pinyin here:",
                                        placeholder = "ni3hao3",
                                        width = "100%")),
                    column(2)
                   ),
                   fluidRow(
                     column(2),
                     column(8, actionButton(inputId = "talk", 
                                            label = "Speak!",
                                            width = "100%")),
                     column(2)
                   )
                   
                 ),
                 
                 ###############################################################
                 
                 ### START OF SYNTHESIZER TAB ###
                 
                 ###############################################################
                 
                 tabPanel(
                   "About",
                   fluidRow(
                     column(3),
                     column(6, h1("What Am I Looking At?")),
                     column(3)
                   ),
                   fluidRow(
                     column(3),
                     column(6, HTML(about_text)),
                     column(3)
                   )
                   
                 )
  
)