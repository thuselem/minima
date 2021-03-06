module View exposing (view)

import Html exposing (Html, a, div, h1, p, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Model exposing (Direction, Model, Score, Voice)
import Update exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ title
        , showRow model.four
        , showRow model.three
        , showRow model.two
        , showRow model.one
        , showCounter model.ticks
        , instructions model.clock
        ]


title : Html Msg
title =
    div [ class "row" ]
        [ div [ class "columns" ]
            [ h1 [] [ text "minima" ] ]
        ]


showRow : Model.Voice -> Html Msg
showRow voice =
    case .pattern voice of
        [] ->
            div [ class "row align-center" ] []

        acts ->
            div [ class "row align-center" ]
                (rotateVoice voice Model.Left
                    :: List.map renderAction acts
                    ++ [ rotateVoice voice Model.Right ]
                )


renderAction : Model.Action -> Html Msg
renderAction action =
    let
        block duration text =
            div [ class ("column small-" ++ String.fromInt duration) ] text

        space =
            [ text "\u{2002}" ]
    in
    case action of
        Model.Play duration ->
            block duration [ a [ class "block expanded button" ] space ]

        Model.Rest duration ->
            block duration space


rotateVoice : Voice -> Direction -> Html Msg
rotateVoice voice direction =
    div [ class "column small-1" ]
        [ case direction of
            Model.Left ->
                a [ class "expanded hollow secondary button fa fa-chevron-left", onClick (Rotate voice direction) ] []

            Model.Right ->
                a [ class "expanded hollow secondary button fa fa-chevron-right", onClick (Rotate voice direction) ] []
        ]


showCounter : Int -> Html Msg
showCounter last =
    div [ class "counter row align-center" ]
        (counter 1 last)


counter : Int -> Int -> List (Html Msg)
counter current last =
    case current > last of
        True ->
            []

        False ->
            [ div [ class "column small-1" ] [ text (String.fromInt current) ] ]
                ++ counter (current + 1) last


instructions : Int -> Html Msg
instructions clock =
    div [ class "row align-center" ]
        [ div [ class "column small-6" ]
            [ p []
                [ text "Minima is a playground for experimenting with minimalist musical patterns." ]
            , p []
                [ text "Press "
                , a [ class "control fa fa-play", onClick Play ] []
                , text "to start the music and"
                , a [ class "control fa fa-pause", onClick Pause ] []
                , text "to stop it."
                ]
            , p []
                [ text " Select patterns with the "
                , a [ class "text-chevron secondary fa fa-chevron-left" ] []
                , text "and  "
                , a [ class "text-chevron secondary fa fa-chevron-right" ] []
                , text "buttons."
                ]
            , p []
                [ text "Minima has four beats, and the current beat is "
                , span [ class "clock" ] [ text (showClock clock ++ ".") ]
                ]
            , p []
                [ text "Have fun and I hope you enjoy!" ]
            ]
        ]


showClock : Int -> String
showClock clock =
    case clock of
        0 ->
            "0"

        1 ->
            "4"

        _ ->
            String.fromInt (clock - 1)



-- DEBUG
-- debugScore : Score -> Html Msg
-- debugScore score =
--     div [ class "row" ]
--         [ div [ class "columns" ]
--             [ h3 [] [ text (showScore score) ] ]
--         ]
-- debugClock : Int -> Html Msg
-- debugClock clock =
--     div [ class "row" ]
--         [ div [ class "columns" ]
--             [ h3 [] [ text (showClock clock) ] ]
--         ]
-- showScore : Score -> String
-- showScore score =
--     List.map .frequency score
--         |> List.map toString
--         |> String.join ", "
-- showClock : Int -> String
-- showClock clock =
--     case (clock < 2) of
--         True ->
--             toString 4
--         False ->
--             toString (clock - 1)
