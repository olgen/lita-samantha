# lita-samantha

**lita-samantha** is a handler for [Lita](https://github.com/jimmycuadra/lita) that a human friendly interface to the samantha knowledge base.

## Installation

Add lita-samantha to your Lita instance's Gemfile:

``` ruby
gem "lita-samantha"
```


## Configuration

This plugin requires a working samantha account & db_url & api_secret.

``` ruby
  config.handlers.samantha.db_url = ENV['SAMANTHA_DB_URL']
```

## Usage

```
Lita: what's happening?

---
Funnel performance forNot much...only this:
Eugen Martin created GitCommit:'Merge branch "master" of github.com:blloon/web-site' with topic 'web' 8 weeks ago
Eugen Martin created GitCommit:'remove download-app.scss, cleanup related content' with topic 'css' 11 weeks ago
Eugen Martin created GitCommit:'remove a couple of js & css resources' with topic 'css' 11 weeks ago
Eugen Martin created GitCommit:'remove a couple of js & css resources' with topic 'js' 11 weeks ago
Eugen Martin created GitCommit:'cleanup basic.js, remove holding.js cleanup turbine.js some cleaning on head.thml.haml' with topic 'js' 11 weeks ago
Eugen Martin created GitCommit:'remove appUi, hero, heroParallax' with topic 'hero' 11 weeks ago
Eugen Martin created GitCommit:'remove advanced.js' with topic 'js' 11 weeks ago
```

## License

[MIT](http://opensource.org/licenses/MIT)
