#!/bin/bash
URL=$(curl -s https://api.github.com/repos/drwhut/tabletop-club/releases/latest | jq '.assets[] | select(.name|endswith("_Linux_64.zip")) | .browser_download_url' | tr -d '"')
VERSION=$(echo $URL|cut -d'/' -f8|tr -d 'v')
LOCAL_VERSION=$(cat snapcraft.yaml|grep "version: "|cut -d" " -f2)
if [[ "$VERSION" != "$LOCAL_VERSION" ]]; then
   echo "local and remove versions differ"
   echo "old version: $LOCAL_VERSION"
   echo "new version: $VERSION"
   sed -i "/^\([[:space:]]*version: \).*/s//\1$VERSION/" snapcraft.yaml
   git commit -a -m 'version update: $VERSION'
   git push
   snapcraft upload --release=stable tabletop-club-unofficial_${VERSION}_amd64.snap
else
   echo "no update available. current version is $VERSION"
fi
