# [Mozubi - Learning platform](https://www.mozubi.app/)

## License

All source code in the [Mozubi](https://www.mozubi.app/)
is available under the NAME License.

## Getting started

To get started with the app, clone the repo and then install the needed gems:

```shell
$ bundle install
```

Next, migrate the database:

```shell
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```shell
$ rails test
```

If the test suite passes, you'll be ready to run the app in a local server:

```shell
$ rails server
```

Automate tests with guard

```shell
$ bin/spring stop    # Try this if the tests mysteriously start failing.
$ bundle exec guard
```

Check security with brakeman

```shell
$ bundle exec brakeman
```

Check gem vulnerabilities with bundle-audit

```shell
$ bundle exec bundle-audit
```

Pundit. Use the supplied generator to generate policies:

```shell
rails g pundit:policy model
```
