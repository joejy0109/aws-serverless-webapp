import setuptools

with open("README.md", "r") as f:
    long_description = f.read()

setuptools.setup(
    name='my-comm',  # 패키지 명
    version='0.0.1',
    description='The package for testing',
    author='jeongyong.jo',
    author_email='joejy0109@gmail.com',
    long_description=long_description,
    long_description_content_type="text/markdown",
    url='https://github.com/joejy0109',
    license='MIT',  # MIT에서 정한 표준 라이센스 따른다
    py_modules=['my_response'],  # 패키지에 포함되는 모듈
    python_requires='>=3',
    install_requires=[],  # 패키지 사용을 위해 필요한 추가 설치 패키지
    # packages=['my_comm']  # 패키지가 들어있는 폴더들
    packages=setuptools.find_packages(),
)
