#!/usr/bin/env bash

# configuration
scriptFolder=/home/mocc/mocc_submission2/myct/benchmark_scripts
resultFolder=/home/mocc/mocc_submission2/myct/benchmark_scripts/results
system=${1:-"native"}
nginxPort=8080
nSamplePoints=48
# host: dropping system caches would need root priviledges (sudo is not enough!)
# docker: /proc is only mounted as readonly file system
dropCaches=false

# prepare output files
echo "Preparing output folder ${resultFolder} for ${system} measurements"
mkdir -p ${resultFolder}
for ending in "cpu.csv" "mem.csv" "disk-random.csv" "fork.csv" "nginx.csv"; do
    f=${resultFolder}/${system}-${ending}
    if ! [[ -e ${f} ]]; then
        echo "time,value" > ${f}
    fi
done

# start taking measurements
echo "Start taking ${nSamplePoints} measurements"
echo "  nginx address: localhost:${nginxPort}"
if ! [ "${dropCaches}" = true ]; then
    echo "  skipping system cache drops"
fi

cd ${scriptFolder}
for (( i=0; i < ${nSamplePoints}; i++ )); do
    echo "Sampling in progress $((i+1)) / ${nSamplePoints}"
    #./measure-cpu.sh >> ${resultFolder}/${system}-cpu.csv
    #./measure-mem.sh >> ${resultFolder}/${system}-mem.csv
    #./measure-disk-random.sh >> ${resultFolder}/${system}-disk-random.csv
    #./measure-fork.sh >> ${resultFolder}/${system}-fork.csv
    ./measure-nginx.sh localhost:${nginxPort} >> ${resultFolder}/${system}-nginx.csv

    # flush to disk and drop caches
    sync
    if [ "${dropCaches}" = true ]; then
        echo 3 > /proc/sys/vm/drop_caches
    fi
    sleep 10
done

echo "Finished taking measurements"
echo "results are in the folder ${resultFolder}"
