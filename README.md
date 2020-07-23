# cocktailBar
pet project with open api and SQLite.swift 
This application contains 4 scenes: 
1) the first scene presents collections of cocktails, which are randomly chosen every time app runs; 
   by the tap on collection app presents table view with relevant data 
2) the second scene presents search view controller, which updates simultaneously with search bar;
   when user writes something in search bar, app sends a request to api, then gets a response with data
   and inserts that data into the database
3) the third scene presents favourites view controller; app gets data for this VC from database (property "isFavourite" == true)
4) the fourth scene: detail view controller
   wherever user taps on cell, he or she can mark it as favourite by tap on heart icon in the right top corner;
   when this tap is activated, icon becomes dark (heart.fill), and this cocktail's database property "isFavourite" becomes true
