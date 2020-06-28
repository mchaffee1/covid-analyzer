# covid-analyzer
[Vapor](https://vapor.codes/) server that ingests NYT covid CSV and returns analysis data via REST API

This server loads the CSV files kindly provided by the New York Times here: https://github.com/nytimes/covid-19-data

At present there's no autofetch/autoload capabilities; one must update the file(s) in `Sources/App/Resources` before run/deploy.  :-/

This project should be pretty clean and self-contained; hopefully one need only run `vapor build --run` or `vapor xcode` to have something to work with.  Take a look at `routes.swift` to see what you can `curl` - a good first step is to `get /healthcheck` to make sure you're running.

At present the service provides NYT data by location/date for:
- cases
- deaths

plus derived values for
- new cases
- 7-day average of new cases

Obviously there's lots more to do but I feel like this is off to a decent start.  Planned enhancements include:
- auto-fetch NYT data
- Include population by state (possibly by county? feels ambitious) for e.g. cases/100k metrics and the like
- Dockerization/Productionization
- General beautification

PRs are super-welcome!
