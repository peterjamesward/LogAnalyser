module GeoCodeDecoders exposing (..)

import Json.Decode as D exposing (Decoder)


type alias LogEntry =
    { timestamp : String
    , ip : String
    , countryName : String
    , regionName : String
    , city : String
    , zip : String
    , latitude : Float
    , longitude : Float
    }

type alias LogEntryWrapper =
    { entry : LogEntry
    }

type alias LogEntries =
    { logs : List LogEntry }

logWrapperDecoder : Decoder LogEntryWrapper
logWrapperDecoder =
    D.map LogEntryWrapper
        (D.at [ "entry"] logEntryDecoder)

logEntryDecoder : Decoder LogEntry
logEntryDecoder =
    D.map8 LogEntry
        (D.at [ "timestamp" ] D.string )
        (D.at [ "ip" ] D.string)
        (D.at [ "country" ] D.string)
        (D.at [ "region" ] D.string)
        (D.at [ "city" ] D.string)
        (D.at [ "zip" ] D.string)
        (D.at [ "lat" ] D.float)
        (D.at [ "lon" ] D.float)

logEntriesDecoder : Decoder (List LogEntryWrapper)
logEntriesDecoder =
    D.at [ "logs" ] (D.list logWrapperDecoder)