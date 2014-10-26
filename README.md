# 안심이 ansim.me

안심이는 시민에게 안전 정보를 제공하는 플랫폼입니다.

2012 8월 공공데이터캠프에서 아이디어를 얻어 구현하였고, 그 이후에 4명의 관심자들이 종종 만나면서 시민이 안심할 수 있도록 하는 데이터를 좀 더 찾아 제공하려고 노력하고 있습니다.

## 개발 환경 구축하기

`ruby 2.1.2, rails 4.`

### Vagrant [|veɪgrənt]
Vagrant는 ruby로 작성한 개발 환경 구축을 위한 도구로써, 개발 환경 구축하는데 드는 시간을 줄일 수 있으며 각각 다른 OS나 환경의 개발자들이 동일한 개발 환경에서 협업할 수 있습니다.

가장 큰 특징은 게스트 OS (vagrant가 제어하는 가상머신)의 자원을 활용하면서 개발자가 사용하는 머신의 호스트 OS에서 소스를 편집할 수 있다는 점입니다. 호스트 OS의 디렉토리를 게스트 OS에 마운트시키고 그 소스를 게스트 OS에서 돌리는 겁니다. 예를 들면 윈도우나 맥을 사용하는 개발자가 리눅스 기반의 환경에서 돌아가는 프로젝트를 이미 사용 중인 개발도구나 소스 편집기를 활용해서 개발할 수 있다는 거죠~

* [vagrant](https://www.vagrantup.com)
* [virtualbox](https://www.virtualbox.org)

```
# clone this repo!
cd ansim.me
git checkout develop
vagrant up
# open http://localhost:3000
# rock & roll!
```

### cloud 9
2014 코드나무 해커톤의 열악한 인터넷 환경에서 600MB 이상의 소프트웨어를 내려받을 수가 없어서 그 놈의 클라우드 개발 환경을 구축해서 개발을 진행했습니다. 물론 로컬에서보다 제약이 많지만 플랫폼에 상관없이 누구나 개발에 참여할 수 있습니다.
```
# go, get your account at c9.io.
# add workspace.

# install ruby
rvm install 2.1.2
gem install bundler

cd ansim.me
git checkout develop

# 터미널 하나 더 열러서 실행. open new terminal window
sudo mongod --smallfiles

# 기존 터미널에서 실행. 몽고디비 덤프 내려받아 압축풀기
cd ./tmp
# ansim-2014-2.tar.gz (2014-10-25): 약국 정보 추가
curl -L https://doc-0c-30-docs.googleusercontent.com/docs/securesc/ha0ro937gcuc7l7deffksulhg5h7mbp1/u5par7fcic5cv4cshvp4e7fu6t157hkm/1414281600000/09194925479248021352/\*/0B8WezMmea38UWlhNS1lyblk0bHc\?e\=download | tar xvz

# 디비 덤프 복원
mongorestore --db ansim_me_development ./dump/ansim_me_development
rm ansim-201401.tar.gz
rm -rf ./dump/ansim_me_development

# 레일즈 run!
bundle install
rails s -p $PORT -b $IP
```

## 기여하기
우리의 안전을 중요하게 생각하는 분들의 진심어린 참여를 기다리고 있습니다. 현재는 개발자 중심으로 프로젝트를 끌어가고 있습니다만, 불편한 디자인이나 기능, 오작동 등은 [이슈](https://github.com/peace-code/ansim.me/issues)를 등록해주시거나 오타를 수정하시고, 코드를 커밋해주시면 @.@!

1. 일단 [포크](https://github.com/peace-code/ansim.me/fork)하세요!
2. 피처 브랜치를 만들어요. `git checkout -b my-new-feature`
3. 수정사항을 커밋하세요. `git commit -am 'Add some feature'`
4. 만든 피처 브랜치로 푸시하세요 `git push origin my-new-feature`
5. 땡겨달라고 요청(Pull Request)하세요 :D

## 이력

2012년 공공데이터캠프 참가

## 크레딧
팀 피스 코드(Team peace code)
권오현, 이정표, 김성준, 최명진, 홍영택


## 라이선스
[BEERWARE-LICENSE](https://raw.githubusercontent.com/peace-code/ansim.me/master/BEERWARE-LICENSE)
