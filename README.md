docker build -t vairavarumu/deploy-test:v1 .
docker tag ef8158ff2e1f vairavarumu/deploy-test:v1
docker push vairavarumu/deploy-test:v1 
git remote set-url origin git@github.com:vairavarmugam/deploy-test.git
git add .
git status
git commit -m "files added"
git push
