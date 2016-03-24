# Jodel Stats

This is the source code for [jodelstats.com](http://jodelstats.com), which is a small web app that shows the most popular posts on [Jodel](jodel-app.com) in Germany. (other countries may be coming soon!)

### How does this web app work?
This web app communicates with the Jodel servers to obtain the most popular posts in various cities. The city names and coordinates are saved in the database. The front end is just some Bootstrap magic.

### I want feature X!
If you have any suggestions or if you would like to reach out to me, feel free to message me on [Twitter](twitter.com/ppati000) or send me an [e-mail](mailto:ppati000@me.com).

### Can I contribute to this thing?
Yes, of course! The process is as follows:

1. Fork this repository
2. Push your changes
3. Create a pull request

### Todo
- ~~Fix API Keys (API Keys are currently invalidated after 1 week, and fetching new API keys needs to be implemented)~~ Edit: The app can now fetch new API keys, but only if a valid API key **already exists** in the database. Moreover, if several environments are used (e.g. dev and production), refreshing the API key in one environment will leave the other environment with the old, now invalid API key. Possible fixes for the future: Disable fetching keys for development, or find a way to obtain entirely new API keys which do not invalidate old API keys.
- Internationalization
- Search function (probably using Google Maps API)
- Anything else you like
