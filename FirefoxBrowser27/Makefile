build:
	docker build -t index.alauda.cn/fanlin/browser-firefox-27 .
run:
	docker run -P --rm index.alauda.cn/fanlin/browser-firefox-27
push:
	docker push index.alauda.cn/fanlin/browser-firefox-27
clean:
	for i in $$(docker images | grep "<none>" | awk "{print \$$3}"); do docker rmi -f $$i; done
