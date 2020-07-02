docker-build:
	docker build . -t covid-analyzer

docker-run:
	docker run -d -p 8080:80 --name covid-analyzer covid-analyzer

docker-stop:
	docker rm -f covid-analyzer
