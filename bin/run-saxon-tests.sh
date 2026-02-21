#!/bin/bash

# This script runs the xquerydoc testsuite for the Saxon processor.
# It auto-detects Saxon (via Maven) and falls back to system Calabash.
#
# Saxon mode (CI): run-test.xq is invoked directly with net.sf.saxon.Query
# Calabash mode:   saxon-test.xpl XProc pipeline is used
#
# to add new tests, add an entry to the test list and a run_test call below.

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
XQUERYDOC_DIR="$( cd -P "$( dirname "$SOURCE" )/.." && pwd )"

cd "${XQUERYDOC_DIR}/src/tests"
mkdir -p result/Saxon

# Auto-detect: prefer Saxon from Maven; fall back to system Calabash
SAXON_JAR=$(ls "${XQUERYDOC_DIR}/target/dependency/Saxon-HE-"*.jar 2>/dev/null | head -1)

if [ -n "$SAXON_JAR" ]; then
  run_test() {   # $1=example  $2=expected  $3=outfile
    java -Xss16m -cp "${XQUERYDOC_DIR}/target/dependency/*" \
      net.sf.saxon.Query \
      -q:"${XQUERYDOC_DIR}/src/tests/run-test.xq" \
      "distpath=${XQUERYDOC_DIR}" \
      "expected=$2" "example=$1" \
      > "$3"
  }
else
  # Local dev: system Calabash
  TMPCONFIG=$(mktemp /tmp/xquerydoc-config.XXXXXX.xml)
  sed "s|<path>.*</path>|<path>${XQUERYDOC_DIR}</path>|" \
    "${XQUERYDOC_DIR}/src/tests/config.xml" > "$TMPCONFIG"
  trap 'rm -f "$TMPCONFIG"' EXIT

  CALABASH_JAR=$(grep -oE '"[^"]*\.jar"' "$(command -v calabash)" | tr -d '"')
  JAVA_HOME_CAL="${JAVA_HOME:-/usr/local/opt/openjdk/libexec/openjdk.jdk/Contents/Home}"
  run_test() {   # $1=example  $2=expected  $3=outfile
    "${JAVA_HOME_CAL}/bin/java" -Xss16m -Xmx1024m -jar "$CALABASH_JAR" \
      -isource="$TMPCONFIG" -oresult="$3" \
      "${XQUERYDOC_DIR}/src/tests/saxon-test.xpl" \
      "example=$1" "expected=$2"
  }
fi

run_test /src/tests/examples/?select=default.xqy  /src/tests/expected/saxon/default.xml  result/Saxon/default.xml
run_test /src/tests/examples/?select=get-code.xqy /src/tests/expected/saxon/get-code.xml result/Saxon/get-code.xml
run_test /src/tests/examples/?select=sample.xqy   /src/tests/expected/saxon/sample.xml   result/Saxon/sample.xml
run_test /src/tests/examples/?select=xquery31.xqy /src/tests/expected/saxon/xquery31.xml result/Saxon/xquery31.xml

# Print a pass/fail summary by comparing <expected> vs <actual> in each result file.
python3 - "${XQUERYDOC_DIR}/src/tests/result/Saxon" <<'PYEOF'
import sys, os, io
import xml.etree.ElementTree as ET

result_dir = sys.argv[1]
tests = [
    ("default",  "default.xml"),
    ("get-code",  "get-code.xml"),
    ("sample",    "sample.xml"),
    ("xquery31",  "xquery31.xml"),
]

def canon(el):
    out = io.StringIO()
    ET.canonicalize(ET.tostring(el), out=out, strip_text=True)
    return out.getvalue()

failures = 0
print()
print("Saxon test results:")
for name, fname in tests:
    path = os.path.join(result_dir, fname)
    try:
        root = ET.parse(path).getroot()
        for test in root.findall("test"):
            exp = list(test.find("expected"))
            act = list(test.find("actual"))
            if exp and act and canon(exp[0]) == canon(act[0]):
                print(f"  PASS  {name}")
            else:
                print(f"  FAIL  {name}")
                failures += 1
    except Exception as e:
        print(f"  ERROR {name}: {e}")
        failures += 1

print()
if failures == 0:
    print("All tests passed.")
else:
    print(f"{failures} test(s) FAILED.")
sys.exit(failures)
PYEOF
