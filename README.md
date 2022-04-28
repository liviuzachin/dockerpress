# Docker compose killer wordpress starter
A pretty simplified Docker Compose workflow that sets up a LEMP network of containers, including nginx proxy manager, wordpress, mariadb and phpmyadmin for local/prod development.


## Usage
To get started, make sure you have [Docker installed](https://docs.docker.com/get-docker/) on your system, and then clone this repository.

Next, navigate in your terminal to the directory of this project, have a look at the `Dockerfile` and `docker-compose.yml`, update as per your needs and spin up the containers for the web server by running `docker-compose up -d --build app`.

By default, this will create an wordpress app and an nginx-proxy manager for you to get started easily.

If you want to use the volume of your own app, add your app to the project and uncomment the `./app:/var/www/root` volume part in docker-compose.yml file.

Bringing up the Docker Compose network with `app` instead of just using `up`, ensures that only our app's containers are brought up at the start, instead of all of the command containers as well. The following are built for our web server, with their exposed ports detailed:

After that completes, you can setup the nginx proxy for your apps by hitting `localhost:81`. [Follow this link for more info on how NGINX Proxy manager works](https://nginxproxymanager.com/)

- **nginx-proxy** - `:6379`
- **wordpress** - `:80`
- **mariadb** - `:3306`
- **phpmyadmin** - `:80`
