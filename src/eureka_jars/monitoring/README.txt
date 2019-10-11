Before building, please make changes to /src/main/resources/application.properties:

1) Change "eureka.client.serviceUrl.defaultZone" to the Eureka server's (on Defendr machine) IP address
2) Change "eureka.instance.instanceid" to your machine's (or which ever machine will be hosting a service) MAC address
3) Change "info.app.ip" to your machine's (or which ever machine will be hosting a service) MAC address

When ready to build, navigate to /monitoring and enter "gradle clean build deploy" to start a build.

The final jar can be found in /build/libs