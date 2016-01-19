IMAGENAME=rtyler/presentation-base
TAG=$(shell date '+%Y%m%d_%H%M%S')

image :
	docker build -t ${IMAGENAME} .

tag :
	docker tag ${IMAGENAME} ${IMAGENAME}:${TAG}

push :
	docker push ${IMAGENAME}



