module GeoCodeDecoders exposing (..)

import Json.Decode as D exposing (Decoder)


type alias IpStackInfo =
    { ip : String
    , continentName : String
    , countryName : String
    , regionName : String
    , city : String
    , zip : String
    , latitude : Float
    , longitude : Float
    }


decodeSomething : Decoder IpStackInfo
decodeSomething =
    D.map8 IpStackInfo
        (D.at [ "ip" ] D.string)
        (D.at [ "continent_name" ] D.string)
        (D.at [ "country_name" ] D.string)
        (D.at [ "region_name" ] D.string)
        (D.at [ "city" ] D.string)
        (D.at [ "zip" ] D.string)
        (D.at [ "latitude" ] D.float)
        (D.at [ "longitude" ] D.float)
