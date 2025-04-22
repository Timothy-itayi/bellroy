module WatchBands exposing (main)




import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Svg exposing (svg, path)
import Svg.Attributes as SvgAttr


-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type alias Color =
    { name : String
    , value : String
    , imageUrl : String
    }


type alias Product =
    { id : Int
    , name : String
    , price : String
    , watchType : String
    , isBestseller : Bool
    , colors : List Color
    , selectedColor : Maybe Color
    }


type alias Model =
    { sortOption : String
    , products : List Product
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { sortOption = "Most popular"
      , products =
            [ Product 1 "Classic Watch Strap" "$69 – $119" "Apple Watch" True 
                [ Color "Black" "#363636" "/assets/Classic/1(2).avif"
                , Color "Green" "#5D736FFF" "/assets/Classic/1(1).avif"
                , Color "Brown" "#433231" "/assets/Classic/1(0).avif"
                , Color "Tan" "#BC7049FF" "/assets/Classic/1(3).avif"
                ]
                (Just (Color "Black" "#363636" "/assets/Classic/1(0).avif"))
            , Product 2 "Venture Watch Strap" "$49 – $85" "Apple Watch" True 
                [ Color "Black" "#1b1c1e" "/assets/Venture/0.avif"
                , Color "Gray" "#e9e6decc" "/assets/Venture/0(1).avif"
                , Color "Brown" "#5D736F" "/assets/Venture/0(2).avif"
                , Color "Tan" "#EFEB87" "/assets/Venture/0(3).avif"
                ]
                (Just (Color "Black" "#363636" "/assets/Venture/0(1).avif"))
            , Product 4 "Pixel Watch Strap – Google Edition" "$109" "Pixel Watch 3" False 
                [ Color "Black" "#363636" "assets/Pixel_Watch/2(0).avif"
                , Color "Brown" "#BC7049FF" "assets/Pixel_Watch/2(1).avif"
                ]
                (Just (Color "Black" "#363636" "assets/Pixel_Watch/2(0).avif"))
            ]
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = SetSortOption String
    | SelectColor Int String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetSortOption option ->
            ( { model | sortOption = option }, Cmd.none )

        SelectColor productId colorName ->
            let
                updateProduct product =
                    if product.id == productId then
                        let
                            newColor = List.filter (\c -> c.name == colorName) product.colors
                                |> List.head
                        in
                        { product | selectedColor = newColor }
                    else
                        product
            in
            ( { model | products = List.map updateProduct model.products }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ header
        , productGrid model
        
        ]


header : Html Msg
header =
    div [ class "header" ]
        [ h1 [ class "title" ] [ text "Watch Bands" ]
        , p [ class "subtitle" ] [ text "These performance watch bands give your smart watch a pop of personality and a sleek look." ]
        , div [ class "sort-container" ]
            [ select [ class "sort-dropdown" ]
                [ option [] [ text "Most popular" ]
                ]
            ]
        ]


productGrid : Model -> Html Msg
productGrid model =
    div [ class "product-grid" ]
        [ viewProduct (List.head model.products |> Maybe.withDefault defaultProduct)
        , viewProduct (List.head (List.drop 1 model.products) |> Maybe.withDefault defaultProduct)
        , freeShippingCard
        , viewProduct (List.head (List.drop 2 model.products) |> Maybe.withDefault defaultProduct)
        ]


viewProduct : Product -> Html Msg
viewProduct product =
    div
        [ class "product-card" ]
        [ if product.isBestseller then
            div [ class "bestseller-badge" ] [ text "Bestseller" ]
          else
            text ""
        , div [ class "product-image-container" ]
            [ img 
                [ class "product-image"
                , src (product.selectedColor |> Maybe.map .imageUrl |> Maybe.withDefault "")
                , alt product.name 
                ] 
                []
            ]
        , div [ class "product-info" ]
            [ h3 [ class "product-name" ] [ text product.name ]
            , p [ class "product-price" ] [ text product.price ]
            , div [ class "color-options" ]
                (List.map (\color -> 
                    div 
                        [ class "color-dot"
                        , style "background-color" color.value
                        , style "border" ("2px solid " ++ color.value)
                        , onClick (SelectColor product.id color.name)
                        ] 
                        []
                ) product.colors)
            , p [ class "watch-type" ] [ text product.watchType ]
            ]
        ]


freeShippingCard : Html Msg
freeShippingCard =
    div [ class "shipping-card" ]
        [ div []
            [ svg
                [ SvgAttr.class "fill-current w-auto max-w-full h-full stroke-0"
                , SvgAttr.width "30"
                , SvgAttr.height "21"
                , SvgAttr.viewBox "0 0 30 21"
                ]
                [ path
                    [ SvgAttr.d "M20.9439045,5.87274617 L12.560598,12.0737616 L12.3506584,12.2954064 C12.3279849,12.3289889 12.3078307,12.3650902 12.289356,12.4020309 L10.5854866,16.7677608 L9.83390294,11.3374645 L20.9439045,5.87274617 Z M14.3921107,14.646184 L12.5219691,16.5561908 L13.4935694,14.0736017 L14.3921107,14.646184 Z M27.4637875,3.19285971 L22.5705162,17.8810219 L14.5886141,12.7193859 L27.4637875,3.19285971 Z M20.6928168,4.07524087 L8.8110774,9.92196058 L4.09667463,8.60216687 L20.6928168,4.07524087 Z M29.9881008,0.71278935 C29.9679466,0.617918682 29.9335165,0.527245832 29.865496,0.415583896 L29.6337228,0.171270939 C29.5631831,0.123415824 29.4867651,0.0847959061 29.3431664,0.0444968616 C29.2810243,0.0335825371 29.2180424,0.0319034102 29.1550606,0.0344221005 L29.0526101,0 L0.631832124,7.76092432 C0.408456432,7.82221245 0.223709618,7.96745692 0.110342256,8.16811258 C-0.00134559056,8.3696078 -0.0298973708,8.60132731 0.0322447391,8.82045336 C0.111182014,9.11010275 0.341275772,9.34014313 0.630992366,9.42074121 L8.12247564,11.5188102 L9.33928534,20.3182745 C9.34684316,20.3526966 9.35776002,20.3871187 9.37035639,20.4198617 L9.40142745,20.5122136 C9.4425756,20.6045656 9.4988394,20.688522 9.58449474,20.7766761 C9.65923323,20.848039 9.74656808,20.9051293 9.84230052,20.9462679 L9.9976558,20.9798505 C10.0152907,20.9840483 10.0337654,20.9882461 10.0522401,20.9916044 L10.1378954,21 L10.1790436,20.9991604 C10.2814941,20.9983209 10.3822651,20.9790109 10.5518962,20.907648 C10.5686914,20.8992524 10.5846468,20.8908568 10.6006022,20.8816216 L10.6669431,20.8816216 L15.874284,15.6083237 L22.5772343,19.9220006 C22.7728979,20.0428977 23.0038315,20.0798385 23.2297264,20.0277856 C23.4531021,19.9740535 23.6437272,19.8372047 23.7621331,19.6441051 C23.7957235,19.5912126 23.8234355,19.5332827 23.8469487,19.4669572 L29.9612285,1.1502019 L29.9922995,0.994882661 C30.0023766,0.921840643 30.0015369,0.847119498 29.9956586,0.796745692 L29.9881008,0.71278935 Z"
                    ]
                    []
                ]
            ]
        , p [ class "shipping-text" ] [ text "Free shipping available" ]
        ]


recentlyViewed : Html Msg
recentlyViewed =
    div [ class "recently-viewed-section" ]
        [ h2 [ class "section-title" ] [ text "Recently viewed" ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none




-- HELPERS

boolToString : Bool -> String
boolToString bool =
    if bool then
        "true"
    else
        "false"


defaultProduct : Product
defaultProduct =
    Product 0 "" "" "" False [] Nothing