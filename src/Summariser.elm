module Summariser exposing (..)

import GeoCodeDecoders exposing (LogEntry)
import List.Extra


type alias SummaryByDate =
    { date : String
    , countPageLoads : Int
    , countIPs : Int
    , countCountries : Int
    , countries : List (String, Int)
    }


summarise : List LogEntry -> List SummaryByDate
summarise entries =
    let
        logsByDate =
            List.Extra.gatherEqualsBy .timestamp entries

        uniqueIPsCount =
            List.length << List.Extra.uniqueBy .ip

        uniqueCountryCount =
            List.length << List.Extra.uniqueBy .countryName

        countForCountry : (LogEntry, List LogEntry) -> (String, Int)
        countForCountry ( leader, rest ) =
            (leader.countryName, uniqueIPsCount (leader :: rest))

        summariseCountries : List LogEntry -> List (String, Int)
        summariseCountries  =
            (List.Extra.gatherEqualsBy .countryName )
            >>( List.map countForCountry)

        summariseDate : ( LogEntry, List LogEntry ) -> SummaryByDate
        summariseDate ( leader, rest ) =
            { date = leader.timestamp
            , countPageLoads = 1 + List.length rest
            , countIPs = uniqueIPsCount (leader :: rest)
            , countCountries = uniqueCountryCount (leader :: rest)
            , countries = summariseCountries (leader :: rest)
            }
    in
    List.sortBy .date <| List.map summariseDate logsByDate
