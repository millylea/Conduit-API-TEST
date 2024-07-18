
Feature: Sign up new user
    Background: Preconditions
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * def randomEmail = dataGenerator.getRandomEmail()
        * def randomUsername = dataGenerator.getRandomUsername()
        Given url apiURL

    Scenario: Create new user
        Given path "users"
        And request
        """
        {
                "user": {
                    "email": #(randomEmail),
                    "password": "12345",
                    "username": #(randomUsername)
                }
            }
        """
        When method Post
        Then status 201
        And match response ==
        """
        {
            "user": {
                "id": "#number",
                "email": "#(randomEmail)",
                "username": "#(randomUsername)",
                "bio": null,
                "image": "##string",
                "token": "#string"
            }
        }
        """
    
    
    Scenario Outline:  Validate sign up error

        Given path "users"
        And request
        """
        {
                "user": {
                    "email": "<email>",
                    "password": "<password>",
                    "username": "<username>"
                }
            }
        """
        When method Post
        Then status 422
        And match response == <errorResponse>
    
        Examples:
            | email            |  password | username          | errorResponse                                      |
            | #(randomEmail)   |  12345    | coconutttttt      | {"errors":{"username":["has already been taken"]}} |
            | cocnut@gmail.com |  12345    | #(randomUsername) | {"errors":{"email":["has already been taken"]}}    |
            | cocnut           |  12345    | #(randomUsername) | {"errors":{"email":["has already been taken"]}}    |
