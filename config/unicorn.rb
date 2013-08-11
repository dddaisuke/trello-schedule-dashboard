worker_processes 2
@app = '/home/deployer/trello-schedule-dashboard/current'
listen '/tmp/unicorn.sock'
pid '/tmp/unicorn.pid'
stderr_path File.expand_path('unicorn.log', File.dirname(__FILE__) + '/../log')
stdout_path File.expand_path('unicorn.log', File.dirname(__FILE__) + '/../log')
preload_app true
