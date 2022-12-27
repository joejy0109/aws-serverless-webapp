# AWS Multiple Lambdas with API Gateway + DaynamoDB

## 외부 라이브러리 패키징 (비즈니스 Tier 구성도 동일)

다중 람다 모듈에서 공용으로 사용하기 위해 레이어(Layer) 계층에 위치할 라이브러리를 패키징합니다.

```bash
# AWS Lambda layer에 등록할 런타임 계층에 맞도록 설치
# 참고: https://docs.aws.amazon.com/ko_kr/lambda/latest/dg/configuration-layers.html#configuration-layers-compile
(.venv) pip install -r ./requirements.txt -t $(pwd)/mutiple-handlers/.package/python/

# 사용자 정의 모듈
(.venv) pip install $(pwd)/extentions/python/my_comm -t $(pwd)/mutiple-handlers/.package/python/

# zip으로 아카이브 생성
cd $(pwd)/multiple-handlers/.packages
zip -r python_packages.zip python

# S3 업로드
aws s3 cp python_packages.zip s3://<bucket-name>/
```

상기 예제 코드는 `package-python.sh` 스크립트 파일로 대체합니다.
해당 스크립트는 로컬 위치에 외부 라이브러리와 사용자 정의 모듈을 모아 `zip`으로 패키징하고, AWS S3에 업로드는 terraform 실행 시 수행됩니다.

```bash
source ./package-python.sh
```

## Provision the AWS Resources by the Terraform.

테라폼을 사용하여 API Gateway, 다중 Lambda 모듈, 그리고 DynamoDB를 프로비저닝합니다.
**!핵심!** 로컬에 작성한 파이썬 소스는 자동으로 패키징되어 aws에 업로드 되고, 각각의 설정에 맞게 URL Path를 구성하여 호스팅 됩니다.
즉, 별도의 업로드 및 호스팅 등록 절차 없이 소스 모듈 추가 때마다 테라폼을 통해 업로드 및 호스팅 됩니다.

- 파이썬 소스 하나 (.py) 당 하나의 모듈.
- 모듈 당 하나의 하위 경로.
- 각각의 모듈은 Lambda Layer에 등록된 공용 패키지를 참조하여 사용 (모듈당 중복 참조 문제 방지).
- 예제 모듈 위치: `multiple-handlers/src/`.
  - AWS 리소스와 연동하는 예제는 `user.py` 소스만 구현.


## Terraform configuration

위치: `multiple-handlers/terraform/`

### Variables

| Name | Type | Description | Default |
|:--:|:--:|:--|:--:|
|prefix|string|AWS의 모든 리소스명에 붙는 접두사| `jeongyong`|
|aws_region|string|AWS 리전| `ap-northeast-2`|
|apigw_stage|string|AWS API Gateway 스테이지| `$default`|
|lambda_runtime|string|AWS 람다 실행 런타임| `python3.9`|
|lambda_common_handler_name|string|AWS 람다 핸들러 명| `handler`|
|lambda_layer|map(string)|AWS 람다 레이어 계층 구성| `name="serverless-python-layer"`<br/>`filename="python-packages.zip"`|
|lambdas|map(string)|AWS 람다 모듈 구성| **`아래 별도 설명`**|
|default_tags|map(string)|AWS 리소스 공통 Tags| `target:"KDB"`<br/>`owner:"jeongyong.jo"`<br/>`env:"poc"`|

### Lambda 모듈 구성 자동화

Terraform variables 중에 `lambda_layer` 구성을 살펴보면 아래와 같습니다.

```terraform
variable "lambdas" {
  type = map(string)
  default = {
    "user"       = "/users"
    "cookbook"   = "/cookbooks",
    "helloworld" = "/helloworld",
  }
}
```

`default` 항목을 보면 Key와 Value로 구성되어 있는데, Key는 파이썬 소스 모듈명(.py 제외)이고 Value는 호스팅 될 API Gateway 경로입니다.
`"user" = "/users"` 예시 값은 `user.py = <API-Gateway-domain>/users` 와 같습니다.
예시에서는 소스 모듈의 경로와 패키징에 대한 규칙이 정의되어 있는데, 이를 준수하고 항목을 추가하면 계속 동등한 상태로 배포가 가능합니다.

- 소스 모듈 위치: `multiple-handlers/src/`
- 확장 모듈 위치: `extentions/python/`

## Example call after provisioning

```bash
# PREFIX : 배포 후 생성되는 API Gateway 도메인 prefix 값.
# e.g. https://{3uejp8hhb}.execute-api.ap-northeast-2.amazonaws.com 

# 아래 curl 실행 전에 반드시 설정!!!
PREFIX={}; 

# Get all users.
curl -X GET https://$PREFIX.execute-api.ap-northeast-2.amazonaws.com/users/


# Get a user (tom1981@lycos.com)
curl -X GET https://$PREFIX.execute-api.ap-northeast-2.amazonaws.com/users/tom1981@lycos.com

# Put a new user.
curl -X POST https://$PREFIX.execute-api.ap-northeast-2.amazonaws.com/users/ \
-H "ContentType:application/json" \
-d '{"UserId": "bespinglobal@bespinglobal.com",
	"Name": "베시피니어",
    "Age": 25,
    "Gender": "male",
    "Address": "서울시 서초구 강남대로 327 13F 베스핀글로벌"
}'

# Update a user (bespinglobal@bespinglobal.com)
curl -L -X PUT https://$PREFIX.execute-api.ap-northeast-2.amazonaws.com/users/bespinglobal@bespinglobal.com \
-H "ContentType:application/json" \
-d '{
    "Age": 32,
    "Gender": "female",
    "Address": "경기도 용인시 처인구 포곡읍 에버랜드로 199"
}'

# Delete a user (bespinglobal@bespinglobal.com)
curl -X DELETE https://$PREFIX.execute-api.ap-northeast-2.amazonaws.com/users/bespinglobal@bespinglobal.com
```