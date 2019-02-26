#!/usr/bin/env python
import uuid
import os
import subprocess
import shutil


DOC_DELIMITER = '\n##### DOCUMENT #############################################################'


class Scrubber():
    def __init__(self, working_directory='/tmp/nlm_scrubber'):
        self.working_directory = working_directory


    def _setup(self, base_path):
        if not os.path.exists(base_path):
            os.makedirs(base_path)

        input_path = '%s/input' % (base_path)
        if not os.path.exists(input_path):
            os.makedirs(input_path)

        output_path = '%s/output' % (base_path)
        if not os.path.exists(output_path):
            os.makedirs(output_path)


    def scrub(self, inputs):

        my_uuid = str(uuid.uuid4())
        base_path = '%s/%s' % (self.working_directory, my_uuid)
        self._setup(base_path)

        self.config_file = '%s/config' % (base_path)
        with open(self.config_file, 'w') as file:
            file.write('ROOT1 = %s\n' % (base_path))
            file.write('ClinicalReports_dir = ROOT1/input\n')
            file.write('ClinicalReports_files = .*\\.txt\n')
            file.write('nPHI_outdir = ROOT1/output\n')

        for index, input in enumerate(inputs):
            # Write string to disk
            with open('%s/input/data_%s.txt' % (base_path, index), 'w') as file:
                file.write(input)

        # Run scrubber with config
        result = subprocess.run(['/opt/nlm_scrubber', self.config_file], stdout=subprocess.PIPE)

        outputs = []
        for index, input in enumerate(inputs):
            # Retrieve results
            with open('%s/output/data_%s.nphi.txt' % (base_path, index)) as file:
                output = file.read()
                if DOC_DELIMITER in output:
                    output = output[:output.find(DOC_DELIMITER)]
            outputs.append(output)

        # Cleanup
        shutil.rmtree(base_path)

        return outputs


if __name__ == "__main__":
    scrubber = Scrubber()
    print(scrubber.scrub(['testing', 'My name is Robert Hafner.', 'This string is also a test. 1/19/1998']))
