Feature: Add likes
Background:
    * url apiURL
Scenario: add Likes
    Given path "articles", slug , "favorite"
    And request {}
    When method Post
    Then status 200
    * def likesCount = response.article.favoriteCount