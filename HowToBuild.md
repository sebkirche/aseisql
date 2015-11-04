

# Requirements #
  * Windows NT,XP,+
  * PowerBuilder version 10.2.0 build 8100
  * Path environment variable that refers to powerbuilder common libraries
  * TortoiseSVN and Subversion (command line tools) version 1.5.`*`, 1.6.`*` (later versions should work too)

# How to organize local workspace #
This paragraph is only a proposal how to organize aseisql project workspace.

Let's create a aseisql project root directory, where we will place sources and libraries:

`c:\projects\AseisqlProject`

Check out the sources from repository into `\AseisqlProject\svn`

Refer [Source](http://code.google.com/p/aseisql/source/checkout) page to see how to access repository.

> command example to get sources latest version as guest (read-only):

> `svn checkout http://aseisql.googlecode.com/svn/trunk/ c:\projects\AseisqlProject\svn`

> command example to get latest version (you must be a project member):

> `svn checkout http://aseisql.googlecode.com/svn/trunk/ c:\projects\AseisqlProject\svn --username your@mail.dom`

# How to build pb libraries #
To start work in pb you need to create PB libraries.

To do that, you can use the batch `\AseisqlProject\svn\build\build_pbl.cmd`

This batch uses [pborca tool](http://dm.char.com.ua/pb/pborca.htm) to build libraries.

You can check the `build_pbl.orc` file to see the `orca` commands to be executed.

## Result ##
There will be created `\AseisqlProject\pb` directory,
where all the required files (images, DLLs, workspace, target, and PBLs) will be placed.

Now you can open the workspace of the project:

`\AseisqlProject\pb\aseisql.pbw`

# How to build executable #

To do that, you can use the batch `\AseisqlProject\svn\build\build_exe.cmd`

This batch uses [pborca tool](http://dm.char.com.ua/pb/pborca.htm) to build libraries and executable.

You can check the `build_exe.orc` file to see the `orca` commands to be executed.

## Result ##
There will be created `\AseisqlProject\exe` directory,
where all the deploy files will be placed.