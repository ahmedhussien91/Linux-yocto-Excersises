#!/bin/sh
export VSOMEIP_APPLICATION_NAME=World
export VSOMEIP_CONFIGURATION=vsomeip.json
./server-app & 
./client-app
