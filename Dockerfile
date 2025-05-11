FROM debian:stable-slim

# Disable prompts on apt-get install
ENV DEBIAN_FRONTEND noninteractive

# Install latest stable LibreOffice
RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends libreoffice \
    && apt-get clean \
    && useradd --create-home --shell /bin/bash converter \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archives/*.deb /var/cache/apt/*cache.bin

USER converter
WORKDIR /home/converter

# Write stdin to 'input_file'
CMD cat - > input_file \
    # Convert 'input_file' to pdf
    && libreoffice --invisible --headless --nologo --convert-to pdf --outdir $(pwd) input_file \
    # Send converted file to stdout
    && cat input_file.pdf
