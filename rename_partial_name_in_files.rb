from = ARGV[0]
to = ARGV[1]

exit(1) if from.nil? || to.nil?

Dir["./**/*.rb"].each do |file_path|
  original_file_name = File.basename(file_path, '.*')
  next unless original_file_name =~ /#{from}/

  puts file_path.gsub(/#{from}/, to)

  File.rename(file_path, file_path.gsub(/#{from}/, to))
end
