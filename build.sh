#!/usr/bin/env bash

DIR=$(readlink -f "$(dirname "$0")")
readonly DIR
cd "$DIR" || exit 1

# deps: aria2c, sha256sum, docker (& buildx), git, curl

echo "🌌 Welcome to the Bradyverse"
TIME_START=$(date +%s)

function download_by_manifest() {
  GROUP=$1

  curl -Lso "downloads/$GROUP/aria2-manifest.txt" "https://tombrady.fireballs.me/cdn/$GROUP/aria2-manifest.txt"

  CURRENT_HASH=$(sha256sum "downloads/$GROUP/aria2-manifest.txt" | cut -d' ' -f1)
  OLD_HASH=$(cat "downloads/$GROUP/.downloaded" 2>/dev/null)

  if [ "$OLD_HASH" != "$CURRENT_HASH" ]; then
    echo "🚧 Cache invalid, fully redownloading $GROUP..."
    rm -r "downloads/$GROUP/out" 2>/dev/null
  fi

  echo "$CURRENT_HASH" > "downloads/$GROUP/.downloaded"
  mkdir -p "downloads/$GROUP/out"
  aria2c -V -q -j 4 -x 4 -i "downloads/$GROUP/aria2-manifest.txt" -d "downloads/$GROUP/out"
  echo "✅ Downloaded $GROUP"
}

echo "🐢 Downloading dependencies"

download_by_manifest "plugins"
download_by_manifest "deps"

if [ ! -d "./downloads/maps/out/tom-brady/" ]; then
  echo "🗺️ Pre-cloning maps"
  mkdir -p downloads/maps/out
  git clone --depth=1 https://github.com/PGMFFEnthusiasts/maps.git downloads/maps/out/tom-brady
else
  echo "🔄 Updating pre-cloned maps"
  git -C downloads/maps/out/tom-brady pull
fi

echo "🛠️ Building backend"

rm -rf out/ 2>/dev/null
mkdir out

# build backend
cp -r skeletons/backend/ out/
cp -rT downloads/plugins/out/ out/backend/plugins/
cp -rT downloads/deps/out/ out/backend/plugins/
cp -rT skeletons/private/ out/backend/ 2>/dev/null
mv out/backend/plugins/sportpaper-1.8.8.jar out/backend/
cp -rT downloads/maps/out/ out/backend/

if [[ "$STANDALONE" == "1" || "$STANDALONE" == "true" ]]; then
  echo "⚙️ Adding standalone options"
  sed -i '.bak' 's/online-mode=false/online-mode=true/g' out/backend/server.properties
  sed -i '.bak' 's/bungeecord: true/bungeecord: false/g' out/backend/sportpaper.yml
fi

docker buildx build out/backend -f out/backend/Containerfile -t bradyverse-backend:latest --platform linux/amd64 --load

TIME_END=$(date +%s)
echo "🏁 Finished building in $((TIME_END - TIME_START))s"
