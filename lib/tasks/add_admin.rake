# frozen_string_literal: true

task :add_admin, [:email] => :environment do |_, args|
  User.find_by(email: args.email)&.update(admin: true)
end
