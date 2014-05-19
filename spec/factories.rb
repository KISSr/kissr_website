FactoryGirl.define do
  factory :site do
    user

    sequence :name do |n|
      "test#{n}"
    end
  end

  factory :user do
    dropbox_user_id '123'
  end
end
