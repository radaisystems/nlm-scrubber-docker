FROM python:3.6

RUN mkdir -p /tmp/once_off/input
RUN mkdir -p /tmp/once_off/output

COPY build/nlm_scrubber /opt/nlm_scrubber
RUN chmod +x /opt/nlm_scrubber

COPY pyscrubber.py /opt/pyscrubber.py
RUN chmod +x /opt/pyscrubber.py

COPY docker/entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
