FROM ubuntu:14.04

MAINTAINER Ivan Sadikov <sadikovi@docker.com>

USER root

# install depedencies
RUN apt-get update && apt-get install -y curl openssh-server

# install Oracle JDK 7
RUN curl -L "http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz" -H "Cookie: oraclelicense=accept-securebackup-cookie" | tar -xz -C /usr/share
ENV JAVA_HOME=/usr/share/jdk1.7.0_80

# install Hadoop
ENV HADOOP_VERSION=2.7.1
ENV HADOOP_INSTALL=/usr/local/hadoop
RUN curl -L "http://mirrors.sonic.net/apache/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" | tar -xz -C /usr/local
RUN ln -s /usr/local/hadoop-$HADOOP_VERSION $HADOOP_INSTALL

ENV PATH=$PATH:$HADOOP_INSTALL/bin:$HADOOP_INSTALL/sbin
ENV HADOOP_MAPRED_HOME=$HADOOP_INSTALL
ENV HADOOP_COMMON_HOME=$HADOOP_INSTALL
ENV HADOOP_HOME=$HADOOP_INSTALL
ENV HADOOP_HDFS_HOME=$HADOOP_INSTALL
ENV HADOOP_PREFIX=$HADOOP_INSTALL
ENV YARN_HOME=$HADOOP_INSTALL
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_INSTALL/lib/native
ENV HADOOP_OPTS="-Djava.library.path=$HADOOP_INSTALL/lib"

# set up passwordless ssh
RUN mkdir /var/run/sshd
RUN ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
ADD ssh_config /etc/ssh/ssh_config

# copy all necessary files for running HDFS
ADD core-site.xml.template $HADOOP_HOME/etc/hadoop/core-site.xml.template
RUN sed -i "/^export JAVA_HOME/ s:.*:export JAVA_HOME=$JAVA_HOME:" $HADOOP_HOME/etc/hadoop/hadoop-env.sh
ADD hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
ADD bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

# format hadoop file system
RUN hdfs namenode -format

# HDFS ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000
# Mapred ports
EXPOSE 10020 19888
# Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088
# Other ports
EXPOSE 49707 2122

CMD ["/etc/bootstrap.sh", "-d"]
