#!/usr/bin/env bash

binary=$1
shift

if [[ -z "${binary}" ]] ; then
    echo "Must specify binary to test as first input"
    exit 1
fi

cp ${binary} .
bbase=$(basename ${binary})

[[ ! -x ${bbase} ]] && echo "Binary not present in current dir" && exit 1

echo > .report.txt
for i in $(cat images.csv) ; do
    echo "doing image $i"
    echo -n "$i " >> .report.txt
    docker run -it -v $(pwd)/${bbase}:/code/${bbase} $i /bin/sh -c "ldd /code/${bbase} ; /code/${bbase} --help"
    if (($? == 0)) ; then
        echo "PASSED" >> .report.txt
    else
        echo "FAILED" >> .report.txt
    fi
done

echo "Final report:"
cat .report.txt
rm -f .report.txt
rm -f ${bbase}
