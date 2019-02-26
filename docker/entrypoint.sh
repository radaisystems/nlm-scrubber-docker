#!/usr/bin/env bash

if [ -z ${SCRUBBER_REGEX+x} ]; then
  SCRUBBER_REGEX='.*'
fi

echo "ROOT1 = /tmp/once_off" >> /tmp/once_off/config
echo "ClinicalReports_dir = ROOT1/input" >> /tmp/once_off/config
echo "ClinicalReports_files = ${SCRUBBER_REGEX}" >> /tmp/once_off/config
echo "nPHI_outdir = ROOT1/output" >> /tmp/once_off/config

/opt/nlm_scrubber /tmp/once_off/config
