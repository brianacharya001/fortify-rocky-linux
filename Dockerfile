# Setting up Fortify Image with Base of Rocky Linux 
FROM http://nexus3-openshift-operators.apps.vapo-ppd.va.gov/repository/vapo/vapo/forttify/rockylinux.tar
RUN wget --user=admin  --password=Thursday1234! http://nexus3-openshift-operators.apps.vapo-ppd.va.gov/repository/vapo/vapo/forttify/rockylinux.tar
RUN tar -xvf 
#FROM rhel7/rhel-atomic:7.9-438
# FROM quay.io/centos/centos
# work in temp for the install
WORKDIR /tmp

# copy all local files over
COPY . .
# Remove Certificate Verification
RUN yum install yum-utils -y
RUN yum-config-manager --save --setopt=appstream.sslverify=false

# Copy Over the Require Artifacts to Install Fortify
# COPY artifacts /artifacts --put comment

# Install Required Dependencies
# RUN yum install unzip -y --- put comment
RUN echo "sslverify=false" >> /etc/yum/yum.conf
RUN yum clean all
RUN yum install wget -y
RUN alias curl="curl -insecure"
RUN wget --user=admin  --password=Thursday1234!  http://nexus3-openshift-operators.apps.vapo-ppd.va.gov/repository/vapo/vapo/fortify/jdk-11.0.12_linux-x64_bin.rpm
# Install Oracle JDK 11
# WORKDIR /artifacts ------put comment
RUN rpm -ivh jdk-11.0.12_linux-x64_bin.rpm

# Setting the Environment Variables for Java
ENV SetJavaHome=/usr/java/jdk-11.0.12/
ENV JAVA_HOME=/usr/java/jdk-11.0.12/
ENV PATH=$JAVA_HOME/bin:$PATH

# Installing Tomcat as Fortify SSC is a Java Based Application
RUN wget  --user=admin  --password=Thursday1234! http://nexus3-openshift-operators.apps.vapo-ppd.va.gov/repository/vapo/vapo/fortify/apache-tomcat-9.0.58.tar.gz
RUN mkdir /opt/tomcat
RUN tar -xvf apache-tomcat-9.0.48.tar.gz -C /opt/tomcat --strip-components=1

# Set Catalina Environment Variables
ENV CATALINA_HOME /opt/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

# Deploy the SCC WAR to the Tomcat Deployments Folder
RUN wget --user=admin  --password=Thursday1234!     http://nexus3-openshift-operators.apps.vapo-ppd.va.gov/repository/vapo/vapo/fortify/ssc.war
RUN mv ssc.war /opt/tomcat/webapps

# Setting up for SSL/443
# Copy over the Configuration Files used by Tomcat. 
# Note: These can be changed for ConfigMaps in Kubernetes
COPY config /config
WORKDIR /config

# Location for the Java Keystores
RUN mkdir /opt/certs

# Generate a JKS for Self Signing Certificate/Server Certificate
RUN keytool -genkey  -keyalg RSA  -dname "CN=jsvede.bea.com,OU=DRE,O=BEA,L=Denver,S=Colorado,C=US" -keypass v8PO!R0ckS  -storepass v8PO!R0ckS -keystore /opt/certs/fortify.keystore

RUN mv server.xml /opt/tomcat/conf/server.xml
RUN mv web.xml /opt/tomcat/webapps/manager/WEB-INF/web.xml
RUN mv tomcat-users.xml /opt/tomcat/conf/tomcat-users.xml
RUN mv context.xml /opt/tomcat/webapps/manager/META-INF/context.xml

# Utilize a Port other than default
# This can be changed in the server.xml
EXPOSE 2424

# Setup the Runtime for the Container
CMD ["catalina.sh", "run"]
