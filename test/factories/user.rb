FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "test#{n}@test.com"
    end
    password 'secret_password'
  end
end