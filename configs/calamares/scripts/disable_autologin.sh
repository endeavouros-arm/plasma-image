#!/bin/bash
cp -f /usr/lib/systemd/system/getty@.service.bak /usr/lib/systemd/system/getty@.service
rm -rf /usr/lib/systemd/system/getty@.service.bak
