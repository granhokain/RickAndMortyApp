# RickAndMortyApp

Application developed in Swift that shows information about episodes and characters from the Rick and Morty TV Show. The architecture with which it has been developed is MVVM (Model View ViewModel).

## Stack

- [MVVM pattern](MVVM)
- [Cocoapods](https://cocoapods.org/)
- [Moya](https://github.com/Moya/Moya)
- [SDWebImage](https://github.com/SDWebImage/SDWebImage)
- [WebKit](https://developer.apple.com/documentation/webkit)

## Architecture

Model-View-ViewModel (MVVM) is a structural design pattern that separates objects into three distinct groups:
- **Models** hold application data. They’re usually structs or simple classes.
- **Views** display visual elements and controls on the screen. They’re typically subclasses of UIView.
- **View models** transform model information into values that can be displayed on a view. They’re usually classes, so they can be passed around as references.

![MVVM](https://koenig-media.raywenderlich.com/uploads/2018/04/MVVM_Diagram.png)

## Building

Building the app requires [Cocoapods](https://cocoapods.org/).

After clone the repo, install the dependencies:

```
pod install
```
