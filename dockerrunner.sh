#!/bin/bash
# Read in instance name
# create path /var/www/html/INSTANCENAME
# Pre-flight check - check for config-dist or something in the dir.
# copy in the docker config file.
# Now, set env vars and run the moodle docker.

MOODLEDOCKERPATH="/home/jake/scripts/moodle-docker"
MOODLEDOCKERCONFIGNAME="config.docker-template.php"
INSTANCENAME="${1:-msmaster}"
INSTANCEDB="${2:-mssql}"
INSTANCEVOLUME="${3:-}"
INSTANCEPATH="/var/www/html/$INSTANCENAME"

# Sanity checks.
if [ ! -f "$INSTANCEPATH/config-dist.php" ]
then
    echo "Instance '$INSTANCEPATH' could not be found. No config-dist.php found there."
    exit 1
fi
if [ ! -f "$MOODLEDOCKERPATH/$MOODLEDOCKERCONFIGNAME" ]
then
    echo "Moodle docker directory '$MOODLEDOCKERPATH' could not be found. No $MOODLEDOCKERCONFIGNAME found there."
    exit 1
fi

# Volume setup.
if [ -n "$INSTANCEVOLUME" ]; then
    INSTANCEVOLUME="volumes:
- $INSTANCEVOLUME:$INSTANCEVOLUME"
fi
echo "Have volume: $INSTANCEVOLUME"

# Paths are valid, so copy the config.php into the dir.
cp "$MOODLEDOCKERPATH/$MOODLEDOCKERCONFIGNAME" "$INSTANCEPATH/config.php"

# Set up env vars.
export MOODLE_DOCKER_WWWROOT="$INSTANCEPATH"
export MOODLE_DOCKER_DB="$INSTANCEDB"
export INSTANCEVOLUME="$INSTANCEVOLUME"

# Run the docker.
eval "$MOODLEDOCKERPATH/bin/moodle-docker-compose up -d"

echo "Site up at http://localhost:8000"
