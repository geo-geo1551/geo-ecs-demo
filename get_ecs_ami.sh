#/bin/sh

aws ssm get-parameters --names /aws/service/ecs/optimized-ami/amazon-linux/recommended | jq -r '.Parameters[].Value' | jq -r -j '.image_id' > ecs-ami.txt
