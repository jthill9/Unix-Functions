#!/bin/bash

PROGRAM=duplicate
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

echo "Testing duplicate..."

printf " %-72s ... " "usage"
if ! ./$PROGRAM -h |& grep -q -i usage; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "usage (valgrind)"
valgrind --leak-check=full ./$PROGRAM -h &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "no arguments"
cat /etc/passwd | ./$PROGRAM | diff -y - <(cat /etc/passwd | dd 2> /dev/null) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "no arguments (valgrind)"
cat /etc/passwd | valgrind --leak-check=full ./$PROGRAM &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=/etc/passwd"
./$PROGRAM if=/etc/passwd | diff -y - <(dd if=/etc/passwd 2> /dev/null) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=/etc/passwd (valgrind)"
valgrind --leak-check=full ./$PROGRAM if=/etc/passwd &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=asdfsadf"
if ! ./$PROGRAM if=asdfasdf |& grep -q -i "no such file"; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=asdfasdf (valgrind)"
valgrind --leak-check=full ./$PROGRAM if=asdfasdf &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=/etc/passwd of=$WORKSPACE/of"
./$PROGRAM if=/etc/passwd of=$WORKSPACE/of.0 
dd if=/etc/passwd of=$WORKSPACE/of.1 2> /dev/null
diff -y $WORKSPACE/of.0 $WORKSPACE/of.1 > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=/etc/passwd of=$WORKSPACE/of (valgrind)"
valgrind --leak-check=full ./$PROGRAM if=/etc/passwd of=$WORKSPACE/of.0 &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=/etc/passwd bs=2"
./$PROGRAM if=/etc/passwd bs=2 |& diff -y - <(dd if=/etc/passwd bs=2 2> /dev/null) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=/etc/passwd bs=2 (valgrind)"
valgrind --leak-check=full ./$PROGRAM if=/etc/passwd bs=2 &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=/etc/passwd bs=10240"
./$PROGRAM if=/etc/passwd bs=10240 |& diff -y - <(dd if=/etc/passwd bs=10240 2> /dev/null) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=/etc/passwd bs=10240 (valgrind)"
valgrind --leak-check=full ./$PROGRAM if=/etc/passwd bs=10240 &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=/etc/passwd bs=2 count=5"
./$PROGRAM if=/etc/passwd bs=2 count=5 |& diff -y - <(dd if=/etc/passwd bs=2 count=5 2> /dev/null) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=/etc/passwd bs=5 count=5 (valgrind)"
valgrind --leak-check=full ./$PROGRAM if=/etc/passwd bs=5 count=5 &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=/etc/passwd bs=2 count=5 skip=1"
./$PROGRAM if=/etc/passwd bs=2 count=5 skip=1 |& diff -y - <(dd if=/etc/passwd bs=2 count=5 skip=1 2> /dev/null) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=/etc/passwd bs=5 count=5 skip=1 (valgrind)"
valgrind --leak-check=full ./$PROGRAM if=/etc/passwd bs=5 count=5 skip=1 &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=/etc/passwd bs=2 count=5 skip=10"
./$PROGRAM if=/etc/passwd bs=2 count=5 skip=10 |& diff -y - <(dd if=/etc/passwd bs=2 count=5 skip=10 2> /dev/null) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=/etc/passwd bs=5 count=5 skip=10 (valgrind)"
valgrind --leak-check=full ./$PROGRAM if=/etc/passwd bs=5 count=5 skip=10 &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=/etc/passwd bs=2 count=5 skip=100"
./$PROGRAM if=/etc/passwd bs=2 count=5 skip=100 |& diff -y - <(dd if=/etc/passwd bs=2 count=5 skip=100 2> /dev/null) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=/etc/passwd bs=5 count=5 skip=100 (valgrind)"
valgrind --leak-check=full ./$PROGRAM if=/etc/passwd bs=5 count=5 skip=100 &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=/etc/passwd of=$WORKSPACE/of bs=2 seek=1"
./$PROGRAM if=/etc/passwd of=$WORKSPACE/of.0 bs=2 seek=1 
dd if=/etc/passwd of=$WORKSPACE/of.1 bs=2 seek=1 2> /dev/null
diff -y $WORKSPACE/of.0 $WORKSPACE/of.1 > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=/etc/passwd of=$WORKSPACE/of bs=2 seek=1 (valgrind)"
valgrind --leak-check=full ./$PROGRAM if=/etc/passwd of=$WORKSPACE/of.0 bs=2 seek=1 &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=/etc/passwd of=$WORKSPACE/of bs=2 count=5 seek=1"
./$PROGRAM if=/etc/passwd of=$WORKSPACE/of.0 bs=2 count=5 seek=1 
dd if=/etc/passwd of=$WORKSPACE/of.1 bs=2 count=5 seek=1 conv=notrunc 2> /dev/null
diff -y $WORKSPACE/of.0 $WORKSPACE/of.1 > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=/etc/passwd of=$WORKSPACE/of bs=2 count=5 seek=1 (valgrind)"
valgrind --leak-check=full ./$PROGRAM if=/etc/passwd of=$WORKSPACE/of.0 bs=2 count=5 seek=1 &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=/etc/passwd of=/asdfasdf"
valgrind --leak-check=full ./$PROGRAM if=/etc/passwd of=/asdfasdf &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-72s ... " "if=/etc/passwd bs=9223372036854775807"
valgrind --leak-check=full ./$PROGRAM if=/etc/passwd bs=9223372036854775807 &> $WORKSPACE/test
if [ $(awk '/ERROR SUMMARY:/ {print $4}' $WORKSPACE/test) -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

TESTS=$(($(grep -c Success $0) - 1))
echo "   Score $(echo "scale=2; ($TESTS - $FAILURES) / $TESTS.0 * 4.50" | bc | awk '{printf "%0.2f\n", $0}')"
echo
