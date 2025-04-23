module WatchBands exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


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
    ( { sortOption = ""
      , products =
            [ Product 1 "Classic Watch Strap" "$69 – $119" "Apple Watch" True 
                [ Color "Black" "#363636" "/assets/Classic/1(2).avif"
                , Color "Green" "#5D736FFF" "/assets/Classic/1(1).avif"
                , Color "Brown" "#433231" "/assets/Classic/1(0).avif"
                , Color "Tan" "#BC7049FF" "/assets/Classic/1(3).avif"
                ]
                (Just (Color "Black" "#363636" "/assets/Classic/1(0).avif"))
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
        
        ]


productGrid : Model -> Html Msg
productGrid model =
    div [ class "product-grid" ]
        [ viewProduct (List.head model.products |> Maybe.withDefault defaultProduct)
        
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
                        [ classList 
                            [ ("color-dot", True)
                            , ("selected", Just color == product.selectedColor)
                            ]
                        , style "background-color" color.value
                        , style "border-color" (if Just color == product.selectedColor then color.value else "transparent")
                        , onClick (SelectColor product.id color.name)
                        ] 
                        []
                ) product.colors)
            , p [ class "watch-type" ] [ text product.watchType ]
            ]
        ]


freeShippingCard : Html msg
freeShippingCard =
    div [ class "shipping-card" ]
        [ div [ class "shipping-icon" ]
            [ node "svg"
                [ attribute "viewBox" "0 0 30 21"
                , attribute "fill" "none"
                , attribute "xmlns" "http://www.w3.org/2000/svg"
                ]
                [ node "path"
                    [ attribute "d" "M29.5 10.5C29.5 15.7467 25.2467 20 20 20C14.7533 20 10.5 15.7467 10.5 10.5C10.5 5.25329 14.7533 1 20 1C25.2467 1 29.5 5.25329 29.5 10.5Z"
                    , attribute "stroke" "currentColor"
                    ]
                    []
                , node "path"
                    [ attribute "d" "M20 10.5H0.5M0.5 10.5L4.5 6.5M0.5 10.5L4.5 14.5"
                    , attribute "stroke" "currentColor"
                    ]
                    []
                ]
            ]
        , p [ class "shipping-text" ]
            [ text "Free shipping"
            , br [] []
            , text "worldwide"
            ]
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