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


type alias Product =
    { id : Int
    , name : String
    , price : String
    , watchType : String
    , isBestseller : Bool
    , imageUrl : String
    }


type alias Model =
    { sortOption : String
    , products : List Product
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { sortOption = "Most popular"
      , products =
            [ Product 1 "Classic Watch Strap" "$69 – $119" "Apple Watch" True "/assets/0.avif"
            , Product 2 "Venture Watch Strap" "$49 – $85" "Apple Watch" True "/assets/0 (1).avif"
            , Product 4 "Watch Strap – Second Edition" "$59 – $99" "Apple Watch" False "/assets/0 (2).avif"
            ]
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = SetSortOption String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetSortOption option ->
            ( { model | sortOption = option }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ header
        , productGrid model
        , recentlyViewed
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
                , src product.imageUrl
                , alt product.name 
                ] 
                []
            ]
        , div [ class "product-info" ]
            [ h3 [ class "product-name" ] [ text product.name ]
            , p [ class "product-price" ] [ text product.price ]
            , div [ class "color-options" ]
                [ div [ class "color-dot black" ] []
                , div [ class "color-dot gray" ] []
                , div [ class "color-dot brown" ] []
                , div [ class "color-dot tan" ] []
                ]
            , p [ class "watch-type" ] [ text product.watchType ]
            ]
        ]


freeShippingCard : Html Msg
freeShippingCard =
    div [ class "shipping-card" ]
        [ div [ class "shipping-icon" ] []
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
    Product 0 "" "" "" False ""