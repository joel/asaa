# frozen_string_literal: true

from = ARGV[0]
to = ARGV[1]

exit(1) if from.nil? || to.nil?

require "fileutils"

Dir["./**/*.{rb,scss,js,erb}"].each do |file_path|
  next unless /#{from}/.match?(file_path)

  puts file_path.gsub(/#{from}/, to)

  target_file_path = file_path.gsub(/#{from}/, to)
  FileUtils.mkdir_p(File.dirname(target_file_path))
  File.rename(file_path, target_file_path)
end
