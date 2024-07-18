
Feature: Articles
    Background: Define URL
        Given url apiURL
        * def articleRequestBody = read ('classpath:conduitApp/json/newArticleRequest.json')
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * set articleRequestBody.article.title = dataGenerator.getRandomArticleValues().title
        * set articleRequestBody.article.description = dataGenerator.getRandomArticleValues().description
        * set articleRequestBody.article.body = dataGenerator.getRandomArticleValues().body

    @skipme
    Scenario: create a new articles
        Given path "articles"
        And request articleRequestBody
        When method Post
        Then status 201
        And match response.article.title == articleRequestBody.article.title
    
    
    Scenario: Create and delete an article

        # Given header Authorization = "Token " + token
        Given path "articles"
        And request  articleRequestBody
        When method Post
        Then status 201
        * def articleID =  response.article.slug

        # Given header Authorization = "Token " + token
        Given params {limit:10, offset:0}
        Given path "articles"
        When method Get
        Then status 200
        And match response.articles[0].title == articleRequestBody.article.title
        

        # Given header Authorization = "Token " + token
        Given path "articles", articleID
        When method Delete 
        Then status 204

        Given params {limit: 10, offset:0}
        Given path "articles"
        When method Get
        Then status 200
        And match response.articles[0].title != "delete article"

