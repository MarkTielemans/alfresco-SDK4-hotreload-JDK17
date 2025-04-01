FROM ${docker.acs.image}:${alfresco.platform.version}

ARG TOMCAT_DIR=/usr/local/tomcat
ARG USERNAME=${alfresco.platform.docker.user} 

USER root

# Download Jetbrains DCEVM JDK 17
RUN curl --location https://cache-redirector.jetbrains.com/intellij-jbr/jbr-17.0.14-linux-x64-b1367.22.tar.gz --output $TOMCAT_DIR/jbr-dcevm-jdk.tar.gz
RUN yum install -y unzip

# Install Jetbrains DCEVM JDK 17
RUN mkdir mkdir /usr/java && \
    tar -xvf $TOMCAT_DIR/jbr-dcevm-jdk.tar.gz -C /usr/java/ --strip-components=1 && \
     rm $TOMCAT_DIR/jbr-dcevm-jdk.tar.gz && \
        alternatives --install /usr/bin/javac javac /usr/java/bin/javac 40000 && \
        alternatives --install /usr/lib/jre jre /usr/java 40000 || true && \
        alternatives --install /usr/bin/java java /usr/java/bin/java 40000 && \
        alternatives --set jre /usr/java || true && \
        alternatives --set java /usr/java/bin/java && \
        alternatives --set javac /usr/java/bin/javac && \
        ln -sf /usr/java /etc/alternatives/jre

# Configure ext_classpath
RUN mkdir $TOMCAT_DIR/ext_classpath
COPY alfresco.xml $TOMCAT_DIR/conf/Catalina/localhost/alfresco.xml

# Copy Dockerfile to avoid an error if no JARs exist
COPY Dockerfile extensions/*.jar /extensions/

# Unpack JARs into ext_classpath
RUN find /extensions -name "*.jar" -type f -exec unzip {} -d $TOMCAT_DIR/ext_classpath \; && \
    rm -rf /extensions

# Install and configure Hotswap Agent
COPY hotswap-agent-2.0.1.jar /usr/java/lib/hotswap/hotswap-agent.jar
COPY hotswap-agent.properties $TOMCAT_DIR/webapps/alfresco/WEB-INF/classes

# Script to trigger hotswap by file copy as filewatching doesn't work on Windows hosts
COPY hotswap.sh /hotswap.sh

# Copy Dockerfile to avoid an error if no AMPs exist
COPY Dockerfile extensions/*.amp $TOMCAT_DIR/amps/
RUN java -jar $TOMCAT_DIR/alfresco-mmt/alfresco-mmt*.jar install \
              $TOMCAT_DIR/amps $TOMCAT_DIR/webapps/alfresco -directory -nobackup -force

COPY alfresco-global.properties $TOMCAT_DIR/shared/classes/alfresco-global.properties
COPY dev-log4j2.properties $TOMCAT_DIR/webapps/alfresco/WEB-INF/classes/log4j2.properties
COPY disable-webscript-caching-context.xml $TOMCAT_DIR/shared/classes/alfresco/extension

# Copy Dockerfile to avoid an error if no license file exists
COPY Dockerfile license/*.* $TOMCAT_DIR/webapps/alfresco/WEB-INF/classes/alfresco/extension/license/

USER ${USERNAME}