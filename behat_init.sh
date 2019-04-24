#!/bin/bash
# Simple behat browser runner.
# This runs selenium with the relevant browser and framebuffering options (ff and chrome only)
# or against the phantom js.
#
# Examples:
#
# behat_init 				<--(defaults to chrome and frame buffering on)
# behat_init chrome 0 		<--(chrome with frame buffering off)
# behat_init firefox 		<--(firefox with frame buffering on)
# behat_init phantomjs 		<--(phantomjs, frame buffering not applicable)

BROWSER="${1:-chrome}"
XVFB="${2:-1}"

# Keep track of the config, only for user display purposes.
cfg=""

# Locations of some bits we need.
SELENIUM_JAR="/opt/selenium-server-standalone-3.141.59.jar"
PHANTOMJS_BIN="/opt/phantomjs"
FIREFOX_BIN="/opt/Firefox-47.0.1/firefox-bin"
CHROMEDRIVER_BIN="/usr/bin/chromedriver"
# Note: Chromedriver expects /usr/bin/google-chrome as chrome location or symlink.

# Base run command, modified by args.
CMDPRE="java"
CMDPOST="-jar $SELENIUM_JAR"

# Determine driver.
if [ "$BROWSER" = 'firefox' ]; then
	cfg=$cfg"Browser: Firefox\n"
	CMD="$CMDPRE -Dwebdriver.firefox.bin=\"$FIREFOX_BIN\" $CMDPOST"
elif [ "$BROWSER" = 'phantomjs' ]; then
	cfg=$cfg"Browser: PhantomJS\n"
	CMD="$PHANTOMJS_BIN --webdriver=4444"
else
	cfg=$cfg"Browser: Chrome\n"
    CMD="$CMDPRE -Dwebdriver.chrome.driver=\"$CHROMEDRIVER_BIN\" $CMDPOST"
fi

# Determine frame buffering.
if [ "$BROWSER" = "chrome" -o "$BROWSER" = "firefox" ]; then
	if [ "$XVFB" = "1" ]; then
		# Buffering enabled, so prepend the relevant xvfb-run statement to the run command.
		cfg=$cfg"Frame buffering: On\n"
		CMD="xvfb-run $CMD"
	else 
		cfg=$cfg"Frame buffering: Off\n"
	fi
fi

# Output run config, kill any running servers, and run current config.
cfg=$cfg"Command: $CMD\n"
echo -e "---------------------\nRun config:\n$cfg---------------------\n"
pkill -f xvfb-run
pkill -f $SELENIUM_JAR
eval "$CMD"
