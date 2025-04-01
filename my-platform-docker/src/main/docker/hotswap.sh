#!/bin/bash
chown -R root:Alfresco /platform
chown -R root:Alfresco /integration-tests
cp -r /platform/* /usr/local/tomcat/ext_classpath/
cp -r /integration-tests/* /usr/local/tomcat/ext_classpath/