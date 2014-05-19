require 'spec_helper'

describe User, 'after save' do
  it 'sets up an s3 webhook' do
    user = build(:user)
    user_url = "#{ENV['DROPBOX_S3_WEBHOOK_URL']}users"
    stub_request(:post, user_url).with(:query => hash_including({}))

    user.save

    expect(WebMock).to have_requested(:post, user_url).with(
        query: {
          id: user.dropbox_user_id
        }
      )
  end
end
