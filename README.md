# covid-analyzer
Vapor server that ingests NYT covid CSV and returns analysis data via REST API

This server loads the CSV files kindly provided by the New York Times here: https://github.com/nytimes/covid-19-data

At present there's no autofetch/autoload capabilities; one must update the file(s) in Sources/App/Resources before run/deploy.  :-/

This project should be pretty clean and self-contained; hopefully one need only run `vapor build --run` or `vapor xcode` to have something to work with.

At present the thing provides NYT data by location/date for:
- cases
- deaths
plus derived values for
- new cases
- 7-day average of new cases
Obviously there's lots more to do but I feel like this is off to a decent start.

PRs are super-welcome!
