FROM centos:7.6.1810

USER root

RUN yum update -y && \
	yum upgrade -y

WORKDIR /tmp

# Install extra tools
RUN yum install -y wget

# Install Java
RUN yum install java-1.8.0-openjdk -y

# Install Scala
RUN wget https://downloads.lightbend.com/scala/2.11.8/scala-2.11.8.tgz && \
	tar xf scala-2.11.8.tgz && \
	mv scala-2.11.8 /usr/lib && \
	rm -Rf scala-2.11.8.tgz && \
	ln -s /usr/lib/scala-2.11.8 /usr/lib/scala

# Install Spark
RUN wget https://downloads.apache.org/spark/spark-3.0.0/spark-3.0.0-bin-hadoop2.7.tgz && \
	tar xf spark-3.0.0-bin-hadoop2.7.tgz && \
	mkdir /usr/local/spark && \
	cp -r spark-3.0.0-bin-hadoop2.7/* /usr/local/spark && \
	rm -Rf spark-3.0.0-bin-hadoop2.7 && \
	rm -Rf spark-3.0.0-bin-hadoop2.7.tgz

# Copy Spark start command
COPY start-spark.sh /usr/local/spark/start-spark.sh

# Create Spark user
RUN adduser spark && \
	usermod -aG spark spark && \
	chown spark. /usr/lib/jvm -Rf && \
	chown spark. /usr/lib/scala -Rf && \
	chown spark. /usr/local/spark -Rf && \
        chmod 755 /usr/local/spark/start-spark.sh

# Expose log files to Standard output
#RUN mkdir -p /usr/local/spark/logs/ && \
#    chown spark. /usr/local/spark/logs -Rf && \
#    ln -sf /dev/stdout /usr/local/spark/logs/stdout

USER spark

RUN export PATH=$PATH:/usr/lib/scala/bin && \
	export SPARK_EXAMPLES_JAR=/usr/local/spark/examples/jars/spark-examples_2.11-3.0.0.jar && \
        export PATH=$PATH:$HOME/bin:/usr/local/spark/sbin:/usr/local/spark/bin && \
        source ~/.bash_profile

# Specify the working directory
WORKDIR /usr/local/spark

#EXPOSE 8080 7077

CMD ["./start-spark.sh"]
