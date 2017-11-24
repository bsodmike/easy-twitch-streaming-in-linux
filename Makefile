build:
	@docker-compose -p rtmp build
run:
	@docker-compose -p rtmp up -d master
stop:
	@docker-compose -p rtmp stop
clean-images:
	@docker rmi `docker images -q -f "dangling=true"`
