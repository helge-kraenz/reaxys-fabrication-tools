# Overview

This repository contains some tools.

## arti (not supported yet)

The tool `arti` uploads an archive to artifactory.

## clean-path

The tool `clean-path` removes duplicate entries from PATH like environment
variables.

## create-archive

The tool `create-archive` is used to to create archives based on a file
list, typically uploaded to AWS automatically.

## dbstat

The tool `dbstat` takes a connect string as input and creates a statistic
for that particular database user. All fiels of all tables of the given schema
are processed and are dumped with some stats. The human readable form ist dumped to 
STDOUT while the CSV file ist dumped to STDERR.

## get-rosdal

This tool reads a ZWF (fact) file, extracts all BRNs and stores them
in memory. In the second step, it extracts all ROSDALs from a second
ROSDAL input file and dumps those which are matching to STDOUT.

## sample

The tool `sample` takes a random sample subset from a text file.

## sql

The tool `sql` allows to run SQL queries from command line.

## st

The tool `st` shows the data structure of a database.

## ut

The tool `ut` allows to enter an AWS key for AWS access.
Only useful if you don't have machine access.

## zwf-count

Counts the number of records in the files n ZWF format passed to the tools
and prints it on command line.

## zwf-create-index

Indexes ZWF files. Please refer to manual page for detailed description.

## zwf-dump

Dumps the ZWF files on the screen by replacing binary characters with non-binary.

## zwf-extract-index

Extracts data from indexed ZWF files. Currently broken. Please use zwf-sample instead.

## zwf-replace

Allows to make some replacements like absmatch does but on field level.

## zwf-sample

Extracts a referential integer subset of given ZWF file set. Please refer to manual page
for detailed description.
