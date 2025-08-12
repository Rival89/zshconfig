#!/usr/bin/env bash
# Author: Alexander Epstein https://github.com/alexanderepstein

# A script to get information about movies from the OMDb API

movies() {
    if [ "$#" -eq 0 ]; then
        echo "Usage: movies <movie title>"
        return 1
    fi

    local api_key="${OMDB_API_KEY:-}"
    if [[ -z $api_key ]]; then
        echo "OMDB_API_KEY environment variable is not set" >&2
        return 1
    fi
    local movie_title="$*"
    local url="http://www.omdbapi.com/?t=${movie_title// /+}&apikey=${api_key}"
    local response

    if ! command -v jq &>/dev/null; then
        echo "jq is not installed"
        return 1
    fi

    if ! command -v curl &>/dev/null; then
        echo "curl is not installed"
        return 1
    fi

    response=$(curl -s "$url")

    if ! echo "$response" | jq -e '.Title' &>/dev/null; then
        echo "Movie not found"
        return 1
    fi

    echo "Title: $(echo "$response" | jq -r '.Title')"
    echo "Year: $(echo "$response" | jq -r '.Year')"
    echo "Rated: $(echo "$response" | jq -r '.Rated')"
    echo "Released: $(echo "$response" | jq -r '.Released')"
    echo "Runtime: $(echo "$response" | jq -r '.Runtime')"
    echo "Genre: $(echo "$response" | jq -r '.Genre')"
    echo "Director: $(echo "$response" | jq -r '.Director')"
    echo "Writer: $(echo "$response" | jq -r '.Writer')"
    echo "Actors: $(echo "$response" | jq -r '.Actors')"
    echo "Plot: $(echo "$response" | jq -r '.Plot')"
    echo "Language: $(echo "$response" | jq -r '.Language')"
    echo "Country: $(echo "$response" | jq -r '.Country')"
    echo "Awards: $(echo "$response" | jq -r '.Awards')"
    echo "IMDb Rating: $(echo "$response" | jq -r '.imdbRating')"
}
