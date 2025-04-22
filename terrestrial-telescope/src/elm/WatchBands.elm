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


type alias Model =
    { sortOption : String
    , showingPopup : Bool
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { sortOption = "Most popular"
      , showingPopup = True
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = SetSortOption String
    | TogglePopup
    | ClosePopup


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetSortOption option ->
            ( { model | sortOption = option }, Cmd.none )

        TogglePopup ->
            ( { model | showingPopup = not model.showingPopup }, Cmd.none )

        ClosePopup ->
            ( { model | showingPopup = False }, Cmd.none )



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
        [ productCard "Classic Watch Strap" "$69 – $119" "Apple Watch" True
        , productCard "Venture Watch Strap" "$49 – $85" "Apple Watch" True
        , freeShippingCard
        , secondEditionCard model
        , productCard "Pixel Watch Strap – Google Edition" "$109" "Pixel Watch 3" False
        ]


productCard : String -> String -> String -> Bool -> Html Msg
productCard name price watchType isBestseller =
    div [ class "product-card" ]
        [ if isBestseller then
            div [ class "bestseller-badge" ] [ text "Bestseller" ]

          else
            text ""
        , div [ class "product-image" ] []
        , div [ class "product-info" ]
            [ h3 [ class "product-name" ] [ text name ]
            , p [ class "product-price" ] [ text price ]
            , div [ class "color-options" ]
                [ div [ class "color-dot black" ] []
                , div [ class "color-dot gray" ] []
                , div [ class "color-dot brown" ] []
                , div [ class "color-dot tan" ] []
                ]
            , p [ class "watch-type" ] [ text watchType ]
            ]
        ]


secondEditionCard : Model -> Html Msg
secondEditionCard model =
    div [ class "product-card" ]
        [ div [ class "product-image" ] []
        , div [ class "product-info" ]
            [ h3 [ class "product-name" ] [ text "Watch Strap – Second Edition" ]
            , p [ class "product-price" ] [ text "$59 – $99" ]
            , div [ class "color-options" ]
                [ div [ class "color-dot black" ] []
                , div [ class "color-dot gray" ] []
                , div [ class "color-dot brown" ] []
                , div [ class "color-dot tan" ] []
                ]
            , p [ class "watch-type" ] [ text "Apple Watch" ]
            ]
        , if model.showingPopup then
            div [ class "popup" ]
                [ div [ class "popup-header" ]
                    [ div [ class "close-button", onClick ClosePopup ] [ text "CLOSE ×" ]
                    ]
                , div [ class "popup-content" ]
                    [ div [ class "popup-image-container" ]
                        [ div [ class "popup-image" ] []
                        , div [ class "popup-image" ] []
                        ]
                    ]
                ]
          else
            text ""
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



-- CSS (would typically be in a separate stylesheet)
-- You would add your CSS styling here or link to an external stylesheet