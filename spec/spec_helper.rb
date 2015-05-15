require "arproxy/plugin/mysql_casual_log"
require "stringio"
require "time"
require "timecop"

ENV["TZ"] = "UTC"
include Term::ANSIColor
