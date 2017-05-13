require 'net/sftp'

remote_dowload_path = './Transmission/Downloads/'

Net::SFTP.start('thomasmengelattevps.ddns.net', 'root', :password => '&sxvJl}p') do |sftp|
  sftp.dir.foreach("./Transmission/Downloads/") do |entry|
    if entry.name != '.' && entry.name != '..'
      if !File.exist?("#{entry.name}")
        sftp.download!("#{remote_dowload_path}#{entry.name}", "#{entry.name}", read_size: 65536 ) do |event, downloader, *args|
          case event
          when :open then
            # args[0] : file metadata
            puts "starting download: #{args[0].local}}"
          when :get then
            # args[0] : file metadata
            # args[1] : byte offset in remote file
            # args[2] : data that was received
            puts "writing #{args[2].length} bytes to #{args[0].local} starting at #{args[1]}"
          when :close then
            # args[0] : file metadata
            puts "finished with #{args[0].remote}"
          when :mkdir then
            # args[0] : local path name
            puts "creating directory #{args[0]}"
          when :finish then
            puts "all done!"
            sftp.remove!("#{remote_dowload_path}#{entry.name}")
          # puts "#{remote_dowload_path}#{entry.name}"
          end
        end
      end
    end
  end
end
