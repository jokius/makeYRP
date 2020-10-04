# frozen_string_literal: true

desc 'Restart anycable'
namespace :anycable do
  task :restart do
    on roles(:app) do
      sudo :systemctl, 'restart', 'anycable-go'
      sudo :systemctl, 'restart', 'anycable-rpc'
    end
  end
end
