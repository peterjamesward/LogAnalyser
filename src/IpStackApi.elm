module IpStackApi exposing (..)

import IpStackKey exposing (access_key)
import Url.Builder as Builder


apiRoot =
    "http://api.ipstack.com"


url ip =
    Builder.crossOrigin apiRoot [ ip ] [ ( Builder.string "access_key" access_key ) ]
