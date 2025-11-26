# Puma configuration file for development
# File: config/puma/development.rb

# The configuration is initialized with a number of defaults that
# are appropriate for the development environment

# Specifies the `port` that Puma will listen on
port ENV.fetch("PORT", 3000)

# Specifies the `environment` that Puma will run in
environment "development"

# Store the PID for the server
pidfile "tmp/pids/server.pid"

# Allow puma to be restarted by `bin/rails restart` command
plugin :tmp_restart

# Use a different clusterer for development if needed
# workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Specifies the `worker_timeout` threshold that Puma will use to wait before
# terminating a worker in development environments.
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked web server processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
# workers ENV.fetch("WEB_CONCURRENCY") { 4 }

# Use `preload_app!` to boot the application in the master process before
# forking worker processes, to avoid booting the application multiple times.
# This is not recommended for development because it can mask issues that
# only appear when workers are forked.
#
# preload_app!

# The code in the `on_worker_boot` will be called if you are using
# clustered mode by specifying a number of `workers`. After each worker
# process is booted, this block will be run.
#
# on_worker_boot do
#   # Valid on 3.4+ and will be the default behavior in 4.0+
#   ActiveRecord::Base.establish_connection
# end

# The code in the `before_fork` will be called before workers are forked in
# clustered mode.
#
# before_fork do
#   ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
# end

# Specifies the `thread` size of the thread pool as a minimum of x and maximum of y.
# The specified size is used to determine the number of threads that can run concurrently.
# This is necessary in a memory-constrained environment where creating many thread objects
# would be prohibitive.
#
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# Allow nodes to be replaced without asking for a maintenance window.
# phased_restart