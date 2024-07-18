@debug
Feature: Tests for home page
    Background: Define URL
        Given url apiURL
  
    Scenario: Get all tags
        # Given url "https://api.realworld.io/api/"
        Given path "tags"
        When method Get
        Then status 200
        And match response.tags contains ["facilis", "quia"]
        And match response.tags !contains "baby"
        And match response.tags == "#array"
        And match response.tags contains any ['fish', 'enim', 'cat']
        And match each response.tags == "#string"

        * def rawRequest = karate.prevRequest
        * print rawRequest 
    
    Scenario: Get 10 articles im the page
        * def timevalidator = read('classpath:helpers/timevalidator.js')
        Given params {limit: 10, offset: 0}
        Given path "articles"
        When method Get
        Then status 200
        And match response.articles =="#[10]"
        # And match response == {"articles":"#array", "articlesCount": 257}
        And match each response.articles ==
        """
        {
            "slug": "#string",
            "title": "#string",
            "description": "#string",
            "body": "#string",
            "tagList": "#array",
            "createdAt": "#? timevalidator(_)",
            "updatedAt": "#? timevalidator(_)",
            "favorited": #boolean,
            "favoritesCount": #number,
            "author": {
                "username": "#string",
                "bio": ##string,
                "image": "#string",
                "following": #boolean
            }
        }
        """
    
    Scenario: Conditional Logic
        Given params { limit:10, offset: 0}
        Given path "articles"
        When method Get
        Then status 200
        * def favoritecount = response.articles[0].favoritesCount
        * def article = response.articles[0]

        # * if (favoritecount == 0) karate.call('classpath:helpers/Addlikes.feature', article)
        * def result = favoritecount == 0 ? karate.call('classpath:helpers/Addlikes.feature', article).likesCount : favoritecount

        Given params { limit:10, offset: 0}
        Given path "articles"
        When method Get
        Then status 200
        And match response.articles[0].favoritesCount == result
    
    Scenario: Retry call
        * configure retry = {count: 10 , interval: 5000}
        Given params { limit:10, offset: 0}
        Given path "articles"
        And retry until response.articles[0].favoritesCount == 1
        When method Get
        Then status 200
    
    Scenario: Sleep Call
        * def sleep = function(pause){ java.lang.Thread.sleep(pause) }
        Given params { limit:10, offset: 0}
        Given path "articles"
        And retry until response.articles[0].favoritesCount == 1
        When method Get
        * eval sleep(5000)
        Then status 200
    
    Scenario: Number to string
        * def foo = 10
        * def json = {'bar': #(foo + '')}
        * match json == {'bar': '10'}

    Scenario: String to number
        * def foo = '10'
        # * def json = {'bar': #(foo * 1)}
        * def json = {'bar': #(~~parseInt(foo))}
        * match json == {'bar': 10}
 

            