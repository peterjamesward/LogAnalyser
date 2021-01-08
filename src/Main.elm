module Main exposing (..)

import Browser
import Element as E exposing (Element, column, fill, height, htmlAttribute, layout, padding, spacing, text, width)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input exposing (labelBelow)
import FlatColors.FlatUIPalette as Palette
import GeoCodeDecoders exposing (IpStackInfo)
import Html.Attributes exposing (style)
import Http


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type alias LogEntry =
    { day : Int
    , month : Int
    , year : Int
    , ip : String
    }


type alias Model =
    { filename : String
    , fileContent : String
    , logEntries : List LogEntry
    }


initModel =
    { filename = ""
    , fileContent = ""
    , logEntries = []
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel
    , Cmd.none
    )


type Msg
    = FileNameChanged String
    | LoadFile String
    | FileLoaded String
    | GeocodeResult (Result Http.Error IpStackInfo)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FileNameChanged txt ->
            ( { model | filename = txt }, Cmd.none )

        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view model =
    { title = "Log file analyzer"
    , body =
        [ layout
            [ Background.color Palette.wetAsphalt
            , width fill
            , height fill
            , Font.color Palette.emerald
            ]
          <|
            column [ spacing 10, padding 10 ]
                [ Input.text []
                    { onChange = FileNameChanged
                    , text = model.filename
                    , placeholder = Nothing
                    , label = labelBelow [] (text ".CSV file name")
                    }
                ]
        ]
    }
