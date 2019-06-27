#!/bin/sh

if [ "" = "$SPARK_TYPE" ]; then
    echo ""
    echo "Error: This container need parameters!"
    echo ""
    echo "Environment variables:"
    echo "SPARK_TYPE"
    echo "  master"
    echo "  slave"
    echo ""
    echo "if is a slave, a extra variable is needed:"
    echo "MASTER_SPARK_URL"
    echo "  master_hostname:master_portnumber"
    echo ""
    echo "  ex: master"
    echo "  docker run -p 8080:8080 -p 7077:7077 -d -e SPARK_TYPE=master spark-cluster:2.4"
    echo ""
    echo "  ex: slave"
    echo "  docker run -p 7078:7078 -d -e SPARK_TYPE=slave -e MASTER_SPARK_URL=masterhost:7077 spark-cluster:2.4"
    echo ""
    echo ""
    echo "If you have a additional configuration, add it in the following environment variable"
    echo "EXTRA_PARAMS"
    echo "  '--port 7078'"
    echo ""
    echo "Enjoy!"
else
    if [[ $(echo "master" | grep -i "$SPARK_TYPE") ]]; then
        sbin/start-master.sh $EXTRA_PARAMS
    else
        sbin/start-slave.sh $MASTER_SPARK_URL $EXTRA_PARAMS
    fi
fi
while true; do sleep 1000; done
