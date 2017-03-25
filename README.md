# hadoop-docker
Docker image for Hadoop 2.7.1

To build docker image, run:
```shell
docker build -t lightcopy/hadoop-docker:2.7.1 .
```

Run container in daemon mode (expose ports for UI and file system):
```shell
docker run -p 50070:50070 -p 8020:8020 lightcopy/hadoop-docker:2.7.1
```

Run container with interactive session:
```
docker run -it -p 50070:50070 -p 8020:8020 lightcopy/hadoop-docker:2.7.1 /etc/bootstrap.sh -bash
```
