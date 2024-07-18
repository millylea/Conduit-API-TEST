
Feature: Hooks
    Background: Hooks
        # * def result = callonce read('classpath:helpers/Dummy.feature')
        # * def username = result.username
        * configure afterScenario = function(){ karate.call('classpath:helpers/Dummy.feature') }
        * configure afterFeature = function(){ karate.log('after feature') }
    Scenario: First Scenario
        # * print username
        * print "this is the 1st scenario"
    Scenario: Second Senario
        # * print username
        * print "this is the 2nd scenario"