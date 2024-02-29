#!/usr/bin/env ruby
puts ARGV[0].scan(/[A-Z]/).join
puts ARGV[0].scan(/[A-Z]*/).join
puts ARGV[0].scan(/\p{Lu}/).join
