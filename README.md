# Tool Shed

A collection of utility scripts to help working with ActionScript and Flex 
projects. These scripts are under development, so **don't** expect reliability.

### as-docp

The `as-docp` tool is a utility that can be used to generate a flex config file 
from package level ASDoc files. For each package you want to document place your
asdoc comments in a file with a .asdoc suffix. The `as-docp` tool can then be
used to gather these together in a flex-config.xml file to pass to the asdoc 
tool when building your documentation.

### as-manifest

Scans a specified source tree for ActionScript and MXML files and for each one
found creates a manifest entry. When complete writes the results to disk.

### as-class-dector

This tool compares a mxmlc generated link-report against a manifest file
created by the as-manifest tool to identify files that are in the project
source tree but are no longer used by the application.

Before executing this script make sure the relevant link reports and manifest
files have been generated.

### as-style-dector

Detects styles that are not used in a Flex application.

### as-asset-dector

Under development. This script scans all ActionScript classes and CSS files in a
project to identify assets, such as png files, that are in the project source
tree but are no longer referenced by the application.

## Install

    gem install tool-shed

## Using

Examples will follow once the tools are in a stable state.
  
## Authors

[Simon Gregory](http://simongregory.com)

## License

Released under the MIT License. Please see the accompanying [LICENSE](LICENSE) document for
details.

