# NLM Scrubber Wrappers

This package wraps the [NLM Scrubber](https://scrubber.nlm.nih.gov/) to make it easily accessible for a variety of programs.

This package includes three components-

1. A Docker container with NLM Scrubber already configured.
2. A `scrub.sh` script to make using the docker container easier.
3. A python library for dynamic deidentification.


## Docker

The docker image can be downloaded from [docker hub](https://hub.docker.com/r/radaisystems/nlm-scrubber) or built via `make build`.

Once run the container will deidentify anything in `/tmp/once_off/input` and output it to `/tmp/once_off/output` (these directories are *inside* the container). The input files can be limited by defining the `SCRUBBER_REGEX` environmental variables.

Mounting a local volume to `/tmp/once_off/input` and another to `/tmp/once_off/output` will allow you to deidentify and save items on your host machine.


## scrub.sh

This script wraps around the docker container, automatically mounting the supplied directories into the container so their contents can be deidentified.

To deidentify any json files from `testing/input` into the directory `testing/output` you'd run this command-

```
./scrub.sh testing/input/ testing/output/ .\*.json
```

Note that the NLM Scrubber does leave metadata at the bottom of each file- this would have to be removed before parsing the json.


## pyscrubber

This library does not use the docker container and depends on the nlm-scrubber being installed in `/opt/nlm_scrubber`.

To work with the `nlm_scrubber` application this library dynamically generates a config, writes all of the supplied strings to disk, and then reads the outputted data back before erasing all of the files it wrote.

There is a significant delay when the application is being loaded- as such it is far more efficient to batch data than to run it through individually.
