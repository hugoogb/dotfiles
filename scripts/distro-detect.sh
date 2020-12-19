#!/bin/bash

# Detect distro
DISTRO=`cat /etc/*-release | head -1 | tail -1 | cut -d= -f2 | tr -d '"'`
UBUNTU="Ubuntu"
ARCH_LINUX="Arch Linux"
