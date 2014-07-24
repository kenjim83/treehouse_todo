FactoryGirl.define do
  factory :user do
    first_name              "Kenji"
    last_name               "Miwa"
    sequence(:email) { |n| "user#{n}@odot.com" }
    password                "123456"
    password_confirmation   "123456"
  end

  factory :todo_list do
    title           "MyString"
    description     "My Description"
  end
end

