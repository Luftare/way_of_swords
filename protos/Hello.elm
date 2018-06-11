module Hello exposing (..)

import Html.Attributes exposing (..)
import Html exposing (..)

headerText = "Jouzah!<?"
subHeaderText = "So cool to write elm..."

card name sub =
  div []
    [ h3 [] [text name]
    , p [] [text sub]
    , img [src "https://placebear.com/40/40"] []
    ]

kolme = 3

main =
    div []
      [ h1 [style [("color", "green")]][text headerText]
      , p [] [text ("das subheader: " ++ subHeaderText)]
      , card "Perrtti!" "jöö"
      , card "Jonne" "jööasdasd"
      , p [] [text (toString kolme)]
      ]
