module GeoCodeDecoders exposing (..)

import Json.Decode.Pipeline
import Json.Decode exposing (field)

type alias Something =
    { ip : String
    , type : String
    , continentCode : String
    , continentName : String
    , countryCode : String
    , countryName : String
    , regionCode : String
    , regionName : String
    , city : String
    , zip : String
    , latitude : Float
    , longitude : Float
    , location : SomethingLocation
    }

type alias SomethingLocation =
    { geonameId : Int
    , capital : String
    , languages : List ComplexType
    , countryFlag : String
    , countryFlagEmoji : String
    , countryFlagEmojiUnicode : String
    , callingCode : String
    , isEu : Bool
    }

decodeSomething : Json.Decode.Decoder Something
decodeSomething =
    Json.Decode.Pipeline.decode Something
        |> Json.Decode.Pipeline.required "ip" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "type" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "continent_code" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "continent_name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "country_code" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "country_name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "region_code" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "region_name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "city" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "zip" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "latitude" (Json.Decode.float)
        |> Json.Decode.Pipeline.required "longitude" (Json.Decode.float)
        |> Json.Decode.Pipeline.required "location" (decodeSomethingLocation)

decodeSomethingLocation : Json.Decode.Decoder SomethingLocation
decodeSomethingLocation =
    Json.Decode.Pipeline.decode SomethingLocation
        |> Json.Decode.Pipeline.required "geoname_id" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "capital" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "languages" (Json.Decode.list decodeComplexType)
        |> Json.Decode.Pipeline.required "country_flag" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "country_flag_emoji" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "country_flag_emoji_unicode" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "calling_code" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "is_eu" (Json.Decode.bool)
     ]