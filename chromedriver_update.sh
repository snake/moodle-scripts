#!/bin/sh

LATEST_VERSION_CHROMEDRIVER=$(curl https://chromedriver.storage.googleapis.com/LATEST_RELEASE)

# Now, dl the update to /tmp
FETCH="curl -o /tmp/chromedriver_latest.zip https://chromedriver.storage.googleapis.com/$LATEST_VERSION_CHROMEDRIVER/chromedriver_linux64.zip"
echo "Running: $FETCH"
eval $FETCH

# Unzip and replace usr/bin/chromedriver
UNZIP="unzip -o /tmp/chromedriver_latest.zip -d /tmp/"
eval $UNZIP

# Finally, backup the old driver (use _old) and apply the new one
$(mv /home/jake/chromedriver /home/jake/chromedriver_backup)
$(cp /tmp/chromedriver /home/jake/chromedriver)

