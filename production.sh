#!/bin/bash

git pull
bundle
RAILS_ENV=production rails db:migrate
RAILS_ENV=production rails assets:precompile
RAILS_ENV=production rails assets:clean
RAILS_ENV=production bin/delayed_job restart
touch tmp/restart.txt