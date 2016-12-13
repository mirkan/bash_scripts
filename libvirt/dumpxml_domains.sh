#!/bin/env bash
## Description:
# Dumps all domains to $DomainName.xml
## Author: Robin Björnsvik

VIRSH_URI="qemu+ssh://admin@gen8/system"
OUTPUT_DIR="$1"

# List all domains
function list_domains () {
    virsh -c "$VIRSH_URI" list --all --name
}

# Dump domain xml-file to $DIR
function dump_domain () {
    virsh -c "$VIRSH_URI" dumpxml "$1" > "$OUTPUT_DIR/$1.xml"
}

domains=$(list_domains)
for domain in $domains; do
    dump_domain $domain
done;
