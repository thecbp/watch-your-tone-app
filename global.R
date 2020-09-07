library(shiny)
library(tidyverse)
library(tuneR)

# Set the wavplayer for Mac
setWavPlayer('/usr/bin/afplay')

# Helper tibble for storing information about each file
pinyin_db = read_csv("./www/pinyin-db.csv", col_types = cols())
pinyin_vec = pinyin_db %>% 
  pull(pinyin) %>% 
  str_replace("[1234]", "") %>% 
  unique

about_text = "
  Watch Your Tone is a simple app designed for students learning pinyin. Tones 
  are a central component of Mandarin, so special care should be taken to really
  learn how to produce the tones for each of the pinyin. 
  
  <br><br>
  
  The voice files were graciously provided by the Tone Perfect project at 
  Michigan State University:
  
  <br><br>
  
  <code>
  Catherine Ryu, Mandarin Tone Perception & Production Team, and Michigan State 
  University Libraries. Tone Perfect: Multimodal Database for Mandarin Chinese. 
  Accessed 1 January 2019. https://tone.lib.msu.edu/
  </code>
"

reformat_input = function(input) {
  
  split_input = str_split(input, "(?=[1-4])", simplify = T) %>% c()
  final_input = character(length(split_input) - 1)
  
  # Restructure the vector so it follows pinyin+tone format
  for (i in 1:length(split_input) - 1) {
    final_input[i] = paste0(
                      str_replace_all(split_input[i], "[0-9]", ""), # remove all numbers
                      str_replace_all(split_input[i + 1], "[[:lower:]]", "") # remove all letters
                    )

  }

  final_input
  
}


play_word = function(pinyin_vec) {
  
  # needs an error catch
  is_valid = map_dbl(pinyin_vec, function(py) {
    
    # Check if the input is valid, if not, this returrns tibble w/ 0 rows
    pinyin_db %>% 
      filter(pinyin_tone == py) %>% 
      nrow()
    
  })
  
  if (sum(is_valid == 0) > 0) { return() }
  
  map(pinyin_vec, function(py) {

    # Get all of the characters with the tones at the end
    pinyin_path = pinyin_db %>%
      filter(pinyin_tone == py) %>%
      pull(path) %>% .[1]

    play(readMP3(paste0("www/", pinyin_path)))

  })
  
}
