# CocktailBar
Учебный проект, сделанный в период с июня по август 2020 года. Данные получены из открытого API. 
Состоит из трех основных экранов: 
1) экран поиска 
2) экран коллекций
3) экран любимых напитков 
и экрана, в котором отображена детальная информация о каждом напитке. 

Характеристики проекта: 
- язык Swift 
- для работы с API  URLSession, для подгрузки изображений Nuke 
- локальная бд SQLite, удаленная Cloud Firestore 
- верстка через Storyboard
- зависимости CocoaPods 
- Firebase Crashlytics & Analytics  

На данный момент не устранены следующие недостатки: 
1) большой объем данных затрудняет показ ячеек
2) решение использовать SQlite кажется избыточным
3) довольно ограниченный функционал, нет почти никакой интерактивности 
4) непродуманный UX 

![](https://github.com/a-trefilova/cocktailBar/blob/master/ScreenShots/search.png)
![](https://github.com/a-trefilova/cocktailBar/blob/master/ScreenShots/detailed.png)
![](https://github.com/a-trefilova/cocktailBar/blob/master/ScreenShots/FavouritesView.png)
