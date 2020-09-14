<div align="center"><img src="https://euler.arguiot.com/Euler.svg" alt="Logo" height="200"><h1>Euler</h1>
A computanional framework written in Swift
</div>

Euler is a mathematical framework that is packed up with tons of useful mathematical functions. It is composed of functions in most mathematical fields such as algebra, number theory, statistics, etc... It was designed to help you turn your computer into a mathematical guru.
# Links
- **Documentation:** https://euler.arguiot.com

## Installation
:warning: There is a known issue that causes the build to fail when using Xcode 11.4 or superior. When you want to use Euler on the latest Xcode versions, consider using Cocoapods. 

I’m already working with Apple to fix this, but if you have the solution, please open a pull request.
### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Euler into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'Euler', '~> 0.3.0'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate Euler into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "arguiot/Euler" ~> 0.3.0
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but Euler does support its use on supported platforms.

Once you have your Swift package set up, adding Euler as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/arguiot/Euler.git", .upToNextMajor(from: "0.3.0"))
]
```

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate Euler into your project manually.

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

  ```bash
  $ git init
  ```

- Add Euler as a git [submodule](https://git-scm.com/docs/git-submodule) by running the following command:

  ```bash
  $ git submodule add https://github.com/arguiot/Euler.git
  ```

- Open the new `Euler` folder, and drag the `Euler.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `Euler.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `Euler.xcodeproj` folders each with two different versions of the `Euler.framework` nested inside a `Products` folder.

    > It does not matter which `Products` folder you choose from, but it does matter whether you choose the top or bottom `Euler.framework`.

- Select the top `Euler.framework` for iOS and the bottom one for macOS.

    > You can verify which one you selected by inspecting the build log for your project. The build target for `Euler` will be listed as either `Euler iOS`, `Euler macOS`, `Euler tvOS` or `Euler watchOS`.

- And that's it!

  > The `Euler.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.


# Showcase
Here is a list of apps using Euler to work (not exhaustive)

<img src="https://euler.arguiot.com/Euclid.png" alt="Euclid" height="200">

> **Euclid Calculator**
>
> Euclid is a modern and fully featured calculator for macOS that aims to replace the default calculation app. Euclid uses Euler to parse and evaluate every calculations. It relies heavily on the Algebra and Tables modules.

# Project
### Inspiration

The project was largely inspired by:
- [TheoremJS](https://theorem.js.org)
- [SymPy](https://www.sympy.org/)
- [Swift BigInt](https://github.com/mkrd/Swift-BigInt)
- [Wolfram Language](https://www.wolfram.com/language/)

### Why Swift
In retrospect, it isn’t a surprise that Swift is a good fit for the needs of this project. Swift was designed and built by a close-knit team. That team previously built a highly modular and composable compiler infrastructure (LLVM), a compiler and runtime for a highly dynamic Smalltalk-derived language (Objective-C), the compiler for a highly static language with a capable generics system (C++), and a path-sensitive static analysis engine (the Clang static analyzer). Furthermore, the goals for Swift’s design was to build something that was as easy to learn and use as a scripting language, but which had enough power to be used as a system’s programming language.

Swift was the perfect language, because of its performance, modularity, easy to read syntax and concurrency APIs. Swift aims to maximize clarity of code, and thus it fights to reduce boilerplate. The top-end goal of Swift is to optimize the time it takes to write and maintain the project, which includes debugging time and other things that go beyond just pounding out the code.

### Goal
Euler aims to provide provide the building blocks of numerical computing in Swift, as a set of fine-grained modules bundled together into a single Swift package. Euler is intended to be used to experiment with Swift and with its math capabilities. It also aims to serve as an algorithm database that could be ported to other languages.
### Organization
Euler is built around two main objects: `BigDouble` and `BigInt`. They are both used to represent big numbers with precision. You can see Euler as a set of modules:
- Numerics: `BigDouble` / `BigInt` & more
	> Helps to work with numbers
- Algebra: `Expression`
	> Helps parsing and working with mathematical expressions
- Tables
	> `Tables` was made for developing Excel-like software / parser.
- Statistics
	> `Statistics` was designed to help with the mathematics of the collection, organization, and interpretation of numerical data, especially the analysis of population characteristics by inference from sampling.

- Visualisation & Geometry (`Graph`)
	> Utility for visualizing any set of `Point` using SwiftPlot.
- Matrix & Vectors
	> Simple Matrix/Vector type. :warning: It only works on Apple devices, where 	`Accelerate` is supported.
- Cryptography
	> Basic crypto algorithm implemented. We don’t recommend using this in production as this is more for experimental purpose.


