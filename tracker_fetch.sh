#bin/sh
PULL_DETAILS="`~/scripts/moodle-scripts/branch_details.sh $1 $2`"
git fetch $PULL_DETAILS
