module Main exposing (..)

import Browser
import Element exposing (Element, column)
import Element.Input as Input
import Http


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
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
    = LoadFile String
    | FileLoaded String
    | GeocodeResult (Result Http.error GeoCode)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotText result ->
            case result of
                Ok fullText ->
                    ( Success fullText, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Element Msg
view model =
    column []
    [ Input.text model.filename
    ]
