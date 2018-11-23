# WebProtégé Docker Deployment
Dockerfile for WebProtégé image.

# How to use the image

1. Create a new user defined docker network

```
sudo docker network create webprotege
```

2. Start MongoDB

```
sudo docker run -d --network webprotege -v mongodb-data:/data/db -v mongodb-config:/data/configdb --name mongodb mongo:latest
```

3. Build the WebProtégé docker image

From this repositories root directory:
```
sudo docker build . -t webprotege:latest
```

3. Start WebProtégé

```
sudo docker run -d --network webprotege -p 8888:8080 -v webprotege-config:/etc/webprotege -v webprotege-data:/srv/webprotege -v webprotege-logs:/var/log/webprotege --name webprotege webprotege
```

4. Configure WebProtégé with an administrative user account.

```
sudo docker exec -it webprotege java -jar /usr/local/webprotege/bin/webprotege-cli.jar create-admin-account
```

You'll be prompted to enter an email and a password for the administrative account.

5. Navigate to http://localhost:8888 using your web browser of choice.


You're going to see the following message:

> WebProtégé is not configured properly

Don't panic, we just need to finish confiugration via the UI, so login using the administrative user account that you created.

Go to http://localhost:8888#application/settings. At a minimum you need to specify; a *System notification email address*, *Host*, and a *Port*. At this point in the process you can use `localhost` for *Host* and `8888` for *Port* to get started right away.

When you're done messing with the configuration, submit those changes (you may need to refresh the page to get the warning to go away).

WebProtégé is now ready to use. Here are some additional links to help you learn more about WebProtégé.

[Product Information Site](https://protege.stanford.edu/products.php) - Includes User and Administrative Guides.

[GitHub Repository](https://github.com/protegeproject/webprotege - If you're interested in popping open the hood.

# Development Notes

The Dockerfile was authorized using the installation notes for [WebProtégé 3.0.0](https://github.com/protegeproject/webprotege/wiki/WebProt%C3%A9g%C3%A9-3.0.0-Installation), which was released Feb 7, 2018.  


WebProtégé has a handful of dependencies including:

* Java 8
* Tomcat >= 7
* MongoDB


Consequently, the [official Apache Tomcat repository](https://hub.docker.com/r/library/tomcat/) was a logical place to find a base image for WebProtégé. The [9-jre8-alpine](https://hub.docker.com/r/library/tomcat/tags/) tag was chosen to keep the size of the docker image small.

MongoDB is intended to be run separately and is therefore not included with this image.

## Configuration

#### Apache Tomcat

The only extra configuration required for Apache Tomcat to run WebProtégé is
to set the JVM's file encoding to UTF-8. That is accomplished in the usual way by adding a setenv.sh file for Apache Tomcat. It contains the following line:

```
export CATALINA_OPTS="$CATALINA_OPTS -Dfile.encoding=UTF-8"
```

#### WebProtégé configuration

Because we expect MongoDB image in a separate container on the same docker network we updated the webprotege.properties configuration to:

```
mongodb.host=mongodb
```  
