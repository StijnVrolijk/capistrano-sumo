namespace :sumo do
  namespace :notifications do
    desc 'Notify our webhooks on a deploy'
    task :deploy do
      # fetch the revision from the web-server
      on roles(:web) do
        set :revision, capture("cat #{current_path}/REVISION")
      end

      run_locally do
        execute :curl,
                '-sS',
                "--data local_username=#{ENV["USER"]}",
                "--data stage=#{fetch(:stage)}",
                "--data repo=#{fetch(:repo_url)}",
                "--data revision=#{fetch(:revision)}",
                'http://bot.sumo.sumoapp.be:3001/deploy/hook'
      end
    end
  end
end
