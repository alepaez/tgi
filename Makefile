world:
	bundle exec rake db:drop
	bundle exec rake db:create
	bundle exec rake db:migrate
	RAILS_ENV='test' bundle exec rake db:drop
	RAILS_ENV='test' bundle exec rake db:create
	RAILS_ENV='test' bundle exec rake db:migrate
