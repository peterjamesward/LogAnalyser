module Pivot exposing (..)

import Element exposing (..)
import Element.Background
import Element.Border
import FlatColors.FlatUIPalette exposing (wetAsphalt)
import GeoCodeDecoders exposing (LogEntry)
import PivotTable exposing (Table, makeTable, pivotTable)



makePivotTable : List LogEntry -> Element msg
makePivotTable entries =
    pivotTable
        { rowGroupFields = [ .timestamp ]
        , colGroupFields = [ .countryName , .ip ]
        , aggregator = List.length
        , viewRow =
            \t ->
                el
                    [ Element.Border.width 1
                    , padding 5
                    , width fill
                    , height fill
                    , Element.Background.color wetAsphalt
                    ]
                <|
                    el [ centerX, centerY, padding 5 ] <|
                        text t
        , viewCol =
            \t ->
                el
                    [ Element.Border.width 1
                    , padding 5
                    , width fill
                    , height fill
                    , Element.Background.color wetAsphalt
                    ]
                <|
                    el [ centerX, centerY, padding 5 ] <|
                        text t
        , viewAgg =
            \i ->
                el
                    [ Element.Border.width 1
                    , padding 5
                    , width fill
                    , height fill
                    ]
                <|
                    el [ centerX, centerY, padding 5 ] <|
                        text <|
                            String.fromInt i
        }
        (makeTable entries)
