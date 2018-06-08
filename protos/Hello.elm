module Hello exposing (..)

import Html.Attributes exposing (..)
import Html exposing (..)

headerText = "Jouzah!"
subHeaderText = "So cool to write elm..."

card name =
  div []
    [ h3 [] [ text name]
    , img [src "https://placebear.com/40/40"] []
    ]

main =
    div []
      [ h1 [style [("color", "green")]][text headerText]
        , p [] [text ("das subheader: " ++ subHeaderText)]
        , card "Perrtti!"
        , card "Jonne"
      ]
