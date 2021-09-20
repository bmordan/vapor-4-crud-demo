# Vapor 4

Vapor is the most used web framework for Swift. It provides a beautifully expressive and easy to use foundation for your next website or API.

This repo has example code to spin up a simple server. The endpoints logic is still in the `routes.swift` file in time you'd want to move this into a controller.

There is config for a postgres. Postgres seems a better option as you can't deploy to Heroku with a Sqlite3. This assumes you build a docker image of the project, push the docker image to heroku's registry, then 'release' by running that container.

## Postgres

The easy option is to run Vapor 4 with a postgres DB. You can install and run postgres for local development with the local enviromental variables set in xcode. Product -> Scheme -> Edit Scheme -> Run -> Arguments

![xcode local env vars](https://user-images.githubusercontent.com/4499581/134075263-de9f7eff-4bd4-4dcf-96d6-2f80cdf433e0.png)

When you deploy to Heroku these env vars will be populated by the dyno context.

## Docker for Heroku

```sh
heroku container:login
```
Create an app on heroku (make a note of the app name). Use the postgres heroku add-on. To build the Docker image for Heroku tag with the following convention `registry.heroku.com/<YOUR_APP>/<target>`.
```sh
docker build -t registry.heroku.com/vapor-4-todo/web .
```
Then wait, then push your image to the heroku docker registry
```sh
docker push registry.heroku.com/vapor-4-todo/web
```
Finally you can deploy with 
```sh
heroku container:release --app vapor-4-todo web
```

## Test the API

You should be able to then test the API from postman or something like that.
```sh
curl https://vapor-4-todo.herokuapp.com/todos
```

Using the shell script to start the app is not very elegant, but I can seem to overide the default `/` WORKDIR that heroku uses, so the `ENTRYPOINT ["./Run"]` was not starting the app properly. The shell script works so I will leave it there for now.
