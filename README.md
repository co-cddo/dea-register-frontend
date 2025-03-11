# DEA Register

This application provides a Register of Information sharing agreements under chapters 1, 2, 3 and 4 of part 5 of the Digital Economy Act 2017.

## Data source

The data source is a [rAPId](https://rapid.readthedocs.io/) application. For access the following credentials need to
be passed into the matching environment variables:

| Credential    | Environment Variable |
| ------------- | -------------------- |
| Client ID     | RAPID_CLIENT_ID      |
| Client Name   | RAPID_CLIENT_NAME    |
| Client Secret | RAPID_CLIENT_SECRET  |

### Local store

The main models in this application inherit from a `DataTable` class and are types of that class. So their data is
stored in a single table: `data_tables`.

Most of the data specific to a particular model is stored in the `fields` attribute. This is a JSON object that
holds the original data pulled from the data source. This arrangement was chosen to lesson the likelihood that
a change in the source data would break the application. If a field in the source is changed (specifically
renamed) the data will no longer be displayed, but it should not break the application.

### Population

A data model can be populated by calling its class method `populate`. This method is defined on the root `DataTable`
class.

Join tables are used to manage the associated between models. These have their own `populate` class methods which
are defined on each of the models

Database seeding runs `populate` on all these models and populates their tables:

    rails db:seed

If the database is empty, this will populate the tables with the current data in from the data source.

If the database is already populated, this process will update the data to match the current data. This includes deleting any records that have been deleted from the data source.

Seeding also rebuilds the search database.

In production this task is run via a cron job and ensures that the application is regularly synchronised with
the source data.

In staging a button is available on the home page that allows the population task to be triggered from the home page.
This task is carried out via a delayed job and for it to run there must be a worker running. This is done so that the
web interface is not frozen while the population task is running. In production, the cron job runs in a separate
space so does not need to be run via delayed job.

### Search

Searching is provided by the Postgres search tool PgSearch. See the Search Controller for details.

### API

The agreement data can be rendered as JSON. The entry point is /agreements.json. This is a list view that includes:

- the name of each agreement listed
- links to detailed views of each agreement listed

The default index view is for the first 20 agreements. The root "links" element contains links to the next page (and previous page when present).

The parameter "items" can be used in the URL to change the number of agreements listed. The parameter "page" defines the page number.
For example, to display the fifth and sixth agreements use the url: /agreements.json?page=3&items=2

## Maintenance

Before this application will run successfully locally, the following actions will be required:

- Obtain the current master.key and save it in `/config`. Or set up a new Rails credentials containing:

      rapid:
        client_id: [a client id]
        client_name: [a client name]
        client_secret: [a client secret]

- Run `yarn` to set up the JavaScript environment
- Run 'rake dartsass:build' to build application.css

The application tests use RSpec and can be run via the command `rspec`.

Linting is provided by GOV.UK flavoured rubocop and can be run at the application root via the command `rubocop`.

## Staging

This application is hosted in Heroku for staging, and is set to deploy automatically on merging code to `main`. Note that there is a separate "heroku" environment used when hosting the app on Heroku.

## Production

This application is hosted in Heroku for production. Promotion of merged code is done manually. The staging and
production instances are within a pipeline (cddo-dea-register-pipeline) and both instances can be managed from within the pipeline.

## Contacts

This application was built by Rob Nichols and the data is maintained by Sulaiman Saeed. Please contact them
for information about the application.
