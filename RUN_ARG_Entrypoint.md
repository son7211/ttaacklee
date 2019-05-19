The ARG instruction defines a variable that users can pass at build-time to the builder with the docker build command using the --build-arg <varname>=<value> flag. 
The ENV instruction sets the environment variable <key> to the value <value>. The environment variables set using ENV will persist when a container is run from the resulting image. 
But you can combine both by:
building an image with a specific ARG
using that ARG as an ENV
That is, with a Dockerfile including:
ARG var
ENV var=${var}

You can then either build an image with a specific var value at build-time (docker build --build-arg var=xxx), or run a container with a specific runtime value (docker run -e var=yyy)

ARG
docker build 커맨드로 docker image를 빌드할때 설정 할 수 있는 옵션 들을 지정해준다. 예를 들어:
ARG env
ARG log_level=debug
위의 경우 docker build 커맨드로 빌드할때 --build-arg 옵션을 사용하여 env 와 log_level 값을 설정 해줄수 있다.
docker build --build-arg env=prod -t test/test:v1 .
Secrete key나 계정 비밀번호 같은 민감한 정보는 이러한 방식으로 지정하지 않는걸 권한다. 이렇게 지정하면 image에 그대로 남아있기 때문에 image가 노출되면 정보 또한 노출될수 있다.
ENV
Environment variable을 지정할때 ENV instruction을 사용하면 된다. ENV instruction로 지정한 환경변수 는 $variable_name이나 ${variable_name}으로 사용될 수 있다:
FROM busybox
ENV FOO /bar
WORKDIR ${FOO}   # WORKDIR /bar
ADD . $FOO       # ADD . /bar
COPY \$FOO /quux # COPY $FOO /quux
${variable_name} syntax를 사용하면 아래와 같은 옵션도 가능하다:
${variable:-word}: variable이 만일 정의가 안되어 있으면 word 부분의 값이 사용된다.
${variable:+word}: 위에와 밴다의 경우다. variable이 정의가 되어있으면 word 부분의 값이 사용된다. 정의가 안되어 있으면 empty string으로 지정된다.
ENV instruction으로 지정된 환경변수는 docker image를 실행 시킬때 -e 옵션을 사용해서 override 할 수 있다:
docker run -e FOO='/something-else' test


ENTRYPOINT
Docker image가 실행될때 실행되어야할 기본 command를 지정한다. CMD와 비슷하지만 CMD는 override 가 가능하지만 ENTRYPOINT 는 override 할 수 없다. 대신에 docker run 커맨드로 추가하는 커맨드 들은 ENTRYPOINT instruction에 지정된 커맨드에 옵션으로 추가된다:
ENTRYPOINT ["/usr/sbin/nginx"]

...

$ docker run -t -i test/test:v1 -g "daemon off"
위의 경우 /usr/sbin/nginx -g "daemon off" 커맨드가 실행된다.
CMD 와 ENTRYPOINT를 혼합해서 사용할 수 도 있다. CMD 로 지정된 옵션은 만일 docekr run 커멘드로 아무런 커맨드가 추가되지 않으면 default로 추가된다.
ENTRYPOINT ["/usr/sbin/nginx"]
CMD ["-h"]

...


$ docker run -t -i test/test:v1 -g "daemon off"  # « nginx -g "daemon off" 실행
$ docker run -t -t test/test:v1 # « nginx -h 실행
만약 정말로 ENTRYPOINT instruction 으로 지정된 커맨드를 override 해야 한다면 --entrypoint 옵션을 사용해서 할 수 있다.

ENTRYPOINT
ENTRYPOINT는 컨테이너가 시작되었을 때 스크립트 혹은 명령을 실행합니다. 즉 docker run 명령으로 컨테이너를 생성하거나, docker start 명령으로 정지된 컨테이너를 시작할 때 실행됩니다. ENTRYPOINT는 Dockerfile에서 단 한번만 사용할 수 있습니다.
셸(/bin/sh)로 명령 실행하기
Dockerfile
ENTRYPOINT touch /home/hello/hello.txt

ENTRYPOINT <명령> 형식이며 셸 스크립트 구문을 사용할 수 있습니다. FROM으로 설정한 이미지에 포함된 /bin/sh 실행 파일을 사용하게 되며 /bin/sh 실행 파일이 없으면 사용할 수 없습니다.
셸 없이 바로 실행하기
Dockerfile
ENTRYPOINT ["/home/hello/hello.sh"]
Dockerfile
ENTRYPOINT ["/home/hello/hello.sh", "--hello=1", "--world=2"]

ENTRYPOINT ["<실행 파일>", "<매개 변수1>", "<매개 변수2>"] 형식입니다. 실행 파일과 매개 변수를 배열 형태로 설정합니다. FROM으로 설정한 이미지의 /bin/sh 실행 파일을 사용하지 않는 방식입니다. 셸 스크립트 문법이 인식되지 않으므로 셸 스크립트 문법과 관련된 문자를 그대로 실행 파일에 넘겨줄 수 있습니다.
CMD와 ENTRYPOINT는 컨테이너가 생성될 때 명령이 실행되는 것은 동일하지만 docker run 명령에서 동작 방식이 다릅니다.
다음과 같이 Dockerfile에서 CMD로 echo 명령을 사용하여 hello를 출력합니다.
Dockerfile
FROM ubuntu:latest
CMD ["echo", "hello"]
컨테이너를 생성할 때 docker run <이미지> <실행할 파일> 형식인데 이미지 다음에 실행할 파일을 설정할 수 있습니다. docker run 명령에서 실행할 파일을 설정하면 CMD는 무시됩니다.
$ sudo docker build --tag example .
$ sudo docker run example echo world
world
CMD ["echo", "hello"]는 무시되고 docker run 명령에서 설정한 echo world가 실행되어 world가 출력되었습니다. docker run 명령에서 설정한 <실행할 파일>과 Dockerfile의 CMD는 같은 기능입니다.

이제 ENTRYPOINT입니다. 다음과 같이 Dockerfile에서 ENTRYPOINT로 echo 명령을 사용하여 hello를 출력합니다.
Dockerfile
FROM ubuntu:latest
ENTRYPOINT ["echo", "hello"]
Dockerfile을 빌드하여 docker run 명령으로 실행합니다. docker run 명령에서 실행할 파일을 설정하면 ENTRYPOINT 무시되지 않고, 실행할 파일 설정 자체를 매개 변수로 받아서 처리합니다.
$ sudo docker build --tag example .
$ sudo docker run example echo world
hello echo world
ENTRYPOINT ["echo", "hello"]에서 echo hello가 실행되어 hello가 출력되고, docker run 명령에서 설정한 내용이 ENTRYPOINT ["echo", "hello"]의 매개 변수로 처리되어 echo world도 함께 출력됩니다. 셸에서는 다음과 같이 표현할 수 있습니다.
$ echo hello echo world
hello echo world
echo 명령 아닌 다른 방식으로 실행해봅니다. 다음과 같이 1 2 3 4를 넘겨주면 그대로 1 2 3 4가 출력됩니다.
$ sudo docker run example 1 2 3 4
hello 1 2 3 4
ENTRYPOINT는 docker run 명령에서 --entrypoint 옵션으로도 설정할 수 있습니다. --entrypoint 옵션으로 cat을 실행하고 /etc/hostname 파일의 내용을 출력합니다.
$ sudo docker run --entrypoint="cat" example /etc/hostname
9efe43ea4d40
--entrypoint 옵션을 설정하면 Dockerfile에 설정한 ENTRYPOINT는 무시됩니다.

CMD
CMD를 사용하여 docker container가 시작할때 실행할 커맨드를 지정할수 있다. RUN instruction 과 기능은 비슷하지만 차이점은 CMD는 docker image를 빌드할때 실행되는 것이 아니라 docker container가 시작될때 실행된다는 것이다. 주로 docker image로 빌드된 application을 실행할때 쓰인다:
CMD ["python", "main.py"]
참고로 CMD instruction 으로 지정된 커맨드들은 docker run 커맨드로 실행시킬때 override 할 수 있다. 그러므로 Dockerfile 에서는 CMD로 디폴트 커맨드를 지정하고 실제 docker run 커맨드를 실행시킬때는 다른 적절한 커맨드를 줄수 있다.
