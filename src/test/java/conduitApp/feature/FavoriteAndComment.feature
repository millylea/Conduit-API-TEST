
Feature: Favorite and Comment
    Background: Preconditions
        Given url apiURL 
        * def timevalidator = read('classpath:helpers/timevalidator.js')
    Scenario: Favorite articles
        # Step 1: Get atricles of the global feed
        Given path "articles"
        Given params {limit: 10, offset: 0}
        When method Get
        Then status 200
        # Step 2: Get the favorites count and slug ID for the first arice, save it to variables
        * def articleID = response.articles[0].slug
        * def favoritecount = response.articles[0].favoritesCount
        
        # Step 3: Make POST request to increse favorites count for the first article
        Given path "articles" , articleID , "favorite"
        When method Post
        Then status 200
        # Step 4: Verify response schema
        And match response.article ==
        """
            {   "id": "#number",
                "slug": "#string",
                "title": "#string",
                "description": "#string",
                "body": "#string",
                "createdAt": "#? timevalidator(_)",
                "updatedAt": "#? timevalidator(_)",
                "authorId": "#number",
                "tagList": [],
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": #boolean
                },
                "favoritedBy": [
                    {
                        "id": 37623,
                        "email": "#string",
                        "username": "#string",
                        "password": "#string",
                        "image": "#string",
                        "bio": "##string",
                        "demo": #boolean
                    }
                ],
                "favorited": #boolean,
                "favoritesCount": "#number"
            }
        """
        # Step 5: Verify that favorites article incremented by 1
        * def initialCount = 0
        * def fav_response = {"favoritesCount": 1}
        And match fav_response.favoritesCount == initialCount + 1

        # getuser
        Given path "user"
        When method Get
        Then status 200
        * def username = response.user.username

        # Step 6: Get all favorite articles
        Given path "articles"
        Given params {favorited: #(username), limit: 10, offset: 0}
        When method Get
        Then status 200
        # Step 7: Verify response schema
        And match each response.articles ==
        """
                {
                    "slug": "#string",
                    "title": "#string",
                    "description": "#string",
                    "body": "#string",
                    "tagList": "#array",
                    "createdAt":  "#? timevalidator(_)",
                    "updatedAt":  "#? timevalidator(_)",
                    "favorited": #boolean,
                    "favoritesCount": "#number",
                    "author": {
                        "username": "#string",
                        "bio": "##string",
                        "image": "#string",
                        "following": #boolean
                    }
                }
      
        """
        And match response.articlesCount == "#number"
        # Step 8: Verify that slug ID from Step 2 exist in one of the favorite articles
        And match response.articles[0].slug == articleID

    Scenario: Comment articles
        # Step 1: Get atricles of the global feed
        Given path "articles"
        Given params {limit: 10, offset: 0}
        When method Get
        Then status 200
        # Step 2: Get the slug ID for the first arice, save it to variable
        * def articleID = response.articles[0].slug
        # Step 3: Make a GET call to 'comments' end-point to get all comments
        Given path "articles", articleID , "comments"
        When method Get
        Then status 200

       
        
        # Step 5: Get the count of the comments array lentgh and save to variable
        * def commentsCount = response.comments.length

        # Step 6: Make a POST request to publish a new comment
        Given path "articles", articleID , "comments"
        And request {"comment":{"body":"hey"}}
        When method Post
        Then status 200
        * def commentID = response.comment.id


        # Step 7: Verify response schema that should contain posted comment text
        # Step 8: Get the list of all comments for this article one more time
        Given path "articles", articleID , "comments"
        When method Get
        Then status 200
        And match response.comments[*].id contains [#(commentID)]
        # Step 4: Verify response schema 
        And match each response.comments ==
        """
        {
            "id": "#number",
            "createdAt": "#? timevalidator(_)",
            "updatedAt": "#? timevalidator(_)",
            "body": "#string",
            "author": {
                "username": "#string",
                "bio": ##string,
                "image":"#string",
                "following": #boolean,
            }
        }
        """
        # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
        * def newCommentCount = response.comments.length
        And match newCommentCount == commentsCount +1
        
        # Step 10: Make a DELETE request to delete comment
        Given path "articles", articleID , "comments", commentID
        When method Delete
        Then status 200
        # Step 11: Get all comments again and verify number of comments decreased by 1
        Given path "articles", articleID , "comments"
        When method Get
        Then status 200
        And match response.comments[*].id !contains [#(commentID)]
        * def afterDeleteCommentCount = response.comments.length
        And match afterDeleteCommentCount == newCommentCount - 1