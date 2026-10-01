# Time tracking for Runwell

Log time on clients, engagements and work, with totals and a weekly timesheet.

A plugin for [Runwell](https://github.com/Martin-Business-Consultants/runwellv2), the core of an
agency's project management. It owns its tables (`time_tracking_*`), points at core records by id, and
extends Runwell only through its plugin hooks, so removing it leaves Runwell as it was.

## Install

In Runwell, **Settings > Plugins > Add a plugin**: press Install on Time tracking, or enter
`Martin-Business-Consultants/runwell-time-tracking`. Runwell downloads the latest release onto the server, restarts and creates the
plugin's tables. It starts off: switch it on in Settings > Plugins.

From the command line on the server: `bin/rails "plugins:install[Martin-Business-Consultants/runwell-time-tracking]"`, then restart
Runwell.

Needs Runwell 2.1.0 or later. A plugin can use only the gems Runwell bundles.

## Updating

Settings > Plugins shows an Update button on the plugin when a newer release is out (it checks
nightly, or with Check for updates). The plugin updates only when someone presses it; if the new
release won't load, the previous one comes back.

## Developing

Clone this repository beside a Runwell checkout and link it in, from Runwell's directory:

```sh
bin/rails "plugins:link[../runwell-time-tracking]"
bin/rails db:migrate
bin/dev
```

## Releasing

Bump `VERSION` in `lib/time_tracking/version.rb`, commit, then tag and publish a GitHub release:

```sh
git tag v0.2.0 && git push origin main v0.2.0
gh release create v0.2.0 --generate-notes
```

Installs see it in Settings > Plugins.

## License

[FSL-1.1-MIT](LICENSE.md), like Runwell.
