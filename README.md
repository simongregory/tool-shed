# ActionScript and Flex Project Tools

A collection of utility scripts for working with ActionScript and Flex projects.

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

## Install

    gem install hel-tools

## Using

## Authors

[Simon Gregory](http://simongregory.com)

## License

Released under the MIT License. Please see the accompanying LICENSE document for
details.
