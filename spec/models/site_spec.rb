require 'spec_helper'

describe Site, 'after save' do
  it 'sets up an s3 webhook' do
    user = create(:user)
    user_url = "#{ENV['DROPBOX_S3_WEBHOOK_URL']}users/#{user.dropbox_user_id}"
    stub_request(:post, user_url).with(:query => hash_including({}))

    site = create(:site, user: user)

    expect(WebMock).to have_requested(:post, user_url).with(
        query: {
          directories: [site.domain]
        }
      )
  end
end
