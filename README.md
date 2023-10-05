# DEA Register

This application provides a Register of Information sharing agreements under chapters 1, 2, 3 and 4 of part 5 of the Digital Economy Act 2017.

## Airtable data

The source data is stored in an Airtable base store. The specific base is specified via a
[Personal Access Token](https://airtable.com/developers/web/api/authentication).
See the AirTableApi service object for how this token is stored.

### Local store

The main models in this application inherit from an `AirTable` class and are types of that class. So their data is
stored in a single table: `air_tables`.

Most of the data specific to a particular model is stored in the `fields` attribute. This is a JSON object that
holds the original data pulled from the Airtable source. This arrangement was chosen to lesson the likelihood that
a change in the Airtable would break the application. If a field in the source Airtable is changed (specifically
renamed) the data will no longer be displayed, but it should not break the application.

### Population

An Airtable model can be populated by calling its class method `populate`. This method is defined on the root `AirTable`
class.

Join tables are used to manage the associated between models. These have their own `populate` class methods which
are defined on each of the models

Database seeding runs `populate` of all these models and populates their tables:

    rails db:seed

If the database is empty, this will populate the tables with the current data in the Airtable. If the database
is already populated, this process will update the data to match the current data. This includes deleting any
records that have been deleted from Airtable.

In production this task is run via a cron job and ensures that the application is regularly synchronised with
the source data.

### Search

Searching is provided by the Postgres search tool PgSearch. See the Search Controller for details.

## Maintenance

Before this application will run successfully locally, the following actions will be required:

- Obtain the current master.key and save it in `/config`. Or set up a new Rails credentials containing:

      airtable_api_key: [Airetable Personal Access Token]

- Run `yarn` to set up the JavaScript environment
- Run 'rake dartsass:build' to build application.css

The application tests use RSpec and can be run via the command `rspec`.

Linting is provided by GOV.UK flavoured rubocop and can be run at the application root via the command `rubocop`.

## Staging

This application is hosted in Heroku for staging, and is set to deploy automatically on merging code to `main`. Note that there is a separate "heroku" environment used when hosting the app on Heroku.

## Production

This application is containerised via docker, for use in production. To run the container use:

    AIRTABLE_API_KEY=[airtable_api_key] RAILS_MASTER_KEY=[random uuid] docker-compose up --build

Where `[airtable_api_key]` is the airtable Personal Access Token (see above)

## Contacts

This application was built by Rob Nichols and the data is maintained by Sulaiman Saeed. Please contact them
for information about the application.
