module Styles exposing (..)

import Element exposing (Attribute, centerX, focused, mouseOver, padding)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import FlatColors.FlatUIPalette

prettyButtonStyles : List (Attribute msg)
prettyButtonStyles =
    [ padding 10
    , Border.width 2
    , Border.rounded 16
    , Border.color FlatColors.FlatUIPalette.turquoise
    , Background.color FlatColors.FlatUIPalette.belizeHole
    , Font.color FlatColors.FlatUIPalette.silver
    , Font.size 16
    , mouseOver
        [ Background.color FlatColors.FlatUIPalette.asbestos
        , Font.color FlatColors.FlatUIPalette.belizeHole ]
    , focused
        [ Border.shadow { offset = ( 4, 0 ), size = 3, blur = 5, color = FlatColors.FlatUIPalette.orange } ]
    , centerX
    ]
