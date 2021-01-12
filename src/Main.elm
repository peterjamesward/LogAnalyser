module Main exposing (..)

import Browser
import Element as E exposing (Element, alignTop, centerX, centerY, clipY, column, el, fill, height, htmlAttribute, layout, padding, row, scrollbars, shrink, spacing, table, text, width, wrappedRow)
import Element.Background as Background
import Element.Font as Font
import FlatColors.FlatUIPalette as Palette exposing (clouds)
import GeoCodeDecoders exposing (LogEntry, LogEntryWrapper, logEntriesDecoder)
import Http
import Pivot exposing (makePivotTable)
import Summariser exposing (SummaryByDate, summarise)
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
            column [ spacing 10, padding 10, centerX ]
                [ el [ centerX, alignTop, Font.size 32, Font.color clouds ] <|
                    text "Summary by day"
                , summaryTable <| summarise model.logEntries
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
    table [ width shrink ]
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


summaryTable : List SummaryByDate -> Element Msg
summaryTable summary =
    table [ padding 10, spacing 10 ]
        { data = summary
        , columns =
            [ { header = showString "Date", width = fill, view = .date >> showString }
            , { header = showString "Page loads", width = fill, view = .countPageLoads >> showInt }
            , { header = showString "Unique IP", width = fill, view = .countIPs >> showInt }
            , { header = showString "Countries", width = fill, view = .countCountries >> showInt }
            , { header = showString "Countries", width = fill, view = .countries >> listCountries }
            ]
        }


showString : String -> Element Msg
showString s =
    el [ padding 5, centerX, centerY ] (text s)


showInt : Int -> Element Msg
showInt i =
    showString (String.fromInt i)


listCountries : List ( String, Int ) -> Element Msg
listCountries countries =
    wrappedRow [ width fill, padding 5, spacing 10, centerY ]
        (List.map showCountry countries)


showCountry : ( String, Int ) -> Element Msg
showCountry ( name, count ) =
    row [] [ showString name, showInt count ]
