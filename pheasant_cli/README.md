# The Pheasant Framework Command Line Interface
This is the package for the Pheasant Command Line Interface Application. 

`pheasant` is a cli tool for creating, testing, running and working on pheasant applications. With this tool, you can quickly get started with creating your pheasant projects with ease.

## New to Pheasant?
You can get started with the pheasant framework [here](https://github.com/pheasantframework/pheasant).

## Getting Started
### NOTE
Because of the scope/range of the dart compiler, you may not be able to run development versions of your projects outside Google Chrome. For now, ensure that you have Google Chrome installed on your system, or run your projects in release mode.

In order to install the cli, all you need to do is run the following command
```bash
dart pub global activate pheasant_cli
```

Once this command is run, the pheasant cli executable will be installed to your system. From there you can start using the `pheasant` command

```bash
pheasant -v
```

## Useful Commands
### Create a Project
In order to create a new pheasant project, run the following command and answer the prompts to configure the project (the answers to "`y/N`" questions default to "No").
```bash
pheasant init <proj-name> [-d <directory>]
```

You can also use the `create` command in place of the `init` commmand.

### Run a Project Server
Run the following command at the root of your project:
```bash
pheasant run [-p <port-number>]
```

You can also use the `serve` command in place of the `run` command, but you may not be able to run release modes of the project with the `serve` command.

### Build a Project Server for Deployment
```bash
pheasant build
```

If you want to check out all the commands this has, you can quickly run `pheasant` or `pheasant --help`. In order to get info on a certain command, run `pheasant help <command>`.

## License
This project uses the [MIT License](LICENSE).