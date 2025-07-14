# Recipe Parser

## Overview

The project was inspired by real-life frustrations of searching for recipes across the web, in which all recipe websites somehow have to bombard its viewers first with ads and lengthy overview and even the history of the dish, before presenting its actual recipe information.  

This SwiftUI app aims to ease the experience of viewing recipes saved from various recipe websites by presenting it in a easy-to-use, intuitive mobile application.

### Features

- Parse and save recipes from websites.
- View collection of saved recipes.

## Project Configuration

For sensitive values (API URLs, access tokens, etc.), do the following:

- In the `/Configs` folder, create a new `.xcconfig` files. Add variables as needed, prefixed with `CONFIG_`.

  _**NOTE:** Make sure that during file creation, no target is selected._

- In **_Project Settings -> Configurations_**, set the created config files corresponding to its Configuration.

To access these user-defined settings and configuration variables in the app:

- Declare the keys and values in both the `RecipeParser` and `RecipeParserShareExtension` `Info.plist` files.
- In `Bundle` extension, you will see some variables declared for retrieving said values from `Info.plist`.
- Add/Update variables accordingly.
