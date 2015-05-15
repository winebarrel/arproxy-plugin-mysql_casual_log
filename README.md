# Arproxy::Plugin::CasualLog

Plug-in that colorize the bad query for [Arproxy](https://github.com/cookpad/arproxy).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'arproxy-plugin-casual_log'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install arproxy-plugin-casual_log

## Usage

```ruby
Arproxy.configure do |config|
   config.adapter = "mysql2"
  config.plugin :casual_log
end
```
