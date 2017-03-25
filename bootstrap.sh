#!/bin/bash

rm -f /tmp/*.pid

service ssh start
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh

sed s/HOSTNAME/$HOSTNAME/ $HADOOP_HOME/etc/hadoop/core-site.xml.template > $HADOOP_HOME/etc/hadoop/core-site.xml

if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
elif [[ $1 == "-bash" ]]; then
  /bin/bash
fi
