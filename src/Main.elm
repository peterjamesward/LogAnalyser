module Main exposing (..)

import Browser
import Element as E exposing (Element, centerX, centerY, clipY, column, el, fill, height, htmlAttribute, layout, padding, scrollbars, spacing, table, text, width)
import Element.Background as Background
import Element.Font as Font
import FlatColors.FlatUIPalette as Palette
import GeoCodeDecoders exposing (LogEntry, LogEntryWrapper, logEntriesDecoder)
import Http
import Pivot exposing (makePivotTable)
import Url.Builder as Builder


logAPI =
    "https://nrltvlmqsa.execute-api.eu-west-1.amazonaws.com"


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type alias Model =
    { logEntries : List LogEntry
    }


initModel =
    { logEntries = []
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel
    , requestLogs ReceivedLogs
    )


type Msg
    = ReceivedLogs (Result Http.Error (List LogEntryWrapper))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceivedLogs response ->
            case response of
                Ok logs ->
                    ( { model | logEntries = List.map .entry logs }
                    , Cmd.none
                    )

                Err _ ->
                    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Browser.Document Msg
view model =
    { title = "Log file analyzer"
    , body =
        [ layout
            [ Background.color Palette.wetAsphalt
            , width fill
            , height fill
            , clipY
            , scrollbars
            , Font.color Palette.emerald
            ]
          <|
            column [ spacing 10, padding 10, width fill, centerX, centerY ]
                [ --logTable model.logEntries
                  el [centerX] (makePivotTable model.logEntries)
                ]
        ]
    }


requestLogs : (Result Http.Error (List LogEntryWrapper) -> msg) -> Cmd msg
requestLogs msg =
    Http.request
        { method = "GET"
        , headers = []
        , url = Builder.crossOrigin logAPI [ "live" ] []
        , body = Http.emptyBody
        , expect = Http.expectJson msg logEntriesDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


logTable entries =
    table [ width fill ]
        { data = entries
        , columns =
            [ { header = text "Date", width = fill, view = .timestamp >> text }
            , { header = text "I.P.", width = fill, view = .ip >> text }
            , { header = text "City", width = fill, view = .city >> text }
            , { header = text "Country", width = fill, view = .countryName >> text }
            , { header = text "Longitude", width = fill, view = .longitude >> String.fromFloat >> text }
            , { header = text "Latitude", width = fill, view = .latitude >> String.fromFloat >> text }
            ]
        }
