build:
	docker build -t index.alauda.cn/fanlin/browser-base .
push:
	docker push index.alauda.cn/fanlin/browser-base
clean:
	for i in $$(docker images | grep "<none>" | awk "{print \$$3}"); do docker rmi -f $$i; done
