# SlackTemplate


A slack bot that adds slash command "/template".

With this command you can save some snippets and quickly retrieve them whithout switching from slack.

## Setup

This bot can be easily deployed as a cloud foundry app on the IBM bluemix platform.

Download and setup cf CLI application as explained on [this page](https://console.eu-gb.bluemix.net/docs/cfapps/ee.html#ee_cf)(steps 2-4).

Now you can push an application via `cf push YourAppName`


Then you will need some pgsql server to store your data. 

For the first experiment a free version of experimental bluemix postgresql service can be used: https://console.eu-gb.bluemix.net/catalog/services/postgresql/

Select your app in "App:" dropdown to bind the service to your application and press "Create".


Now you need to add credentials of your new pgsql db to the application.

In the config folder add a new file "prod.secret.exs".

Fill it with your data, it should look something like this:

```
use Mix.Config

config :slack_template, slack_token: "YourSlackTokenHere"

config :slack_template, SlackTemplate.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: "postgres://db_username:db_password@db_hostname:db_port/databasename",
  pool_size: 10 

config :slack_template, :cowboy_port, System.get_env("PORT")
```

Everything is set up, push your application again with `cf push YourAppName`
