#/bin/bash
# This script is used only to output the 'pull repository' and 'branch name'for a given
# tracker issue, as specified by $1 - the MDL-number.
# For issues with backport branches, the correct branch name can be fetched either by
# providing the preferred branch in $2 (e.g. master, 31 or 32) or if omitted, the script
# will attempt to infer the correct branch based on your currently checked out git branch.

# Branch can be specified
BRANCH_PREFERENCE="${2:-}"

# If not specified, try to infer the current branch based on 'git current-branch' output.
if [ -z "$BRANCH_PREFERENCE" ]; then
	CURRENT_BRANCH="`git current-branch`"
	IFS=_ read var1 var2 var3 <<< "$CURRENT_BRANCH"
	if [[ $var2 =~ ^-?[0-9]+$ ]] && [[ $var2 -lt 1000 ]]; then
		BRANCH_PREFERENCE="$var2"
	else
		BRANCH_PREFERENCE="master"
	fi
fi

# Fetch from tracker
PARSED_CONTENTS="`wget -qO- https://tracker.moodle.org/browse/MDL-$1 2>/dev/null`"

# Make the right choice about the branch to check.
if [ $BRANCH_PREFERENCE == "400" ]; then
    XPATH="//*[@id=\"customfield_15910-val\"]"
elif [ $BRANCH_PREFERENCE == "311" ]; then
    XPATH="//*[@id=\"customfield_15610-val\"]"
elif [ $BRANCH_PREFERENCE == "310" ]; then
    XPATH="//*[@id=\"customfield_15428-val\"]"
elif [ $BRANCH_PREFERENCE == "39" ]; then
    XPATH="//*[@id=\"customfield_15421-val\"]"
elif [ $BRANCH_PREFERENCE == "38" ]; then
    XPATH="//*[@id=\"customfield_14910-val\"]"
elif [ $BRANCH_PREFERENCE == "37" ]; then
    XPATH="//*[@id=\"customfield_14810-val\"]"
elif [ $BRANCH_PREFERENCE == "36" ]; then
    XPATH="//*[@id=\"customfield_14610-val\"]"
elif [ $BRANCH_PREFERENCE == "35" ]; then
	XPATH="//*[@id=\"customfield_14311-val\"]"
elif [ $BRANCH_PREFERENCE == "34" ]; then
	XPATH="//*[@id=\"customfield_14212-val\"]"
elif [ $BRANCH_PREFERENCE == "33" ]; then
	XPATH="//*[@id=\"customfield_14210-val\"]"
elif [ $BRANCH_PREFERENCE == "32" ]; then
	XPATH="//*[@id=\"customfield_13911-val\"]"
elif [ $BRANCH_PREFERENCE == "31" ]; then
	XPATH="//*[@id=\"customfield_13113-val\"]"
elif [ $BRANCH_PREFERENCE == "27" ]; then
	XPATH="//*[@id=\"customfield_11710-val\"]"
else
	# Master branch xpath
	XPATH="//*[@id=\"customfield_10111-val\"]"
fi

PULL_REPO="`echo $PARSED_CONTENTS | xmllint --html --xpath '//*[@id="customfield_10100-val"]/a' - 2>/dev/null | sed -e 's/<[^>]*>//g'`"
PULL_BRANCH="`echo $PARSED_CONTENTS | xmllint --html --xpath ''"$XPATH"'' - 2>/dev/null | sed -n '/^$/!{s/<[^>]*>//g;p;}'`"
echo $PULL_REPO $PULL_BRANCH

