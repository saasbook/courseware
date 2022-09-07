Feature: start a new game

  As an avid TTT player
  So that I can play TTT
  I want to start a new game

Scenario: start new game

  When I visit the site for the first time
  Then I should see an empty board
  And I should see "x's move"
