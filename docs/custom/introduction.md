# Creating Plugins for The Pheasant Framework
One of the aims of the Pheasant Framework is for it to be a modular framework: one that you can customize with your own components and functionality. That way, our framework doesn't need to be a "do it only like this" framework, but "you can also add this". That way, others can make use of solutions they might've made or used, and build on their pheasant applications with them.

Pheasant plugins, as of now, only support functionality that can run on the web (main plugins). In coming versions, we will add support for functionality that can build upon the CLI, and *dev plugins*.

## Getting Started
A pheasant plugin structure is just like that of a dart package, but one that is compatible with the pheasant framework. Therefore, the first part is to ensure your package follows *dart package conventions*.

A typical structure for your pheasant plugin should look like the following:
```log
project/                        
├── example/                          
│   └── ... 
├── ...           
├── lib/  
│   ├── src/
│   |   └── ...   
│   ├── components.dart  # Entrypoint for Custom Components       
│   ├── state.dart       # Entrypoint for Custom State Declarations
│   ├── extensions.dart  # Entrypoint for Custom Application Extensions
│   └── <pkg-name>.dart  # Entrypoint for Other Functionality (like normal functions)
├── ... 
├── LICENSE
├── pubspec.yaml
├── pheasant.plugin # Information about your plugin not specified in pubspec.yaml
└── README.md
```

In order to get started, you can use the pheasant cli to generate a new plugin project. Create a project as needed, but use the `-t` or `--type` option to set the project created to `'plugin'`
```bash
pheasant init -t plugin <name>
```

This will create a plugin project like the one denoted above, with the major difference being the `example/` folder looking a bit different. The `example/` folder will contain an example pheasant application you can use to test/demonstrate the use of your project (you won't need this if you plan to only make a normal dart project exporting functionality, in such case you can use a normal dart project).

You will also see a `pheasant.yaml` file included. This file is only needed if you plan to *run builds* on your project, or *make use of other plugins*. If your use case doesn't need these, then you can kindly ignore the file.

## The Structure
Most of the files you may already be conversant with. Below are information regarding other files you may see:

- `pheasant.plugin`: This file will be used to denote information used to describe your plugin, and any other necessary information that the `pheasant.yaml` or `pubspec.yaml` file may not be able to contain. 
- `lib/components.dart`: This will act as the entrypoint for all your pheasant components used in `.phs` files. You can read more on [making components](./components.md). While this file is not compulsory, it is recommended for a good separation of concerns.
- `lib/state.dart` (not yet implemented): This will act as the entrypoint for any state libraries you intend to use to override current state functionality in pheasant. While this file is not compulsory, it is recommended for a good separation of concerns.
- `lib/extensions.dart` (not yet implemented): This will act as the entrypoint for any functionality like routing you intend to use to extend application functionality in pheasant. While this file is not compulsory, it is recommended for a good separation of concerns.
