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