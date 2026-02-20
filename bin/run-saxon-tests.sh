#!/bin/bash

# This script runs the xquerydoc testsuite for the Saxon  processor
# using an XProc pipeline (src/tests/marklogic-test.xpl), which is a generic
# testrunner.
#
# MarkLogic unit tests are located under src/tests/unit/saxon
#
# to add new tests review existing tests there and add an entry here to run them.
#
# the following describes the input/output and options passed in through XProc
#
# -isource: XProc input takes in MarkLogic configuration file (src/tests/config.xml)
# -oresult: XProc output writes result of tests to src/tests/results/marklogic
#
#     test: option contains the unit test path (unit tests are written in xquery)
#  example: option contains the path to the example xquery document to apply unit test too
# expected: option contains the path to the expected result for the test
#

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
XQUERYDOC_DIR="$( cd -P "$( dirname "$SOURCE" )/.." && pwd )"

# Generate a temporary config with the correct project root path
TMPCONFIG=$(mktemp /tmp/xquerydoc-config.XXXXXX.xml)
sed "s|<path>.*</path>|<path>${XQUERYDOC_DIR}</path>|" "${XQUERYDOC_DIR}/src/tests/config.xml" > "$TMPCONFIG"

# Extract the Calabash jar from the Homebrew wrapper and call java directly with
# a larger thread stack (-Xss16m) to handle the deeper recursion in XQuery31.xq.
CALABASH_JAR=$(grep -oE '"[^"]*\.jar"' /usr/local/bin/calabash | tr -d '"')
JAVA_HOME_CALABASH="${JAVA_HOME:-/usr/local/opt/openjdk/libexec/openjdk.jdk/Contents/Home}"
run_calabash() {
  "${JAVA_HOME_CALABASH}/bin/java" -Xss16m -Xmx1024m -jar "$CALABASH_JAR" "$@"
}

cd "${XQUERYDOC_DIR}/src/tests"
mkdir -p result/Saxon

run_calabash -isource="$TMPCONFIG" -oresult=result/Saxon/default.xml saxon-test.xpl example=/src/tests/examples/?select=default.xqy expected=/src/tests/expected/saxon/default.xml

run_calabash -isource="$TMPCONFIG" -oresult=result/Saxon/get-code.xml saxon-test.xpl example=/src/tests/examples/?select=get-code.xqy expected=/src/tests/expected/saxon/get-code.xml

run_calabash -isource="$TMPCONFIG" -oresult=result/Saxon/sample.xml saxon-test.xpl example=/src/tests/examples/?select=sample.xqy expected=/src/tests/expected/saxon/sample.xml

run_calabash -isource="$TMPCONFIG" -oresult=result/Saxon/xquery31.xml saxon-test.xpl example=/src/tests/examples/?select=xquery31.xqy expected=/src/tests/expected/saxon/xquery31.xml

run_calabash -isource="$TMPCONFIG" -oresult=result/saxon-report.html report.xpl processor=Saxon

rm -f "$TMPCONFIG"
