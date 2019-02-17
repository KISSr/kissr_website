require 'httparty'

namespace :dropbox do
  desc "Upgrade to the Dropbox API v2"
  task upgrade_from_v1_to_v2: :environment do
    User.all.each do |user|
    # curl -X POST https://api.dropboxapi.com/2/auth/token/from_oauth1 \
    #       --header "Authorization: Basic MnV3b2J3MDkxcHN2b24yOm9tN2hybDVkNHloY2VvaQ==" \
    #           --header "Content-Type: application/json" \
    #               --data "{\"oauth1_token\": \"qievr8hamyg6ndck\",\"oauth1_token_secret\": \"qomoftv0472git7\"}"


      puts ENV["DROPBOX_SECRET"]
      puts HTTParty.post(
        "https://api.dropboxapi.com/2/auth/token/from_oauth1",
        headers: {
          'Content-Type' => 'application/json',
          "Authorization" => "Basic MnV3b2J3MDkxcHN2b24yOm9tN2hybDVkNHloY2VvaQ==",
        },
        body: {
          "oauth1_token": user.token,
          "oauth1_token_secret": ENV["DROPBOX_SECRET"],
        }.to_json).body
    end
  end
end
