build:
	docker build -t index.alauda.cn/fanlin/browser-chrome-9 .
run:
	docker run -P --rm index.alauda.cn/fanlin/browser-chrome-9
push:
	docker push index.alauda.cn/fanlin/browser-chrome-9
clean:
	for i in $$(docker images | grep "<none>" | awk "{print \$$3}"); do docker rmi -f $$i; done
