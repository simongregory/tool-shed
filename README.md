# Tool Shed

[![Build Status](https://secure.travis-ci.org/simongregory/tool-shed.png)](http://travis-ci.org/simongregory/tool-shed) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/simongregory/tool-shed)

A collection of utility scripts and rake tasks to help working with ActionScript and Flex projects. They are under development, so **don't** expect too much reliability.

All tools have help available on the command line, to view use: `as-tool-name -h`

### as-docp

The `as-docp` tool can be used to generate a `flex-config.xml` file from package level ASDoc files. This can then be used by the `asdoc` tool when generating ASDocs for your project. To document a package create a single file with a `.asdoc` suffix to contain your ASDoc comments.

    as-docp -s src -o tmp/asdocp-config.xml

### as-manifest

Scans a specified source tree for ActionScript and MXML files and for each one found creates a manifest entry. When complete writes the results to disk.

    as-manifest
    as-manifest -s source/main -o project-manifest.xml
    as-manifest -f 'org.helvector'

### as-class-vacuum

Compares a `mxmlc` generated `link-report.xml` against a `manifest.xml` file to identify files that are in a project source tree but are no longer compiled into the application.

    as-class-vacuum -s src/main -o report/vacuum/class.xml -l report/link/app-link-report.xml -m manifest.xml

To generate a link report via mxmlc use `-link-report=report.xml` in the compiler arguments.

### as-style-vacuum

Loads all styles defined in **css** files (mxml isn't included) and identifies
styles that are not referenced in the source tree.

    as-style-vacuum -c source/assets -s source/main -o report/vacuum/style.xml

### as-asset-vacuum

This script scans a source tree for assets of types `jpg, jpeg, png, otf, ttf, swf, svg, mp3, gif` then searches all ActionScript, CSS and MXML files to identify which assets are not referenced in the source files.

    as-asset-vacuum
    as-asset-vacuum -s source/main -o report/vacuum/asset.xml

### as-concrete

Takes an Interface and generates a concrete class from it. Output is directed to standard out. Using the `--type` argument will change the format, by default an ActionScript class is generated, using `-t imp` only outputs the accessor and method implementations, and `-t mock4as` will generate a Mock4AS class.

    as-concrete -i IShed.as
    as-concrete -i IShed.as -t mock4as
    as-concrete -i IShed.as -t class
    as-concrete -i IShed.as -t imp

## Rake tasks

Insert Copyright headers into all of your ActionScript source files

    headers do |t|
      t.copyright = 'Copyright MMXI Big Corporation. All Rights Reserved.'
    end

To generate a manifest.xml file for use when declaring namespaces to the flex compilers

    manifest do |t|
      t.output = 'src/Desktop-manifest.xml'
      t.filter = 'bbc.ipd.view.components'
    end

To make a version file from a template which contains the keys @major@, @minor@, @patch@, @revision@

    version do |t|
      t.template = 'etc/templates/Version.as'
      t.major, t.minor, t.patch = 5, 0, 0
      t.output = 'src/org/app/Version.as'
    end

## Install

    gem install tool-shed

## License

Released under the MIT License. Please see the accompanying [LICENSE](LICENSE) document for
details.
