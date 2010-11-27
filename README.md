# Tool Shed

A collection of utility scripts to help working with ActionScript and Flex 
projects. These scripts are under development, so **don't** expect reliability.

### as-docp

The `as-docp` tool can be used to generate a `flex-config.xml` file from package
level ASDoc files. This can then be used by the `asdoc` tool when generating
ASDocs for your project.

To document a package create a single file with a `.asdoc` suffix to contain
your ASDoc comments.

### as-manifest

Scans a specified source tree for ActionScript and MXML files and for each one
found creates a manifest entry. When complete writes the results to disk.

### as-class-vacuum

Compares a `mxmlc` generated `link-report.xml` against a `manifest.xml` file to
identify files that are in a project source tree but are no longer compiled
into the application.

### as-style-vacuum

Detects styles that are not used in a Flex application.

### as-asset-vacuum

This script scans a source tree for assets of types `jpg, jpeg, png, otf, ttf, 
swf, svg, mp3, gif` then searches all ActionScript, CSS and MXML files to 
identify which assets are not referenced in the source files.

## Install

    gem install tool-shed

## Using

Examples will follow once the tools are in a stable state.
  
## Authors

[Simon Gregory](http://simongregory.com)

## License

Released under the MIT License. Please see the accompanying [LICENSE](LICENSE) document for
details.

