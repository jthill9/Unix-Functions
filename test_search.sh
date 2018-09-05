#!/bin/bash

PROGRAM=search
WORKSPACE=/tmp/$PROGRAM.$(id -u)
FAILURES=0

# Functions

error() {
    echo "$@"
    [ -r $WORKSPACE/test ] && (echo; cat $WORKSPACE/test; echo)
    FAILURES=$((FAILURES + 1))
}

cleanup() {
    STATUS=${1:-$FAILURES}
    rm -fr $WORKSPACE
    exit $STATUS
}

# Setup

mkdir $WORKSPACE

trap "cleanup" EXIT
trap "cleanup 1" INT TERM

# Testing

echo "Testing $PROGRAM..."

printf " %-72s ... " "usage"
if ! ./$PROGRAM -help |& grep -q -i usage; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "usage (valgrind)"
valgrind --leak-check=full ./$PROGRAM -help &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "no arguments"
./$PROGRAM | sort | diff -y - <(find | sort 2> /dev/null) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "no arguments (valgrind)"
valgrind --leak-check=full ./$PROGRAM &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc"
./$PROGRAM /etc 2> /dev/null | sort | diff -y - <(find /etc 2> /dev/null | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc (valgrind)"
valgrind --leak-check=full ./$PROGRAM /etc &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -executable"
./$PROGRAM /etc -executable 2> /dev/null | sort | diff -y - <(find /etc -executable 2> /dev/null | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -executable (valgrind)"
valgrind --leak-check=full ./$PROGRAM /etc -executable &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -readable"
./$PROGRAM /etc -readable 2> /dev/null | sort | diff -y - <(find /etc -readable 2> /dev/null | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -readable (valgrind)"
valgrind --leak-check=full ./$PROGRAM /etc -readable &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -writable"
./$PROGRAM /etc -writable 2> /dev/null | sort | diff -y - <(find /etc -writable 2> /dev/null | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -writable (valgrind)"
valgrind --leak-check=full ./$PROGRAM /etc -writable &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -type f"
./$PROGRAM /etc -type f 2> /dev/null | sort | diff -y - <(find /etc -type f 2> /dev/null | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -type f (valgrind)"
valgrind --leak-check=full ./$PROGRAM /etc -type f &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -type d"
./$PROGRAM /etc -type d 2> /dev/null | sort | diff -y - <(find /etc -type d 2> /dev/null | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -type d (valgrind)"
valgrind --leak-check=full ./$PROGRAM /etc -type d &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -name '*.conf'"
./$PROGRAM /etc -name '*.conf' 2> /dev/null | sort | diff -y - <(find /etc -name '*.conf' 2> /dev/null | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -name '*.conf' (valgrind)"
valgrind --leak-check=full ./$PROGRAM /etc -name '*.conf' &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -path '*security/*.conf'"
./$PROGRAM /etc -path '*security/*.conf' 2> /dev/null | sort | diff -y - <(find /etc -path '*security/*.conf' 2> /dev/null | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -path '*security/*.conf' (valgrind)"
valgrind --leak-check=full ./$PROGRAM /etc -path '*security/*.conf' &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -perm 600"
./$PROGRAM /etc -perm 600 2> /dev/null | sort | diff -y - <(find /etc -perm 600 2> /dev/null | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -perm 600 (valgrind)"
valgrind --leak-check=full ./$PROGRAM /etc -perm 600 &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -newer /etc/hosts"
./$PROGRAM /etc -newer /etc/hosts 2> /dev/null | sort | diff -y - <(find /etc -newer /etc/hosts 2> /dev/null | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -newer /etc/hosts (valgrind)"
valgrind --leak-check=full ./$PROGRAM /etc -newer /etc/hosts &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -uid 0"
./$PROGRAM /etc -uid 0 2> /dev/null | sort | diff -y - <(find /etc -uid 0 2> /dev/null | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -uid 0 (valgrind)"
valgrind --leak-check=full ./$PROGRAM /etc -uid 0 &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -gid 0"
./$PROGRAM /etc -gid 0 2> /dev/null | sort | diff -y - <(find /etc -gid 0 2> /dev/null | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -gid 0 (valgrind)"
valgrind --leak-check=full ./$PROGRAM /etc -gid 0 &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -empty"
./$PROGRAM /etc -empty 2> /dev/null | sort | diff -y - <(find /etc -empty 2> /dev/null | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -empty (valgrind)"
valgrind --leak-check=full ./$PROGRAM /etc -empty &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -type f -executable"
./$PROGRAM /etc -type f -executable 2> /dev/null | sort | diff -y - <(find /etc -type f -executable 2> /dev/null | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -type f -executable (valgrind)"
valgrind --leak-check=full ./$PROGRAM /etc -type f -executable &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -type d -readable"
./$PROGRAM /etc -type d -readable 2> /dev/null | sort | diff -y - <(find /etc -type d -readable 2> /dev/null | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -type d -readable (valgrind)"
valgrind --leak-check=full ./$PROGRAM /etc -type d -readable &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -type d -name '*conf*'"
./$PROGRAM /etc -type d -name '*conf*' 2> /dev/null | sort | diff -y - <(find /etc -type d -name '*conf*' 2> /dev/null | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -type d -name '*conf*' (valgrind)"
valgrind --leak-check=full ./$PROGRAM /etc -type d -name '*conf*' &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -type f -executable -readable"
./$PROGRAM /etc -type f -executable -readable 2> /dev/null | sort | diff -y - <(find /etc -type f -executable -readable 2> /dev/null | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -type f -executable -readable (valgrind)"
valgrind --leak-check=full ./$PROGRAM /etc -type f -executable -readable &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -perm 755 -uid 0"
./$PROGRAM /etc -perm 755 -uid 0 2> /dev/null | sort | diff -y - <(find /etc -perm 755 -uid 0 2> /dev/null | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "/etc -perm 755 -uid 0 (valgrind)"
valgrind --leak-check=full ./$PROGRAM /etc -perm 755 -uid 0 &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

TESTS=$(($(grep -c Success $0) - 1))
echo "   Score $(echo "scale=2; ($TESTS - $FAILURES) / $TESTS.0 * 9.00" | bc | awk '{printf "%0.2f\n", $0}')"
echo
