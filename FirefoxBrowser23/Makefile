build:
	docker build -t index.alauda.cn/fanlin/browser-firefox-23 .
run:
	docker run -P --rm index.alauda.cn/fanlin/browser-firefox-23
push:
	docker push index.alauda.cn/fanlin/browser-firefox-23
clean:
	for i in $$(docker images | grep "<none>" | awk "{print \$$3}"); do docker rmi -f $$i; done
