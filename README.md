# covid-analyzer
[Vapor](https://vapor.codes/) server that ingests NYT covid CSV and returns analysis data via REST API

## Description
This server loads the CSV files kindly provided by the New York Times here: https://github.com/nytimes/covid-19-data

At present there's no autofetch/autoload capabilities; one must update the file(s) in `Sources/App/Resources` before run/deploy.  :-/


At present the service provides NYT data by location/date for:
- cases
- deaths

plus derived values for
- new cases
- 7-day average of new cases

## Local Development

This project should be pretty clean and self-contained; hopefully one need only run `vapor build --run` or `vapor xcode` to have something to work with.  Take a look at `routes.swift` to see what you can `curl` - a good first step is to `get /healthcheck` to make sure you're running.

It is also possible to build and run with docker using the following `make` commands

`make docker-build` builds and tags a docker image using a swift base image

`make docker-run` runs the server on localhost:8080 to avoid requiring root permissions to run the image. This leaves the container running in the background.

`make docker-stop` stops and removes the running container and lets you rebuild it.

## Contributing
Obviously there's lots more to do but I feel like this is off to a decent start.  Planned enhancements include:
- auto-fetch NYT data
- Include population by state (possibly by county? feels ambitious) for e.g. cases/100k metrics and the like
- Dockerization/Productionization
- General beautification

PRs are super-welcome!
