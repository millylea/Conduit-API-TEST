
Feature: Articles
    Background: Define URL
        Given url apiURL
        * def articleRequestBody = read ('classpath:conduitApp/json/newArticleRequest.json')
        * def dataGenerator = Java.type('helpers.DataGenerator')
        # * set articleRequestBody.article.title = __gatling.Title
        # * set articleRequestBody.article.description = __gatling.Description
        * set articleRequestBody.article.title = dataGenerator.getRandomArticleValues().title
        * set articleRequestBody.article.description = dataGenerator.getRandomArticleValues().description
        * set articleRequestBody.article.body = dataGenerator.getRandomArticleValues().body
        
    Scenario: Create and delete an article
       * configure headers = {"Authorization": #('Token '+ __gatling.token)}
        Given path "articles"
        And request  articleRequestBody
        And header report-name = "Create articles: " + dataGenerator.getRandomArticleValues().title
        When method Post
        Then status 201
        * def articleID =  response.article.slug
        
        # * karate.pause(5000)

        # Given path "articles", articleID
        # When method Delete 
        # Then status 204


