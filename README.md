docker build -t vairavarumu/deploy-test:v1 .
docker tag ef8158ff2e1f vairavarumu/deploy-test:v1
docker push vairavarumu/deploy-test:v1 
