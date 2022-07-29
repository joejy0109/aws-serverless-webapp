# AWS 서버리스 웹 호스팅

## 외부 라이브러리 패키징
```bash
# AWS Lambda layer에 등록할 런타임 계층에 맞도록 설치
# 참고: https://docs.aws.amazon.com/ko_kr/lambda/latest/dg/configuration-layers.html#configuration-layers-compile
(.venv) pip install -r requirements.txt -t package/python/

cd package

# zip으로 아카이브 생성
zip -r packages.zip python

# S3 업로드
aws s3 cp packages.zip s3://<bucket-name>/
```