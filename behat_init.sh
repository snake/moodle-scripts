#!/bin/bash
# Simple behat browser runner.
# This runs selenium with the relevant browser and framebuffering options, or phantom js.

BROWSER="${1:-chrome}"
XVFB="${2:-1}"

# Keep track of the config, only for user display purposes.
cfg=''

# Location of the selenium jar file.
SELENIUM_JAR="/opt/selenium-server-standalone-2.53.0.jar"
PHANTOMJS_BIN="/opt/phantomjs"

# Base run command. We'll modify this based on $ args.
CMD="java -jar $SELENIUM_JAR"

if [ "$BROWSER" = 'firefox' ]; then
	cfg=$cfg"Browser: Firefox\n"
	CMD="$CMD -Dwebdriver.firefox.bin=\"/opt/Firefox-46.0.1/firefox-sdk/bin/firefox\""
elif [ "$BROWSER" = 'phantomjs' ]; then
	cfg=$cfg"Browser: PhantomJS\n"
	CMD="$PHANTOMJS_BIN --webdriver=4444"
else
	cfg=$cfg"Browser: Chrome\n"
fi

if [ "$BROWSER" = "chrome" -o "$BROWSER" = "firefox" ]; then
	if [ "$XVFB" = "1" ]; then
		# Buffering enabled, so prepend the relevant xvfb-run statement to the run command.
		cfg=$cfg"Frame buffering: On\n"
		CMD="xvfb-run $CMD"
	else 
		cfg=$cfg"Frame buffering: Off\n"
	fi
fi
cfg=$cfg"Command: $CMD\n"
echo -e "---------------------\nRun config:\n$cfg---------------------\n"
pkill -f xvfb-run
pkill -f $SELENIUM_JAR
eval "$CMD"
