class DropboxSyncer
  def initialize(user)
    Aws.config.update(
      region: 'us-east-1',
      credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
    )
    @user = user
  end

  def sync
    client = @user.dropbox_client
    s3 = Aws::S3::Resource.new
    bucket = s3.bucket('kissr')
    loop {
      if @user.cursor
        result = client.list_folder_continue(@user.cursor)
      else
        result = client.list_folder("", recursive: true)
      end

      result.entries.each do |entry|
        if entry.to_hash[".tag"] == "file"
          client.download(entry.path_lower) do |body|
            object = bucket.object(entry.path_display[1..-1])
            object.put({acl: "public-read", body: body})  
          end
        end
      end

      # @user.update_attribute(:cursor, result.cursor)
      break if !result.has_more?
    }
  end
end
