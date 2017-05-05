# nicklarsennz/glassfish:4.1.2

## Credits
This is based on the work by @brunoborges for glassfish/server:4.1.1 which can be found at https://github.com/glassfish/docker/blob/master/4.1.1/Dockerfile

## Additions
- Updated to Glassfish 4.1.2
- Custom [domain.xml](domain.xml)
  - Removed a bunch of services
  - Removed Server and X-PoweredBy headers
  - Removed the SSL HTTP Listener
  - Configured generic app to be deployed, with context-root="/app"
- Symbolic links to make it easier to deploy
  - /data/applications
  - /data/logs
  - /data/static

## Example usage
```Dockerfile
FROM nicklarsennz/glassfish:4.1.2

# Must copy your Expanded WAR as app/ per domain.xml configuration
COPY ./build/my-expanded.war /data/applications/app
COPY ./build/single-page-app /data/static

EXPOSE 8080
CMD ["asadmin", "start-domain", "-v"]
```

Then...
1. Build
  - `docker built -t my-app:my-tag .`
2. Run (either):
  - `docker run -d -it -p 8080:8080 my-app:my-tag`
  - `kubectl run My-App --image=my-app:my-tag --expose --port=8080`
3. Ship
  - `docker login`
  - `docker push <username>/my-app:my-tag`

