#!/bin/bash

DIR=$(readlink -f "$(dirname "$0")")
readonly DIR
cd "$DIR" || exit 1

if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

BRADY_INIT_HEAP_SPACE=${BRADY_INIT_HEAP_SPACE:-1536M}
if [[ "$BRADY_ENABLE_NMT" == "true" ]]; then
    BRADY_ENABLE_NMT_FLAG="-XX:NativeMemoryTracking=summary"
else
    BRADY_ENABLE_NMT_FLAG=""
fi

java -Xms${BRADY_INIT_HEAP_SPACE} -Xmx${BRADY_INIT_HEAP_SPACE} ${BRADY_ENABLE_NMT_FLAG} \
 -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem \
 -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1HeapRegionSize=8M -XX:G1HeapWastePercent=5 -XX:G1MaxNewSizePercent=40 \
 -XX:G1MixedGCCountTarget=4 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1NewSizePercent=30 -XX:G1RSetUpdatingPauseTimePercent=5 \
 -XX:G1ReservePercent=20 -XX:InitiatingHeapOccupancyPercent=15 -XX:MaxGCPauseMillis=200 -XX:MaxTenuringThreshold=1 \
 -XX:SurvivorRatio=32 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -Dfile.encoding=UTF-8 \
 --add-opens java.base/sun.nio.ch=ALL-UNNAMED --add-opens java.base/java.io=ALL-UNNAMED \
 --add-opens=java.base/java.lang.invoke=ALL-UNNAMED --enable-native-access=ALL-UNNAMED -jar sportpaper-1.8.8.jar nogui
