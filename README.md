# Tool Shed

A collection of utility scripts to help working with ActionScript and Flex 
projects. These scripts are under development, so **don't** expect reliability.

All tools have help available on the command line, to view use:

    as-tool-name -h

### as-docp

The `as-docp` tool can be used to generate a `flex-config.xml` file from package
level ASDoc files. This can then be used by the `asdoc` tool when generating
ASDocs for your project.

To document a package create a single file with a `.asdoc` suffix to contain
your ASDoc comments.

Example use:

    as-docp -s src -o tmp/asdocp-config.xml

### as-manifest

Scans a specified source tree for ActionScript and MXML files and for each one
found creates a manifest entry. When complete writes the results to disk.

Example use:

    as-manifest
    as-manifest -s source/main -o project-manifest.xml
    as-manifest -f 'org.helvector'

### as-class-vacuum

Compares a `mxmlc` generated `link-report.xml` against a `manifest.xml` file to
identify files that are in a project source tree but are no longer compiled
into the application.

Example use:

    as-class-vacuum -s src/main -o report/vacuum/class.xml -l report/link/app-link-report.xml -m manifest.xml

To generate a link report via mxmlc use `mxmlc -link-report=report.xml`

### as-style-vacuum

Loads all styles defined in **css** files (mxml isn't included) and identifies
styles that are not referenced in the source tree.

Example use:

    as-style-vacuum -c source/assets -s source/main -o report/vacuum/style.xml

### as-asset-vacuum

This script scans a source tree for assets of types `jpg, jpeg, png, otf, ttf, 
swf, svg, mp3, gif` then searches all ActionScript, CSS and MXML files to 
identify which assets are not referenced in the source files.

Example use:
    
    as-asset-vacuum
    as-asset-vacuum -s source/main -o report/vacuum/asset.xml

## Install

    gem install tool-shed

## Authors

[Simon Gregory](http://simongregory.com)

## License

Released under the MIT License. Please see the accompanying [LICENSE](LICENSE) document for
details.
