# Puma configuration file for production
# File: config/puma/production.rb

# Specifies the `port` that Puma will listen on
port ENV.fetch("PORT") { 3000 }

# Specifies the `environment` that Puma will run in
environment "production"

# Store the PID for the server
pidfile "/var/www/pids/puma.pid"
state_path "/var/www/pids/puma.state"

# How many worker processes puma should run
workers ENV.fetch("WEB_CONCURRENCY") { 4 }

# How many threads to use in each worker process
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# Preload the application before starting workers
preload_app!

# Restart workers after this amount of time
worker_timeout 3600

# Use different clusterer for production
# cluster_mode

# Allow nodes to be replaced without asking for a maintenance window.
phased_restart

# The code in the `on_worker_boot` will be called if you are using
# clustered mode by specifying a number of `workers`. After each worker
# process is booted, this block will be run.
on_worker_boot do
  # Valid on 3.4+ and will be the default behavior in 4.0+
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

# The code in the `before_fork` will be called before workers are forked in
# clustered mode.
before_fork do
  ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
end

# Enable the `stats` endpoint to show puma's internal state.
# stats "/var/run/puma/puma.stats"

# Redirect STDOUT and STDERR to files
stdout_redirect "/var/log/puma/access.log", "/var/log/puma/error.log", true

# Use a custom bind socket for production
# bind "unix:///var/run/puma.sock"

# Use a different bind for production if needed
# bind "ssl://0.0.0.0:#{ENV.fetch('PORT') { 3000 }}?key=path_to_key&cert=path_to_cert&verify_mode=none"