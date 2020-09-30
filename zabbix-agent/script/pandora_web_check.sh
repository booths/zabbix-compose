#!/bin/bash
curl -s http://${1}:19999/athenaApp/manager/version |grep athenaApp | wc -l