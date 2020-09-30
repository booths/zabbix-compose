#!/bin/bash
ss -an | grep -i est |awk  '{print $4}' | grep ":$1\b" | wc -l