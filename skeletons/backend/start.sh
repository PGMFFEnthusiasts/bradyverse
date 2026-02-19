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

# shoutout https://exa.y2k.diy/garden/jvm-args/ and mbt for linking me ts
java -Xms${BRADY_INIT_HEAP_SPACE} -Xmx${BRADY_INIT_HEAP_SPACE} ${BRADY_ENABLE_NMT_FLAG} \
  -XX:+UseZGC -XX:+UseCompactObjectHeaders \
  -XX:+DisableExplicitGC \
  -Dfile.encoding=UTF-8 \
  --add-opens java.base/sun.nio.ch=ALL-UNNAMED --add-opens java.base/java.io=ALL-UNNAMED \
  --add-opens=java.base/java.lang.invoke=ALL-UNNAMED --enable-native-access=ALL-UNNAMED \
  -jar sportpaper-1.8.8.jar nogui
