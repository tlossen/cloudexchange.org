#!/usr/bin/env ruby

def colorize(text, color_code)
  "#{color_code}#{text}\e[0m"
end

def red(text)
  colorize(text, "\e[31m")
end

def green(text)
  colorize(text, "\e[32m")
end

#line = %q{85.179.21.217 - - [19/Dec/2009:22:37:02 +0100] "GET /charts/eu-west-1.windows.m1.small.html HTTP/1.1" 200 1826 "http://www.cloudexchange.org/charts/us-west-1.windows.m1.small.html" "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1.5) Gecko/20091102 Firefox/3.5.5"}

while line = $stdin.readline do
  parts = line.split
  parts[0] = red(parts[0])
  parts[10] = green(parts[10])
  $stdout.puts parts.join(" ")
end